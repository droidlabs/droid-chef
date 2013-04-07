#
# Cookbook Name:: postgresql
# Recipe:: client
#

include_recipe "postgresql::ppa"

package "postgresql-client-#{node["postgresql"]["version"]}"
