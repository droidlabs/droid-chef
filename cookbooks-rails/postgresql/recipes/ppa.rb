#
# Cookbook Name:: postgresql
# Recipe:: default
#

package "python-software-properties"

apt_repository 'apt.postgresql.org' do
  uri 'http://apt.postgresql.org/pub/repos/apt'
  distribution "#{node["lsb"]["codename"]}-pgdg"
  components ['main', node['postgresql']['version']]
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'
  action :add
end

package "postgresql-common"
