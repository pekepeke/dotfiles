module {{_name_}}
  module Helpers
  end
end

Chef::Recipe.send(:include, {{_name_}}::Helpers)

