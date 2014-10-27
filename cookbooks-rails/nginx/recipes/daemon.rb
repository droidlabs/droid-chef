# Cookbook Name:: nginx
deploy_user = node[:deploy_user][:username]
nginx_path = node[:nginx][:path]
log_path = node[:nginx][:log_path]
home_path = "/home/#{deploy_user}"
tmp_dir = "#{home_path}/downloads"

main_ruby_version = node[:deploy_user][:ruby_version]
app_ruby_versions = node[:applications].map { |a| a[:ruby_version] }.compact
ruby_versions = [main_ruby_version] + app_ruby_versions

major_ruby = case main_ruby_version
             when /1\.9/ then "1.9.1"
             when /2\.0/ then "2.0.0"
             when /2\.1/ then "2.1.0"
             end

ruby_dir =  "#{node[:rbenv][:root_path]}/versions/#{main_ruby_version}"  #{}"#{home_path}/.rbenv/versions/#{main_ruby_version}"

passenger_dir = if node[:nginx][:passenger][:enterprise]
  "#{ruby_dir}/lib/ruby/gems/#{major_ruby}/gems/passenger-enterprise-server-#{node[:nginx][:passenger][:version]}"
else
  "#{ruby_dir}/lib/ruby/gems/#{major_ruby}/gems/passenger-#{node[:nginx][:passenger][:version]}"
end

cc='gcc'

['libcurl4-openssl-dev','libpcre3-dev', 'curl'].each do |pkg|
  package pkg
end

directory nginx_path do
  user deploy_user
  mode 0755
  action :create
end

# install enterprise or regular passenger
# NOTE: you should copy enterprise passgenger gem and license to /files dir
if node[:nginx][:passenger][:enterprise]
  cookbook_file "/etc/passenger-enterprise-license" do
    owner 'root'
    group 'root'
    mode 0755
  end
  cookbook_file "#{tmp_dir}/passenger-enterprise-server.gem" do
    owner deploy_user
    group deploy_user
    mode 0755
  end
  ruby_versions.each do |version|
    bash "install passenger gem - ruby #{version}" do
      code "sudo -u #{deploy_user} -i env RBENV_VERSION='#{version}' gem install #{tmp_dir}/passenger-enterprise-server.gem"
      not_if { result = `sudo -u #{deploy_user} -i env RBENV_VERSION='#{version}' gem list | grep passenger`; result && result != '' }
    end
  end
else
  deployer_gem "passenger" do
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
    code %Q{CC=#{cc} sudo -u #{deploy_user} -i sudo rbenv exec passenger-install-nginx-module --auto --nginx-source-dir="#{tmp_dir}/nginx-#{nginx_version}" --prefix="#{nginx_path}" --extra-configure-flags="#{flags}"}
  end

  # bash "fix issue with passenger installation" do
  #   code "cd #{passenger_dir}; sudo -u #{deploy_user} -i sudo rake nginx"
  # end
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
    :pidfile => "#{nginx_path}/logs/nginx.pid",
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
    :pidfile => "#{nginx_path}/logs/nginx.pid",
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
  reload_command "if [ -e #{nginx_path}/logs/nginx.pid ]; then #{nginx_path}/sbin/nginx -s reload; fi"
  start_command "#{nginx_path}/sbin/nginx"
  stop_command "if [ -e #{nginx_path}/logs/nginx.pid ]; then #{nginx_path}/sbin/nginx -s stop; fi"
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