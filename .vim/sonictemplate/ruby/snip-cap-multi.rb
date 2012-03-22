set :stages, %w[development production]
set :default_stage, "development"

require 'capistrano/ext/multistage'

