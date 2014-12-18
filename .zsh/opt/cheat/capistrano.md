```bash
# make stage
cap install STAGES=local,sandbox,qa,production

# show task list
cap -T

# deploy
cap staging deploy --dry-run
cap staging deploy --prereqs
cap staging deploy --trace


# require 'capistrano/console'
cap production console
cap staging console ROLES=was
```

```ruby
## before/after
# call an existing task
before :starting, :ensure_user

after :finishing, :notify


# or define in block
before :starting, :ensure_user do
  #
end

after :finishing, :notify do
  #
end

## invoke
namespace :example do
  task :one do
    on roles(:all) { info "One" }
		if fetch(:fuga)
			next
		end
  end
  task :two do
    invoke "example:one"
    on roles(:all) { info "Two" }
  end
end

## Ask dialog
desc "Ask about breakfast"
task :breakfast do
  ask(:breakfast, "pancakes")
  on roles(:all) do |h|
    execute "echo \"$(whoami) wants #{fetch(:breakfast)} for breakfast!\""
  end
end

## running local tasks
desc 'Notify service of deployment'
task :notify do
  run_locally do
    with rails_env: :development do
      rake 'service:notify'
    end
  end
end
```


