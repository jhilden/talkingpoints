set :application, "talkingpoints"
set :domain, "app.talking-points.org"

set :repository,  "git://github.com/jhilden/talkingpoints.git"
set :scm, :git
set :deploy_via, :remote_cache


role :web, "app.talking-points.org"                     # Your HTTP server, Apache/etc
role :app, "app.talking-points.org"                     # This may be the same as your `Web` server
role :db,  "app.talking-points.org", :primary => true   # This is where Rails migrations will run
#role :db,  "your slave db-server here"



set :user, "tpoints"
set :use_sudo, false
set :deploy_to, "/home/tpoints/app.talking-points.org/"
set :migrate_target, :current
set :rails_env, "production"



# Thinking Sphinx
require 'thinking_sphinx/deploy/capistrano'


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    thinking_sphinx.stop
    thinking_sphinx.index
    thinking_sphinx.start
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Symlink to shared database.yml"
  task :symlink_database, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/database.yml #{deploy_to}/current/config/database.yml"
  end
end

after 'deploy:symlink', 'deploy:symlink_database'
after "deploy:setup", "thinking_sphinx:shared_sphinx_folder"