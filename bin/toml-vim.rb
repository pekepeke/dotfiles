#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# $:.push(File.join(File.dirname(__FILE__), 'lib'))
# require 'rubygems'
# require "bundler"
# Bundler.setup

require 'tomlrb'

if __FILE__ == $0
  ARGV.each do |f|
    config = Tomlrb.load_file(f)

    # puts config
    config['plugins'].each do |plug|
      puts '" ' + plug['repo']
      puts plug['hook_add'] if plug.has_key? 'hook_add'
    end
  end
end

__END__
