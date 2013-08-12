require 'logger'
require 'active_record'

ActiveRecord::Base.logger = Logger.new($stderr)
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), "../data/database.db"),
  :timeout => 5000,
  :encoding => "utf8"
)

