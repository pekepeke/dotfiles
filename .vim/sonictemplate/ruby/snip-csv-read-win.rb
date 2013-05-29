require 'csv'

CSV.foreach('path.csv', row_sep: "\r\n", encoding: "cp932:utf-8") do |row|
end
