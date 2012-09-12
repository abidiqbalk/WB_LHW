set :application, "wb_lhw"
set :repository,  "git@github.com:AhmerArif/WB_LHW.git"

set :deploy_to, "~/sites/#{application}"

set :scm, "git"
set :branch, "master"

set :user, "rootwb"

role :app, "221.120.222.129:22"
role :web, "221.120.222.129:22"
role :db,  "221.120.222.129:22", :primary => true
default_run_options[:pty] = true
load 'deploy/assets'
require "bundler/capistrano"
set :bundle_flags,    ""

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
    
namespace :deploy do
  desc "Restarting Passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_db'
namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/yetting.yml #{release_path}/config/yetting.yml"
  end
end

# # meh gotta make a mantainance page at some point
# namespace :deploy do
  # desc "Disable requests to the app, show maintenance page"
  # web.task :disable, :roles => :web do
    # run "cp #{current_path}/public/maintenance.html  #{shared_path}/system/maintenance.html"
  # end

  # desc "Re-enable the web server by deleting any maintenance file"
  # web.task :enable, :roles => :web do
    # run "rm #{shared_path}/system/maintenance.html"
  # end
# end