#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'
require 'ruport'
require 'yaml'

ANSIBLE_HOME = File.join(Dir.home, "Workspace", "syncopated")

module Soundbot

  class Packages
    attr_accessor :packages

    def initialize()
      @packages = Hash.new()
      return self
    end

    def load_vars(varfile)
      YAML.load_file(varfile)
    end

    def self.get(attribute)
      return Config.load_vars[attribute]
    end

    # def self.set(varfile)
    #   File.open(varfile, "w") { |file| file.write $varfile_source.to_yaml }
    # end

    # https://stackoverflow.com/a/23521624
    def self.flatten_hash(hash)
      hash.each_with_object({}) do |(k, v), h|
        if v.is_a? Hash
          flatten_hash(v).map do |h_k, h_v|
            h["#{k}.#{h_k}".to_sym] = h_v
          end
        else
          h[k] = v
        end
       end
    end

  end


  class PackageManager
    def initialize(distro)
      case distro
      when Archlinux
        @packagemanager = ""

      end
    end

  end


end


distro = ARGV[0]
#distro = "Archlinux"

allpackages = []

varfiles = Dir.glob(File.join(ANSIBLE_HOME, "playbooks", "vars", "packages", distro, "*.yml"))

varfiles.each do |varfile|
  pkgs = Soundbot::Packages.new

  x = pkgs.load_vars(varfile)

  Soundbot::Packages.flatten_hash(x).each do |kv|
    allpackages << kv.drop(1).flatten
  end

end

currently_installed = `paru -Q | awk '{print $1}'`.split("\n")
p

allpackages.each do |pkggroup|

  begin

    `yes | paru -S --noconfirm --useask \
                   --needed --batchinstall #{pkggroup.join(" ")}`

  rescue StandardError => e

    puts "This is #{e.message.red}"

  end

end




# puts "#{packages}".blue
# puts 'Bold cyan on blue text'.cyan.on_blue.bold
# puts "This is #{"fancy".red} text"

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
