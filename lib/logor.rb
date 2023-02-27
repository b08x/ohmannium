#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logging'
require 'pathname'
require 'pry-stack_explorer'

LOG_DIR = File.join(APP_ROOT, 'logs')
LOG_MAX_SIZE = 6_145_728
LOG_MAX_FILES = 10

Pathname.new(LOG_DIR).mkdir unless Pathname.new(LOG_DIR).exist?

log_file = File.join(LOG_DIR, "#{progname}-#{Time.now.strftime("%Y-%m-%d")}.log")
osc_log = File.join(LOG_DIR, "#{progname}-#{Time.now.strftime("%Y-%m-%d")}_osc.log")

Logging.color_scheme( 'bright',
  :levels => {
    :info  => :green,
    :warn  => :yellow,
    :error => :red,
    :fatal => [:white, :on_red]
  },
  :date => :blue,
  :logger => :cyan,
  :message => :magenta
)

Logging.appenders.stdout(
  'stdout',
  :layout => Logging.layouts.pattern(
    :pattern => '[%d] %-5l %c: %m\n',
    :color_scheme => 'bright'
  ),
  :level => :warn
)

Logging.appenders.file(
  log_file,
  :layout => Logging.layouts.pattern(
    :pattern => '[%d] %-5l %c: %m\n',
    :color_scheme => 'bright'
  ),
  :level => :debug
)

$logger = Logging.logger['Happy::Colors']

$logger.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file(log_file))

# $logger.add_appenders(
#         Logging.appenders.file(log_file))

$logger.info

def test
  $logger.debug "this is what is happening...all of it"
  $logger.info "basically what is happening"
  $logger.warn "Hey, watch out"
  $logger.error StandardError.new("an error has occurred, continue on to next task")
  $logger.fatal "an error has occured. nothing more can happen."
end

$daemon_options = {
  :log_output => true,
  :backtrace => true,
  :output_logfilename => $osc_log,
  :log_dir =>  LOG_DIR,
  :ontop => false
}
