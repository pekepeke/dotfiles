require "net/http"
require 'json'

class ProxyApp
  def port
    if @json.nil?
      fpath = File.join(File.dirname(__FILE__), "package.json")
      @json = JSON.parse(File.read(fpath))
    end
    @json["port"]
  end

  def call(env)
    begin
      request = Rack::Request.new(env)
      headers = {}
      env.each do |key, value|
        if key =~ /^http_(.*)/i
          headers[$1] = value
        end
      end
      http = Net::HTTP.new("localhost", port)
      http.start do |http|
        response = http.send_request(request.request_method, request.fullpath, request.body.read, headers)
        response_headers = response.to_hash
        response_headers.each {|k, v| response_headers[k] = v.join(",") if v.is_a? Array }
        [response.code, response_headers, [response.body]]
      end
    rescue Errno::ECONNREFUSED
      [500, {}, ["Server is down, try $npm start"]]
    end
  end
end

pid = spawn 'node_modules/.bin/coffee', 'server.coffee'

['INT', 'TERM', 'QUIT'].each do |signal|
  trap(signal) do
    puts "Got signal #{signal} -- exit currently #{$EXIT}"
    Process.kill('KILL', pid)
    exit! if $EXIT
    $EXIT = true
    exit!
  end
end

run ProxyApp.new
