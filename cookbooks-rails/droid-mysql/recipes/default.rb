# #
# Cookbook Name:: droid-mysql //Wrapper cookbook
# Attributes::mysql::default and droid-mysql
#
# Author:: Fadeev <fadeev2010@gmail.com>

# include_recipe "mysql::client"
# include_recipe "mysql::server_deprecated"

# Install MySQL server
mysql_service 'default' do
  version node['mysql']['version']
  port node['mysql']['port']
  initial_root_password node['mysql']['server_root_password']
  data_dir '/var/lib/mysql'
  action [:create, :start]
end

# Load MySQL configuration
mysql_config 'default' do
  cookbook 'droid-mysql'
  source 'droid.cnf.erb'
  notifies :restart, 'mysql_service[default]'
end

# Install client software
mysql_client 'default' do
  version node['mysql']['version']
  action :create
end

# Create DB and users
include_recipe "droid-mysql::applications"

# Monitoring cfg
include_recipe 'droid-monit::mysql'
