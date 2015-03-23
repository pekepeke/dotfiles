require 'mysql2'
require 'mysql2-cs-bind'

dbh = Mysql2::Client.new(
  :host => "localhost",
  :username => "root",
  :password => "root",
  :database => "",
  :encoding => 'utf8',
  :socket => "/usr/local/var/run/mysql/mysql.sock",
)
dbh.query("select * from table limit 1").each do |row|
  p row
end

dbh.xquery("select * from table WHERE id = ? limit 1", 1).each do |row|
  p row
end
