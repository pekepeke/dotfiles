#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# $:.push(File.join(File.dirname(__FILE__), 'lib'))
# require 'rubygems'
# require "bundler"
# Bundler.setup
require 'roo'

module Xls2Csv
  class Command
    def initialize(*paths)
      @paths = paths.flatten
    end

    def run()
      @paths.each do |path|
        Core.new(:path => path).run
      end
    end
  end

  class Core
    def initialize(**attr)
      @path = attr[:path]
      @sheets = attr[:sheets]
    end

    def init
      Xls2Csv::Option
    end

    def run
      ss = Roo::Spreadsheet.open(@path)

      @sheets = ssh.sheets unless @sheets

      @sheets.each do |sheet_name|
        ss.default_sheet = sheet_name
        puts "[#{sheet_name}]"
        puts ss.to_csv()
      end
    end
  end

  module Option
  end

  module Version
    VERSION = '0.0.1'
  end
end

if __FILE__ == $0
  command = Xls2Csv::Command.new(ARGV)
  command.run
end

if __FILE__ == $0
end

__END__
