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

require "logor"
require "packageinstaller"

require "cli"
require 'tty-command'

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



if ARGV.any?
  Drydock.run!(ARGV, $stdin) if Drydock.run? && !Drydock.has_run?
end
