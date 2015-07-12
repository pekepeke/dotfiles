#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "optparse"
require 'webrick'
require 'socket'
require 'timeout'

def port_open?(port, ip = "127.0.0.1", seconds=1)
  Timeout::timeout(seconds) do
    begin
      TCPSocket.new(ip, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      false
    end
  end
rescue Timeout::Error
  false
end

def run_server(port, with_ssl = false)
  port = 0 if port_open?(port)
  opt = {
    :BindAddress => '0.0.0.0',
    :Port => port,
    # :DocumentRoot => File.join(Dir::pwd, 'test_htmls'),
    # :DocumentRoot => File.dirname(__FILE__),
    :DocumentRoot => Dir::pwd,
  }
  if with_ssl
    opt[:SSLEnable] = true
    opt[:SSLCertName] = [['CN', WEBrick::Utils::getservername ]]
  end

  s = WEBrick::HTTPServer.new(opt)

  trap('INT'){ s.shutdown }
  s.start
end

if __FILE__ == $0
  port = 50080
  with_ssl = false

  ARGV.options do |opt|
    opt.on('-p', 'port no') {|v| 
      port = v
    }
    opt.on('-s', 'use ssl') {
      with_ssl = true
    }
    opt.parse!
  end

  run_server port, with_ssl
end

__END__
