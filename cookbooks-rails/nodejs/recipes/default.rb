include_recipe "build-essential"

node_packages = value_for_platform(
  [ "debian", "ubuntu" ]                      => { "default" => [ "libssl-dev" ] },
  [ "amazon", "centos", "fedora", "centos" ]  => { "default" => [ "openssl-devel" ] },
  "default"   => [ "libssl-dev" ]
)

node_packages.each do |node_package|
  package node_package do
    action :install
  end
end

tmp_dir = "/home/#{node[:deploy_user][:username]}/downloads"
bash "install-node" do
  user node[:deploy_user][:username]
  group node[:deploy_user][:username]
  cwd tmp_dir
  code <<-EOH
    tar -xzf node-v#{node["nodejs"]["version"]}.tar.gz &&
    (cd node-v#{node["nodejs"]["version"]} && ./configure --prefix=#{node["nodejs"]["dir"]} && make && make install)
  EOH
  action :nothing
  not_if "#{node["nodejs"]["dir"]}/bin/node --version 2>&1 | grep #{node["nodejs"]["version"]}"
end

"Node.js - download #{tmp_dir}/node-v#{node["nodejs"]["version"]}.tar.gz"
remote_file "#{tmp_dir}/node-v#{node["nodejs"]["version"]}.tar.gz" do
  owner node[:deploy_user][:username]
  group node[:deploy_user][:username]
  source node["nodejs"]["url"]
  checksum node["nodejs"]["checksum"]
  notifies :run, resources(:bash => "install-node"), :immediately
  action :create_if_missing
end

execute "install npm" do
  user node[:deploy_user][:username]
  command "curl https://www.npmjs.org/install.sh | sudo -u #{node[:deploy_user][:username]} -i sh"
end