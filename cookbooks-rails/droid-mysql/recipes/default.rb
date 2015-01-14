# #
# Cookbook Name:: droid-mysql //Wrapper cookbook
# Attributes::mysql::default and droid-mysql
#
# Author:: Fadeev <fadeev2010@gmail.com>

include_recipe "mysql::client"
include_recipe "mysql::server"

template "/etc/mysql/conf.d/droid.cnf" do
	source "droid.cnf.erb"
	owner "root"
	group "root"
	mode "0644"
end

include_recipe "droid-mysql::applications"

service "mysql" do
	action [ :restart ]
end

#Monitoring cfg
include_recipe 'droid-monit::mysql'
