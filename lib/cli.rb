#!/usr/bin/env ruby
# frozen_string_literal: false

require "drydock"
require "highline/import"

module Soundbot
  class CLI
    extend Drydock

    default :welcome
    debug :on

    before do
      puts "hello"
    end

    about "about"
    command :about do |_obj|
      puts "hey...what is this about?!"
    end

    about "setup"
    command :setup do |_obj|
      Soundbot::Packages.new(_obj.argv).install
    end


  end # end cli class
end # end soundbot module
