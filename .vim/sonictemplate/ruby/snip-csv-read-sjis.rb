CSV.foreach(fname, headers: false, row_sep: :auto, encoding: "SJIS") do |row|
  row.map! {|v| v.nil? ? nil : v.encode("UTF-16BE", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")}
end

