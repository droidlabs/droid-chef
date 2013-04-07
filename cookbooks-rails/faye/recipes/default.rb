deploy_username = node[:deploy_user][:username]

directory "/data/faye/" do
  recursive true
  owner deploy_username
  group deploy_username
  mode "0770"
  action :create
end

directory "/data/faye/log/" do
  owner deploy_username
  group deploy_username
  mode "0770"
  action :create
end

bash "install faye-websocket" do
  code <<-EOH
    cd /data/faye/ && npm install faye-websocket
  EOH
end

bash "install faye" do
  code <<-EOH
    cd /data/faye/ && npm install faye
  EOH
end

runit_service "faye-server"

template "/data/faye/server.js" do
  source "server.js.erb"
  owner  deploy_username
  group  deploy_username
  mode   "0750"
  notifies :restart, 'service[faye-server]'
end