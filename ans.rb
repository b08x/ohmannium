#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ruport'
require 'yaml'

ANSIBLE_HOME = File.join(Dir.home, "Workspace", "syncopated")

module Soundbot

  class Config

    def self.load_vars(varfile)
      YAML.load_file(varfile)
    end

    def self.get(attribute)
      return Config.load_config[attribute]
    end

    def self.set
      File.open(CONFIG, "w") { |file| file.write $CONFIG_DIR.to_yaml }
    end

  end

end


# allpackages = []
#
# varfiles = Dir.glob(File.join(ANSIBLE_HOME, "roles", "distro", "vars", "packages", "*.yml"))


require 'colorize'

puts "Blue text".blue
puts 'Bold cyan on blue text'.cyan.on_blue.bold
puts "This is #{"fancy".red} text"

exit(0)
# varfiles.each do |varfile|
#
#   allpackages << Soundbot::Config.load_vars(varfile)
#
# end
#
# p allpackages
# #
# packages = Soundbot::Config.get("packages")
#
# table = Ruport::Data::Table.new
#
# table.column_names = %w[Key Value]
#
# packages.each do |key, value|
#   table << [key,value.join("\s")]
# end
#
# puts table.to_text
#
#
