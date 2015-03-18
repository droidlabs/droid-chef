#
# Cookbook Name:: droid-postgresql //Wrapper cookbook
# Attributes:: postgresql::default and droid-postgresql
#
# Author:: Fadeev <fadeev2010@gmail.com>
#
#
include_recipe "postgresql"

include_recipe "postgresql::server"
include_recipe "postgresql::server_dev"
include_recipe "postgresql::libpq"
include_recipe "postgresql::client"

# include_recipe "droid-postgresql::ppa"
include_recipe "droid-postgresql::applications"

# Add monit cfg for postgresql service
# Use after start postgresql and monit service !
include_recipe "droid-monit::postgresql"
