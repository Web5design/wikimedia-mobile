set :application, "mobile"
set :repository,  "git://github.com/hcatlin/wikimedia-mobile.git"
set :branch, "stable"

set :scm, :git
set :user, "deploy"
set :deploy_to, "/srv/#{application}"
set :branch, "stable"

set :use_sudo, false
set :deploy_via, :remote_cache

role :app, "mobile1.wikimedia.org", "mobile2.wikimedia.org", "mobile3.wikimedia.org", "mobile4.wikimedia.org", "mobile5.wikimedia.org"

bin = "/var/lib/gems/1.9.1/bin"

namespace :deploy do

  after "deploy:update_code" do
    run "rm -rf #{current_release}/Gemfile.lock"
    run "cd #{current_release} && #{bin}/bundle install"
  end
  
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :passenger do
  task :memory_stats do
    run "passenger-memory-stats"
  end
end