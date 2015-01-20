define :setup_app_folders do
  app = node.run_state[:current_app]

  directory "/data/#{app[:name]}" do
    owner app[:app_user]
    group app[:app_user]
    mode '0770'
    action :create
  end

  # Create symlink for app_user
  link "/home/#{app[:app_user]}/app" do
    to "/data/#{app[:name]}"
    link_type :symbolic
    action :create
  end

  directory "/data/#{app[:name]}/releases" do
    owner app[:app_user]
    group app[:app_user]
    mode '0770'
    action :create
  end

  directory "/data/#{app[:name]}/shared" do
    owner app[:app_user]
    group app[:app_user]
    mode '0770'
    action :create
  end

  ['config', 'log', 'tmp', 'pids', 'system'].each do |shared_folder|
    directory "/data/#{app[:name]}/shared/#{shared_folder}" do
      owner app[:app_user]
      group app[:app_user]
      mode '0770'
      action :create
    end
  end

  if app[:server]
    include_recipe 'logrotate'

    logrotate_app "rails_#{app[:name]}" do
      path "/data/#{app[:name]}/shared/log/*.log /data/#{app[:name]}/shared/log/*/*.log"
      frequency 'daily'
      rotate 14
    end
  end
end
