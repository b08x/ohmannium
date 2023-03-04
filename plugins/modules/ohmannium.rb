#!/usr/bin/ruby
# WANT_JSON

require 'json'
require 'logging'
require 'open3'
require 'rubygems'

$logfile = File.join("/tmp", "ohmannium-#{Time.now.strftime("%Y-%m-%d")}-packageinstall.log")

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
  :level => :debug
)

Logging.appenders.file(
  $logfile,
  :layout => Logging.layouts.pattern(
    :pattern => '[%d] %-5l %c: %m\n',
    :color_scheme => 'bright'
  ),
  :level => :debug
)

$logger = Logging.logger['ohmannium::packageInstall']

$logger.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file($logfile))

$logger = Logging.logger['Happy::Colors']
$logger.level = :info

currently_installed_packages = `paru -Q | awk '{print $1}'`.split("\n")

data = JSON.load File.read(ARGV[0])

packages = data['packages']
$logger.debug "#{packages}"

def explicitlyInstall(*args)
  require 'open3'
  options = args[-1].is_a?(Hash) ? args.pop : {}

  Open3.popen3 *args do | stdin, stdout, stderr, thread|
    while line = stdout.gets
      $logger.info "#{line.strip.chomp}"
    end
    $logger.warn "#{stderr.read}"
  end
end

changed = false

JSON.parse(packages).each do |group|
  begin
    pkgs = group[1].keep_if {|package| ! currently_installed_packages.include?(package) }.join(" ")

    next if pkgs.empty?

    $logger.info "installing packages from #{group[0]}" unless pkgs.empty?

    explicitlyInstall "paru -S --noconfirm --needed --batchinstall --overwrite '*' #{pkgs}"

  rescue StandardError => e

    $logger.warn "package install failed. probably just a package name conflict "
    $logger.warn "#{e}"
    $logger.warn "trying again"

    if explicitlyInstall "yes | paru -S --needed --batchinstall --overwrite '*' #{pkgs}"
      $logger.info "packages installed successfully"
    else
      print JSON.dump({
        'failed' => true,
        'msg' => "#{packages}"
      })

      exit(1)
    end
    changed = true
  end
end

# we may also wish to return changed=True or changed=False
# if we were modifying system resources to support handlers and change tracking
# if the module decides to not run, it can also return skipped=True

result = {
  'changed' => changed,
  'stdout' => "all of the packages have been installed"
}

print JSON.dump(result)
