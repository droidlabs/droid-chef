#
# Cookbook Name:: droid-postgresql //Wrapper cookbook
# Attributes:: postgresql::default and droid-postgresql
#
# Author:: Fadeev <fadeev2010@gmail.com>
#
# 
#
include_recipe "postgresql"

include_recipe "postgresql::server"
include_recipe "postgresql::server_dev"
include_recipe "postgresql::libpq"
include_recipe "postgresql::client"

#include_recipe "droid-postgresql::ppa"     # Уточнить у Искандера нужно ли это
include_recipe "droid-postgresql::applications"