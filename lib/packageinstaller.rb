#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorized_string'
require 'ruport'
require 'yaml'

ANSIBLE_HOME = APP_ROOT

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

    def self.get(varfile,attribute)
      return YAML.load_file(varfile)[attribute]
    end

    def self.set(varfile)
      File.open(varfile, "w") do |file|
        file.write $varfile_source.to_yaml
      end
    end

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

    def update_mirrors
      Command.run("sudo reflector --download-timeout 3 --protocol https \
                             --latest 20 --sort rate --score 10 --fastest 8 \
                             --save /etc/pacman.d/mirrorlist")
      Command.run("paru -Scc --noconfirm && paru -Sy")
    end

    def install
      #update_mirrors

      currently_installed = `paru -Q | awk '{print $1}'`.split("\n")

      @packages.each do |pkggroup|
        pkggroup.each do |group|
          pkgs = group[1].keep_if {|pkg| ! currently_installed.include?(pkg) }.join(" ")
          next if pkgs.empty?

          begin
            # `yes | paru -S --noconfirm --useask  --needed --batchinstall #{pkgs}`
            Command.run("yes | paru -S --noconfirm --useask  --needed --batchinstall #{pkgs}")
          rescue StandardError => e
            $logger.warn "#{e}"
          end

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


# distro = "Archlinux"
#
# allpackages = []
#
#  varfiles = Dir.glob(File.join(ANSIBLE_VARS, "packages", distro, "*.yml"))
#
# varfiles.each do |varfile|
#   pkgs = Soundbot::Packages.new
#
#   x = pkgs.load_vars(varfile)
#
#   Soundbot::Packages.flatten_hash(x).each do |kv|
#     allpackages << kv.drop(1).flatten
#   end
#
# end
#
#currently_installed = `paru -Q | awk '{print $1}'`.split("\n")
#
# allpackages.each do |pkggroup|
#
#   begin
#
#     `yes | paru -S --noconfirm --useask  --needed --batchinstall #{pkggroup.join(" ")}`
#
#   rescue StandardError => e
#     puts "This is #{e.message.red}"
#
#     `paru -S --needed --batchinstall #{pkggroup.join(" ")}`
#
#   end
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
