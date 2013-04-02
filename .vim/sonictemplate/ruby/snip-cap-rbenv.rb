set :default_environment, {
  'RBENV_ROOT' => '$HOME/.rbenv',
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
