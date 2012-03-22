set :deploy_to, ""
set :user, "vagrant"
# set :run_method, :sudo
set :use_sudo, false
ssh_options[:keys] = `vagrant ssh-config | grep IdentityFile`.split.last
puts ssh_options[:keys]
server "192.168.33.10", :app, :db, :primary => true
set :deploy_via, :copy

