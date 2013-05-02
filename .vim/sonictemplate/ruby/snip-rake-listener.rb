Listen.to!(File.dirname(__FILE__), :filter => /.*\.(php|js|css|png|gif|jpg)$/) do |modified, added, removed|
  {{_cursor_}}
end
