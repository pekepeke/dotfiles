#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# $:.push(File.join(File.dirname(__FILE__), 'lib'))
# require 'rubygems'
# require "bundler"
# Bundler.setup

require 'webrick'

$docroot = Dir.pwd
$sleep_sec = 5
$mount_path = nil # "/img"
$resleep_sec = 30
$sleep_basenames = [
]

server = WEBrick::HTTPServer.new(
  :BindAddress => '0.0.0.0',
  :Port => 4321,
  :DocumentRoot => $docroot,
)

hash = {}

unless $mount_path.nil?
  server.mount_proc($mount_path) do |req, res|
    filename = File.join($docroot, req.path)
    unless hash[req.path].nil?
      hash[req.path] = nil if (Time.now - hash[req.path]) >= $resleep_sec
    end
    unless $sleep_basenames.index(File.basename(req.path)).nil?
      sleep $sleep_sec if hash[req.path].nil?
    end

    hash[req.path] = Time.now
    open(filename) do |file|
      res.body = file.read
    end
    res.content_length = File.stat(filename).size
    res.content_type =
      WEBrick::HTTPUtils.mime_type(req.path, WEBrick::HTTPUtils::DefaultMimeTypes)
  end
end

trap('INT'){ server.shutdown }
server.start

if __FILE__ == $0
end

__END__
