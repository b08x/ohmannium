#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ruport'
require 'yaml'

module Soundbot

  class Config

    def self.load_config
      YAML.load_file(CONFIG)
    end

    def self.get(attribute)
      return Config.load_config[attribute]
    end

    def self.set
      File.open(CONFIG, "w") { |file| file.write $CONFIG_DIR.to_yaml }
    end

  end

end

ANSIBLE_HOME = File.join(ENV['HOME'], "Workspace", "syncopated")

vars = Dir.glob

config = Soundbot::Config.load_config

packages = Soundbot::Config.get("packages")

table = Ruport::Data::Table.new

table.column_names = %w[Key Value]

packages.each do |key, value|
  table << [key,value.join("\s")]
end

puts table.to_text


# {% if architecture == 'x86-64-v3' %}
# [syncopated-v3]
# Server = http://soundbot.hopto.org/library/packages/archlinux/x86_64_v3/
# {% endif %}
# [syncopated]
# Server = http://soundbot.hopto.org/library/packages/archlinux/x86_64/
