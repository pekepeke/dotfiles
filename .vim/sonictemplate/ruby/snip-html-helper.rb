require 'rack'

module Helper
  include Rack::Utils
  alias :h :escape_html
end

