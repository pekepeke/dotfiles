require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  title = File.basename(File.realpath(File.dirname(__FILE__)))
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "title #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
