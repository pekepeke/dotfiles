set :htaccess_username, ""
set :htaccess_password, ""
#set :htaccess_password_hashed, "zJDC6IeGdG8QU"

before "deploy:create_symlink", "deploy:htaccess_protect"

namespace :deploy do
  task :htaccess_protect do
    _cset(:htaccess_username) { abort "Please specify an htaccess username, set :htaccess_username, 'foo'" }
    unless exists?(:htaccess_password_hashed)
      _cset(:htaccess_password) { abort "Please specify htaccess_password or htaccess_password_hashed" }
      set :htaccess_password_hashed, "#{htaccess_password}".crypt('httpauth')
    end

    # This appends to the end of the file, so don't run it multiple times!
    public_path = File.join(release_path, "public")

    run "echo '#{htaccess_username}:#{htaccess_password_hashed}' >> #{File.join(public_path, '.htpasswd')}"
    run "echo 'AuthType Basic' >> #{File.join(public_path, '.htaccess')}"
    run "echo 'AuthName \"Restricted\"' >> #{File.join(public_path, '.htaccess')}"
    run "echo 'AuthUserFile #{File.join(public_path, '.htpasswd')}' >> #{File.join(public_path, '.htaccess')}"
    run "echo 'Require valid-user' >> #{File.join(public_path, '.htaccess')}"
  end
end
