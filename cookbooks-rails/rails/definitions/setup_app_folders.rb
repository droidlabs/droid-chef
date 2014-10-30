define :setup_app_folders do
  app = node.run_state[:current_app]
  deploy_username = node[:deploy_user][:username]
  #app_username    = app[:app_user]

  directory "/data/#{app[:name]}" do
    owner app[:name] #deploy_username
    group app[:name] #deploy_username
    mode "0770"
    action :create
  end

  directory "/data/#{app[:name]}/releases" do
    owner app[:name] #deploy_username
    group app[:name] #deploy_username
    mode "0770"
    action :create
  end

  directory "/data/#{app[:name]}/shared" do
    owner app[:name] #deploy_username
    group app[:name] #deploy_username
    mode "0770"
    action :create
  end

  ["config", "log", "tmp", "pids"].each do |shared_folder|
    directory "/data/#{app[:name]}/shared/#{shared_folder}" do
      owner app[:name] #deploy_username
      group app[:name] #deploy_username
      mode "0770"
      action :create
    end
  end

  if app[:server]
    include_recipe "logrotate"

    logrotate_app "rails_#{app[:name]}" do
      path "/data/#{app[:name]}/shared/log/*.log /data/#{app[:name]}/shared/log/*/*.log"
      rotate 12
    end
  end
end