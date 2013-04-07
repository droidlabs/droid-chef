#
# Cookbook Name:: passenger
# Recipe:: production

passenger_root = run_passenger_config '--root'.chomp
ruby_root = `sudo -u #{node[:deploy_user][:username]} -i rbenv which ruby`.chomp
nginx_path = node[:passenger][:production][:path]
deploy_user = node[:deploy_user][:username]

node.set[:passenger][:root_path] = run_passenger_config '--root'
node.set[:passenger][:module_path] = run_passenger_config('--root') + "/ext/apache2/mod_passenger.so"

cc='gcc'

package "curl"
if ['ubuntu', 'debian'].member? node[:platform]
  ['libcurl4-openssl-dev','libpcre3-dev'].each do |pkg|
    package pkg
  end
  if node[:platform_version] == '11.10'
    package 'gcc-4.4'
    package 'libstdc++6-4.4-dev'
    cc='gcc-4.4'
  end
end

directory nginx_path do
  user deploy_user
  mode 0755
  action :create
end

tmp_dir = "/home/#{node[:deploy_user][:username]}/downloads"
unless File.exists? "#{nginx_path}/conf/nginx.conf"
  nginx_version = node[:passenger][:production][:nginx_version]
  remote_file "#{tmp_dir}/nginx-#{nginx_version}.tar.gz" do
    owner deploy_user
    group deploy_user
    source "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
    action :create_if_missing
  end

  bash "extract nginx" do
    code "cd #{tmp_dir}; sudo -u #{deploy_user} tar -xzf nginx-#{nginx_version}.tar.gz"
  end

  flags = node[:passenger][:production][:configure_flags]
  bash "install passenger/nginx" do
    code %Q{CC=#{cc} sudo -u #{deploy_user} -i sudo rbenv exec passenger-install-nginx-module --auto --nginx-source-dir="#{tmp_dir}/nginx-#{nginx_version}" --prefix="#{nginx_path}" --extra-configure-flags="#{flags}"}
  end
end

log_path = node[:passenger][:production][:log_path]

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

template "#{nginx_path}/conf/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :log_path => log_path,
    :passenger_root => passenger_root,
    :ruby_path => ruby_root,
    :passenger => node[:passenger][:production],
    :pidfile => "#{nginx_path}/logs/nginx.pid"
  )
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

if node[:passenger][:production][:status_server]
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
  path "#{node[:passenger][:production][:log_path]}/*.log #{node[:passenger][:production][:log_path]}/*/*.log"
  rotate 12
end