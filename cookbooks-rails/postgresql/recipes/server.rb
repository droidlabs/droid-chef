#
# Cookbook Name:: postgresql
# Recipe:: server
#
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "postgresql::ppa"

pg_version = node["postgresql"]["version"]

case node[:platform]
when "debian"
  package "postgresql-#{pg_version}" do
    options("-t squeeze-backports")
  end
else
  package "postgresql-#{pg_version}"
end

#bag fix install, add directory for postgresql
directory "/etc/postgresql/#{pg_version}/main/" do
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  recursive true
  action :create
end

# environment
template "/etc/postgresql/#{pg_version}/main/environment" do
  source "environment.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# pg_ctl
template "/etc/postgresql/#{pg_version}/main/pg_ctl.conf" do
  source "pg_ctl.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# pg_hba
template node["postgresql"]["hba_file"] do
  source "pg_hba.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :restart, "service[postgresql]"
end

# pg_ident
template node["postgresql"]["ident_file"] do
  source "pg_ident.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :restart, "service[postgresql]"
end

# postgresql
template "/etc/postgresql/#{pg_version}/main/postgresql.conf" do
  source "postgresql.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# start
template "/etc/postgresql/#{pg_version}/main/start.conf" do
  source "start.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]", :immediately
end

# define the service
service "postgresql" do
  supports :restart => true
  action [:enable, :start]
end
