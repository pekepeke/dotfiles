#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# $:.push(File.join(File.dirname(__FILE__), 'lib'))
# require 'rubygems'
# require "bundler"
# Bundler.setup

require 'erb'
require 'rexml/document'

def subl2neosnippet(fpath)
  doc = REXML::Document.new(File.new(fpath))
  desc = doc.elements['//description'].text
  content = doc.elements['//content'].text
  trigger = doc.elements['//tabTrigger'].text
  scope = doc.elements['//scope'].text

  erb = ERB.new(<<-EOS
# #{desc}
snippet #{trigger}
#{content.gsub!(/^/, "\t")}

  EOS
  )
  puts erb.run(binding)
end

def main
  ARGV.each{|p|
    if File.exists?(p) and not File.directory?(p)
      subl2neosnippet(p)
    else
      Dir.glob("#{p}/*.sublime-snippet").each{|p|
        subl2neosnippet(p)
      }
    end
  }
end

if __FILE__ == $0
  main
end

__END__

