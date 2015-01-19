# Cookbook Name:: droid-mysql //Wrapper cookbook
# Attributes::mysql::default and droid-mysql
# Droid Labs LLC, Fadeev Sergey <fadeev2010@gmail.com>

include_recipe "mysql::client"
include_recipe "mysql::server"

service "mysql" do
  supports :restart => true, :start => true, :stop => true
  provider Chef::Provider::Service::Init
  action [ :start ]
end

template "/etc/mysql/conf.d/droid.cnf" do
  source "droid.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[mysql]"
end

include_recipe "droid-mysql::applications"

#Monitoring cfg
include_recipe 'droid-monit::mysql'
