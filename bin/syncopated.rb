#!/usr/bin/env ruby
# frozen_string_literal: true

APP_ROOT = File.expand_path(File.join(__dir__, '..'))
LIB = File.join(APP_ROOT, 'lib')

$LOAD_PATH.unshift LIB unless $LOAD_PATH.include?(LIB)

ANSIBLE_CONFIG = File.join(APP_ROOT, "ansible.cfg")
ANSIBLE_PLAYBOOKS = File.join(APP_ROOT, "playbooks")
ANSIBLE_VARS = File.join(ANSIBLE_PLAYBOOKS, "vars")
ANSIBLE_TASKS = File.join(ANSIBLE_PLAYBOOKS, "tasks")

def progname; "syncopated"; end

module Syncopated
  VERSION = "0.9.8"
end

require 'colorized_string'
require 'logging'
require 'tty-command'
require 'yaml'

$logger = Logging.logger(File.join("/tmp", "#{progname}-#{Time.now.strftime("%Y-%m-%d")}.log"))

module Command
  module_function

  def run(*args)
    cmd = TTY::Command.new(printer: :pretty)
    result = cmd.run(args.join(' '), only_output_on_error: true)
    return result
  end

  # use this if captured output is desired...
  def tty(*args)

    cmd = TTY::Command.new(output: $logger, uuid: false, timeout: 60)

    begin
      cmd.run(args.join(' '), only_output_on_error: false, pty: false)
    rescue TTY::Command::ExitError => e
      $logger.debug "#{args} failed with #{e.message}"
    rescue TTY::Command::TimeoutExceeded => e
      $logger.debug "#{args} timeout exceeded"
    end
  end

end


module Soundbot

  class Packages
    attr_accessor :distro, :packages

    def initialize(distro)
      @packages = []
      @distro = distro
      load_vars
    end

    def load_vars
      varfiles = Dir.glob(File.join(ANSIBLE_VARS, "packages", @distro, "*.yml"))
      varfiles.each do |varfile|
        @packages << YAML.load_file(varfile)
      end
    end

    def update_mirrors
      Command.run("sudo reflector --download-timeout 3 --protocol https \
                             --latest 20 --sort rate --score 10 --fastest 8 \
                             --save /etc/pacman.d/mirrorlist")
      Command.run("paru -Scc --noconfirm && paru -Sy")
    end

    def install
      update_mirrors if ARGV[1] == 'update'

      currently_installed = `paru -Q | awk '{print $1}'`.split("\n")

      @packages.each do |pkggroup|
          pkggroup.each do |group|
            pkgs = group[1].keep_if {|pkg| ! currently_installed.include?(pkg) }.join(" ")

            next if pkgs.empty?

            begin
              $logger.info "installing #{group[0]} packages"
              Command.run("yes | paru -S --noconfirm --useask  --needed --batchinstall #{pkgs}")
            rescue StandardError => e
              $logger.warn "#{e}"
            end

          end
      end
    end # end of install method

  end # end Packages class
end #end Soundbot module

if ARGV.any?
  Soundbot::Packages.new(ARGV[0]).install
end
