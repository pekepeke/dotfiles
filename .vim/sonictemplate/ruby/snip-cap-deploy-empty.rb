before "deploy:finalize_update", "deploy:app_prepare"
after "deploy:symlink", "deploy:app_cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
  end
  task :app_prepare do
    # run "#{shared_path}/share"
    # run "#{release_path}/share"
  end
  task :app_cleanup do
    # top.upload "path/to/local", "#{shared_path}/share"
    # run "chmod -R a+w #{current_path}/tmp/"
  end
end

