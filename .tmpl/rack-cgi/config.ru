require 'rack-legacy'
require 'rack/weinre'

use Rack::Legacy::Index
use Rack::Legacy::Php
use Rack::Legacy::Cgi
use Rack::Weinre, :port => 58080
run Rack::Directory.new '.'

