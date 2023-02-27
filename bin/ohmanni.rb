#!/usr/bin/env ruby
# frozen_string_literal: true

APP_ROOT = File.expand_path(File.join(__dir__, '..'))
LIB = File.join(APP_ROOT, 'lib')

$LOAD_PATH.unshift LIB unless $LOAD_PATH.include?(LIB)

ANSIBLE_CONFIG = File.join(APP_ROOT, "ansible.cfg")
ANSIBLE_PLAYBOOKS = File.join(APP_ROOT, "playbooks")
ANSIBLE_VARS = File.join(ANSIBLE_PLAYBOOKS, "vars")
ANSIBLE_TASKS = File.join(ANSIBLE_PLAYBOOKS, "tasks")

def progname; "ohmanni"; end

require 'colorized_string'
require 'logging'
require 'tty-command'
require 'yaml'

$logger = Logging.logger(File.join("/tmp", "#{progname}-packageinstall.log"))
#$logger = Logging.logger(STDOUT)
$logger.level = :warn

module Command
  module_function

  def run(*args)
    cmd = TTY::Command.new(printer: :pretty)
    result = cmd.run(args.join(' '), only_output_on_error: true)
    return result
  end

  # use this if captured output is desired...
  def tty(*args)
    cmd = TTY::Command.new(output: $logger, uuid: false, timeout: 600)

    begin
      cmd.run(args.join(' '), only_output_on_error: false, pty: true)
    rescue TTY::Command::TimeoutExceeded => e
      $logger.warn "#{args} timeout exceeded"
    end
  end

end


module Ohmanni

  class Packages
    attr_accessor :distro, :packages

    def initialize(distro,packages)
      @distro = distro
      @packages = packages
    end

    def self.update_mirrors
      Command.run("sudo reflector --download-timeout 3 --protocol https \
                             --latest 20 --sort rate --score 10 --fastest 8 \
                             --save /etc/pacman.d/mirrorlist")
      Command.run("paru -Scc --noconfirm && paru -Sy")
    end

    def install

      $logger.info "installing packages"

      currently_installed = `paru -Q | awk '{print $1}'`.split("\n")

      $logger.debug "#{@packages}"
      $logger.debug "------------"

      @packages.each do |group|
        $logger.debug "#{group}"

        pkgs = group[1].keep_if {|pkg| ! currently_installed.include?(pkg) }.join(" ")

        if pkgs.empty?
          $logger.info "#{group[0]} packages already installed"
          next
        end

        begin
          puts ColorizedString["installing #{group[0]} packages:"].colorize(:green)
          puts ColorizedString["#{pkgs}"].colorize(:blue)
          puts ColorizedString["check /tmp/syncopated-packageinstall.log for details"].colorize(:yellow)
          puts ColorizedString["----------------------------------------------------"].colorize(:green)

          Command.tty("paru -S --noconfirm --needed --batchinstall --overwrite '*' #{pkgs}")
          sleep 2
        rescue StandardError => e
          $logger.warn "#{e}"
          puts ColorizedString["initial attempt failed, trying again"].colorize(:red)
          sleep 2
          Command.tty("yes | paru -S --needed --batchinstall --overwrite '*' #{pkgs}")
          sleep 2
        end

      end
    end # end of install method

  end # end Packages class
end #end Soundbot module

if ARGV.any?
  begin
      distro = ARGV[0]
      packages = YAML::load(ARGV[1])
      Ohmanni::Packages.update_mirrors if ARGV[2]
      Ohmanni::Packages.new(distro,packages).install
  rescue StandardError => e
    $logger.warn "#{e.message}"
    printf "#{e}"
  ensure
    printf "package install...."
    exit
  end

end
