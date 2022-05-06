#set :application, "192.168.0.12"
#set :application, "192.168.0.14"
#set :application, "177.36.136.46"
set  :application, "200.168.214.58"
set :repository, "git://github.com/seducpma/sisgered.git"
#set :user, "servidor"
set :user, "atena"
set :use_sudo, false
set :deploy_to, "/home/#{user}/sisgered.seducpma.com"
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server application, :app, :web, :db, :primary => true

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
     run "ln -s /home/atena/photos/sisgered /home/atena/sisgered.seducpma.com/current/public/photos"
  end

   task :custom_symlinks do
     run "rm -rf #{release_path}/config/database.yml"
     run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
     run "ln -s #{shared_path}/503.html #{release_path}/public/503.html"
   end
 end
