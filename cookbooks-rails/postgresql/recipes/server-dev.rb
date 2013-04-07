#
# Cookbook Name:: postgresql
# Recipe:: server-dev
#

include_recipe "postgresql::ppa"

pg_version = node["postgresql"]["version"]

case node[:platform]
when "debian"
  package "postgresql-server-dev-#{pg_version}" do
    options("-t squeeze-backports")
  end
else
  package "postgresql-server-dev-#{pg_version}"
end