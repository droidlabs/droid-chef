deploy_username = node[:deploy_user][:username]

node[:rails][:packages].collect do |pkg|
  package pkg
end

# create applications directory
directory "/data/" do
  owner deploy_username
  group deploy_username
  mode "0774" # for read app_users
  action :create
end

using_port = 3010
# setup for each application
node[:applications].each_with_index do |app, index|
  node.run_state[:current_app] = app
  node.run_state[:using_port] = 3010 + (index * 6)
  setup_app_folders
  setup_app_database if app[:database]
  setup_app_nginx if app[:server]
end

node.run_state.delete(:current_app)
node.run_state.delete(:using_port)