define :setup_app_folders do
  app = node.run_state[:current_app]

  directory "/data/#{app[:name]}" do
    owner app[:app_user]
    group app[:app_user]
    mode '0770'
    action :create
  end

  # Create symlink for app_user
  bash  "create symlink app -> ~/app" do
    code <<-EOH
      ln -s /data/#{app[:name]} /home/#{app[:app_user]}
    EOH
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
      rotate 12
    end
  end
end
