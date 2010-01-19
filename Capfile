load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do   
  task :after_symlink, :roles => :app do
    #run "rm -f ~/public_html;ln -s #{deploy_to}/current/public ~/public_html"
    run "ln -s #{deploy_to}/shared/config/database.yml #{deploy_to}/current/config/database.yml"
  end
end