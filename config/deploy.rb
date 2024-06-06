# config valid for current version and patch releases of Capistrano
lock "~> 3.18.1"

set :application, "dummy-rails"
set :repo_url, "git@github.com:itskamleshpatidar/dummy-rails.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'main'

# Default deploy_to directory is /var/www/dummy-rails
set :deploy_to, "/var/www"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
# set :bundle_bins, fetch(:bundle_bins, []).push("bundler:2.3.11")

set :rvm_ruby_version, '3.2.2'

# set :rbenv_ruby, '2.7.8'
set :use_sudo, true
# set :assets_roles, []
set :rails_env, 'production'

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  before :start, :make_dirs
end


# namespace :deploy do
#   desc 'Upload database.yml'
#   task :upload_database_yml do
#     on roles(:app) do
#       unless test("[ -f #{shared_path}/config/database.yml ]")
#         upload! 'config/database.yml', "#{shared_path}/config/database.yml"
#       end
#     end
#   end

#   before :starting, :upload_database_yml
# end

# namespace :deploy do
#   desc 'Upload master.key'
#   task :upload_master_key do
#     on roles(:app) do
#       unless test("[ -f #{shared_path}/config/master.key ]")
#         upload! 'config/master.key', "#{shared_path}/config/master.key"
#       end
#     end
#   end

#   before :starting, :upload_master_key
# end

# set :use_sudo, true

# namespace :deploy do
#   desc 'Create release directory with sudo'
#   task :create_release_dir_with_sudo do
#     on roles(:app) do
#       execute :sudo, "mkdir -p #{release_path}"
#     end
#   end

  # desc 'Start Puma'
  # task :start do
  #   on roles(:app) do
  #     within release_path do
  #       with rails_env: fetch(:rails_env) do
  #         execute :bundle, "exec puma -C #{shared_path}/puma.rb"
  #       end
  #     end
  #   end
  # end

  # after 'deploy:publishing', 'deploy:start'
end

# namespace :nginx do
#   desc 'Restart Nginx'
#   task :restart do
#     on roles(:web) do
#       execute :sudo, :systemctl, :restart, :nginx
#     end
#   end
#   after 'deploy:finished', 'nginx:restart'
# end
