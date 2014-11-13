# #
# Cookbook Name:: droid-mysql //Wrapper cookbook
# Attributes::mysql::default and droid-mysql
#
# Author:: Fadeev <fadeev2010@gmail.com>

include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "droid-mysql::applications"

#Monitoring cfg
include_recipe 'droid-monit::mysql'
