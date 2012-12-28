require 'jeweler'
Jeweler::Tasks.new do |gem|
  title = File.basename(File.realpath(File.dirname(__FILE__)))
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = title
  gem.homepage = "{{_expr_:get(g:, 'homepage', '')}}"
  gem.license = "{{_expr_:get(g:, 'license', 'MIT')}}"
  gem.summary = %Q{}
  gem.description = %Q{}
  gem.email = "{{_expr_:get(g:, 'email', '')}}"
  gem.authors = ["{{_expr_:get(g:, 'author', '')}}"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new
