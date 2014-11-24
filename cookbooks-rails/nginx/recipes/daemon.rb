# Cookbook Name:: nginx
deploy_user = node[:deploy_user][:username]
nginx_path  = node[:nginx][:path]
log_path    = node[:nginx][:log_path]
home_path   = "/home/#{deploy_user}"
tmp_dir     = "#{home_path}/downloads"

pass_version = node['nginx']['passenger']['version']
token        = node['nginx']['passenger']['enterprise']['token']

main_ruby_version = node[:deploy_user][:ruby_version]
app_ruby_versions = node[:applications].map { |a| a[:ruby_version] }.compact
ruby_versions     = [main_ruby_version] + app_ruby_versions

# major_ruby = case main_ruby_version
#              when /1\.9/ then "1.9.1"
#              when /2\.0/ then "2.0.0"
#              when /2\.1/ then "2.1.0"
#              end

ruby_dir =  "#{node[:rbenv][:root_path]}/versions/#{main_ruby_version}"  #{}"#{home_path}/.rbenv/versions/#{main_ruby_version}"

# Old version: The location to the Phusion Passenger root directory.
# passenger_dir = if node[:nginx][:passenger][:enterprise]
#  "#{ruby_dir}/lib/ruby/gems/#{major_ruby}/gems/passenger-enterprise-server-#{node[:nginx][:passenger][:version]}"
# else
#  "#{ruby_dir}/lib/ruby/gems/#{major_ruby}/gems/passenger-#{node[:nginx][:passenger][:version]}"
# end

cc = 'gcc'

['libcurl4-openssl-dev','libpcre3-dev', 'curl'].each do |pkg|
  package pkg
end

#Create nginx directory Default: '/opt/nginx'
directory nginx_path do
  user deploy_user
  mode 0755
  action :create
end

# Install enterprise or regular passenger GEM !
# NOTE: you should copy enterprise passgenger gem and license to /files/default dir
if token != '' && token != nil
  cookbook_file "/etc/passenger-enterprise-license" do
    owner 'root'
    group 'root'
    mode 0755
  end
  # cookbook_file "#{tmp_dir}/passenger-enterprise-server.gem" do
  # remote_file "#{tmp_dir}/passenger-enterprise-server.gem" do
  #   source "http://www.example.org/large-file.tar.gz"
  #   owner deploy_user
  #   group deploy_user
  #   mode 0755
  # end
  ruby_versions.each do |version|
    bash "install passenger gem - ruby #{version}" do
      # code "sudo -u #{deploy_user} -i sudo -i env RBENV_VERSION='#{version}' gem install #{tmp_dir}/passenger-enterprise-server.gem"      not_if { result = `sudo -u #{deploy_user} sudo -i env RBENV_VERSION='#{version}' gem list | grep passenger`; result && result != '' }
      code "sudo -u #{deploy_user} -i sudo -i env RBENV_VERSION='#{version}' gem install --source https://download:#{token}@www.phusionpassenger.com/enterprise_gems/ passenger-enterprise-server -v #{pass_version}"      
      not_if { result = `sudo -u #{deploy_user} sudo -i env RBENV_VERSION='#{version}' gem list | grep passenger`; result && result != '' }
    end
  end
else
  # Install gem in global ruby version [regular passenger]
  deployer_gem 'passenger' do
    version node[:nginx][:passenger][:version]
  end
end

nginx_version = node[:nginx][:nginx_version]

# INSTALL PASSENGER && NGINX
if !File.exists?("#{nginx_path}/conf/nginx.conf") || node['ruby_build']['upgrade'] != 'none'
  remote_file "#{tmp_dir}/nginx-#{nginx_version}.tar.gz" do
    owner deploy_user
    group deploy_user
    source "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
    action :create_if_missing
  end

  bash "extract nginx" do
    code "cd #{tmp_dir}; sudo -u #{deploy_user} tar -xzf nginx-#{nginx_version}.tar.gz"
  end

  flags = node[:nginx][:configure_flags]
  bash "install passenger/nginx" do
   #code %Q{CC=#{cc} sudo -u #{deploy_user} -i sudo rbenv exec passenger-install-nginx-module --auto --nginx-source-dir="#{tmp_dir}/nginx-#{nginx_version}" --prefix="#{nginx_path}" --extra-configure-flags="#{flags}"}
    code %Q{CC=#{cc} sudo -u #{deploy_user} sudo -i env RBENV_VERSION='#{main_ruby_version}' rbenv exec passenger-install-nginx-module --auto --nginx-source-dir="#{tmp_dir}/nginx-#{nginx_version}" --prefix="#{nginx_path}" --extra-configure-flags="#{flags}"}
  end

  # bash "fix issue with passenger installation" do
  #   code "cd #{passenger_dir}; sudo -u #{deploy_user} -i sudo rake nginx"
  # end
else
  # The location to the Phusion Passenger root directory.
  passenger_dir = `sudo -u #{deploy_user} sudo -i env RBENV_VERSION='#{main_ruby_version}' rbenv exec passenger-config --root`.chomp
  Chef::Log.info("passenger_dir:#{passenger_dir}")
end

directory log_path do
  user deploy_user
  mode 0755
  action :create
end

directory "#{nginx_path}/logs" do
  mode 0755
  action :create
  recursive true
  owner "nobody"
  group "root"
end

directory "#{nginx_path}/ssl" do
  mode 0755
  action :create
  recursive true
  owner "nobody"
  group "root"
end

directory "#{nginx_path}/conf/conf.d" do
  mode 0755
  action :create
  recursive true
  notifies :reload, 'service[passenger]'
end

directory "#{nginx_path}/conf/sites.d" do
  mode 0755
  action :create
  recursive true
  notifies :reload, 'service[passenger]'
end

use_passenger = node[:applications].any?{ |a| a[:server] == 'passenger'}
template "#{nginx_path}/conf/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :log_path => log_path,
    :nginx => node[:nginx],
    :pidfile => "#{node[:nginx][:pid_path]}", # #{nginx_path}/logs/nginx.pid
    :use_passenger => use_passenger,
    :ruby_dir => ruby_dir,
    :passenger_dir => passenger_dir
  )
  notifies :restart, 'service[passenger]'
end

template "#{nginx_path}/conf/mime.types" do
  source "mime.types.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[passenger]'
end

template "/etc/init.d/passenger" do
  source "passenger.init.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :pidfile => "#{node[:nginx][:pid_path]}", # #{nginx_path}/logs/nginx.pid
    :nginx_path => nginx_path
  )
end

if node[:nginx][:status_server]
  cookbook_file "#{nginx_path}/conf/sites.d/status.conf" do
    source "status.conf"
    mode "0644"
  end
end

service "passenger" do
  service_name "passenger"
  enabled true
  running true
  reload_command "if [ -e #{node[:nginx][:pid_path]} ]; then #{nginx_path}/sbin/nginx -s reload; fi" # #{nginx_path}/logs/nginx.pid
  start_command "#{nginx_path}/sbin/nginx"
  stop_command "if [ -e #{node[:nginx][:pid_path]} ]; then #{nginx_path}/sbin/nginx -s stop; fi" # #{nginx_path}/logs/nginx.pid
  status_command "curl http://localhost/nginx_status"
  supports [ :start, :stop, :reload, :status, :enable ]
  action [ :enable, :start ]
  pattern "nginx: master"
end

include_recipe "logrotate"

logrotate_app "passenger" do
  path "#{node[:nginx][:log_path]}/*.log #{node[:nginx][:log_path]}/*/*.log"
  rotate 12
end

# Add monit cfg for nginx-passenger service
# Use after start nginx-passenger and monit service !
include_recipe 'droid-monit::nginx-passenger-monit'
