set :rails_env, :production
#set :unicorn_binary, "/usr/bin/unicorn"
set :unicorn_binary, "/usr/local/bin/bundle exec unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
#set :_try_sudo, "sudo"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D #{current_path}/config.ru"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "[ -e #{unicorn_pid} ] && #{try_sudo} kill `cat #{unicorn_pid}` ; echo -n"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
