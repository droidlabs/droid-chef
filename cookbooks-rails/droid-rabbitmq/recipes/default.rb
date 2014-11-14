#
# Cookbook Name:: droid-rabbitmq //Wrapper cookbook
# Attributes:: rabbitmq::default and droid-rabbitmq
#
# Author:: Fadeev <fadeev2010@gmail.com>

include_recipe 'rabbitmq::default'


# Add monit cfg for postgresql service
# Use after start postgresql and monit service !
include_recipe 'droid-monit::rabbitmq'