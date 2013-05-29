require 'csv'

header = []
csv_str = CSV.generate({:headers => header, :write_headers => true}) do |csv|
  csv << []
end
puts csv_str.encode("cp932", {:crlf_newline => true})

