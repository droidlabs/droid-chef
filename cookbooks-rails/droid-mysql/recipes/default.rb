# #
# Cookbook Name:: droid-mysql //Wrapper cookbook
# Attributes::mysql::default and droid-mysql
#
# Author:: Fadeev <fadeev2010@gmail.com>


include_recipe "mysql::client"

# include_recipe "mysql::server"

mysql_service node['mysql']['service_name'] do
  version node['mysql']['version']
  port node['mysql']['port']
  data_dir node['mysql']['data_dir']
  template_source 'deprecated/my.cnf.erb'
  remove_test_database node['mysql']['remove_test_database']
  allow_remote_root node['mysql']['allow_remote_root']
  remove_anonymous_users node['mysql']['remove_anonymous_users']
  server_root_password node['mysql']['server_root_password']
  server_debian_password node['mysql']['server_debian_password']
  enable_utf8 node['mysql']['enable_utf8']
  action :create
end


include_recipe "droid-mysql::applications"

#Monitoring cfg
include_recipe 'droid-monit::mysql'
