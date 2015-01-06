require 'csv'

CSV.foreach('path.csv', row_sep: :auto, encoding: "cp932:utf-8") do |row|
end
