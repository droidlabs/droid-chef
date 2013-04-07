#
# Cookbook Name:: postgresql
# Recipe:: default
#

package "python-software-properties"

case node[:platform]
when "debian"
  apt_repository "debian-backports" do
    uri "http://backports.debian.org/debian-backports"
    components ["squeeze-backports main"]
    deb_src true
  end
else
  execute "setup ppa apt repository" do
    command "add-apt-repository ppa:pitti/postgresql && apt-get update"
    not_if  "test -f /etc/apt/sources.list.d/pitti-postgresql-#{node["lsb"]["codename"]}.list"
  end
end

package "postgresql-common"
