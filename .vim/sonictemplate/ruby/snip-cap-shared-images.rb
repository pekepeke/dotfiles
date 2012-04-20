after "deploy", "deploy:link_images"
namespace(:deploy) do
  task :link_images do
    run "ln -s #{shared_path} #{release_path}/public/user_images"
  end
end
