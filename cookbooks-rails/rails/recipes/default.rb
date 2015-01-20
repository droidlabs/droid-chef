deploy_username = node[:deploy_user][:username]

node[:rails][:packages].map do |pkg|
  package "rails:#{pkg}" do
    package_name pkg
  end
end

# create applications directory
directory '/data/' do
  owner deploy_username
  group deploy_username
  mode '0771' # for read app_users
  action :create
end

# setup for each application
node[:applications].each_with_index do |app, index|
  node.run_state[:current_app] = app
  setup_app_folders
  setup_app_database if app[:database]
  setup_app_nginx if app[:server]
end

node.run_state.delete(:current_app)
