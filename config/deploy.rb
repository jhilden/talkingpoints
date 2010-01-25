set :application, "talkingpoints"
set :domain, "talkingpoints.dreamhosters.com"

set :repository,  "git://github.com/jhilden/talkingpoints.git"
set :scm, :git
set :deploy_via, :remote_cache


role :web, "talkingpoints.dreamhosters.com"                     # Your HTTP server, Apache/etc
role :app, "talkingpoints.dreamhosters.com"                     # This may be the same as your `Web` server
role :db,  "talkingpoints.dreamhosters.com", :primary => true   # This is where Rails migrations will run
#role :db,  "your slave db-server here"



set :user, "tpoints"
set :use_sudo, false
set :deploy_to, "/home/tpoints/talkingpoints.dreamhosters.com/#{application}"
set :migrate_target, :current

set :rails_env, "development"
set :migrate_target, "current"



# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :after_symlink, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/database.yml #{deploy_to}/current/config/database.yml"
  end
end