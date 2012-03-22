set :scm, :subversion
set :repository_root,  ""
set(:tag) { Capistrano::CLI.ui.ask("Tag to deploy(or type 'trunk' to deploy from trunk): ") }
# set :tag, "trunk"
set :repository, (tag == "trunk") ? "#{repository_root}/trunk" : "#{repository_root}/tags/#{tag}"

