require 'rack/weinre'

use Rack::Weinre, :port => 58080
run Rack::Directory.new '.'

