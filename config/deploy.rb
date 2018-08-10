# config valid only for current version of Capistrano
lock "3.11.0"

set :application, "snowdrop"
set :repo_url, "git@github.com:dot-black/snowdrop.git"

set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'

set :passenger_restart_with_touch, true
set :pty, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

set :linked_files, %w[config/database.yml
                      config/sidekiq.yml
                      config/secrets.yml
                      config/master.key]

# Default value for linked_dirs is []
set :linked_dirs, %w[log
                     tmp/pids
                     tmp/cache
                     tmp/sockets
                     vendor/bundle
                     public/uploads
                     node_modules]

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5
