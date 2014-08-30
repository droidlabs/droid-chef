package "libxslt-dev"
package "libxml2-dev"

deploy_user = node[:deploy_user][:username]
backup_path = "/home/#{deploy_user}/Backup"

directory backup_path do
  owner deploy_user
  group deploy_user
end

directory "#{backup_path}/config" do
  owner deploy_user
  group deploy_user
  recursive true
end

directory "#{backup_path}/log" do
  owner deploy_user
  group deploy_user
  recursive true
end

sync_dirs = []
node[:applications].each do |app|
  system_path = "/data/#{app[:name]}/shared/system"
  sync_dirs << [app[:name], system_path] if File.exists?(system_path)
end
databases = []
node[:applications].each do |app|
  databases << { name: app[:name], type: app[:database] } if app[:database]
end
template "#{backup_path}/config.rb" do
  owner deploy_user
  source "config.rb.erb"
  variables config: node[:backup], user: node[:deploy_user],
            sync_dirs: sync_dirs, databases: databases
end

template "#{backup_path}/config/schedule.rb" do
  owner deploy_user
  source "schedule.rb.erb"
  variables(config: node[:backup], user: node[:deploy_user], backup_path: backup_path)
end

template "/etc/logrotate.d/whenever_log" do
  owner "root"
  source "logrotate.erb"
  variables(backup_path: backup_path)
end

## Setup bundler and install gems
directory "#{backup_path}/.bundle" do
  owner deploy_user
  group deploy_user
  recursive true
end
template "#{backup_path}/.bundle/config" do
  owner deploy_user
  source "bundle_config.erb"
  variables(config: node[:backup], user: node[:deploy_user])
end
template "#{backup_path}/Gemfile" do
  owner deploy_user
  source "Gemfile"
end
bash "install backup gems" do
  code "sudo -u #{deploy_user} -i bundle install --gemfile /home/#{deploy_user}/Backup/Gemfile --path /home/#{deploy_user}/Backup/bundle --no-deployment"
end
bash "setup cron jobs" do
  code "sudo -u #{deploy_user} -i BUNDLE_GEMFILE=/home/#{deploy_user}/Backup/Gemfile bundle exec whenever  --update-crontab --load-file /home/#{deploy_user}/Backup/config/schedule.rb"
end