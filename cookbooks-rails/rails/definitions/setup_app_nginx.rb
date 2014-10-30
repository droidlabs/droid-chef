require 'fileutils'

define :setup_app_nginx do
  app = node.run_state[:current_app]
  using_port = node.run_state[:using_port]
  # deploy_username = node[:deploy_user][:username]

  ruby_version = app[:ruby_version] || node[:deploy_user][:ruby_version]
  ruby_dir = "#{node[:rbenv][:root_path]}/versions/#{ruby_version}"
            # "/home/#{deploy_username}/.rbenv/versions/#{ruby_version}"

  if app[:modules].include?('ssl')
    local_ssl_path = "#{Chef::Config[:file_cache_path]}/ssl"
    ssl_path = "#{node[:nginx][:path]}/ssl"
    FileUtils.cp "#{local_ssl_path}/#{app[:name]}.key", "#{ssl_path}/#{app[:name]}.key"
    FileUtils.cp "#{local_ssl_path}/#{app[:name]}.crt", "#{ssl_path}/#{app[:name]}.crt"
  end

  if app[:server] == 'thin'
    template "/data/#{app[:name]}/shared/config/thin.yml" do
      servers_count = app[:modules].include?('websockets') ? 6 : 3
      source 'thin.yml.erb'
      owner app[:app_user] # deploy_username
      group app[:app_user] # deploy_username
      mode '0660'
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        web_urls: app[:web_urls],
        default: app[:server_host_default] || false,
        using_port: using_port,
        servers_count: servers_count
      )
    end
  end

  if app[:server] == 'unicorn'
    template "/data/#{app[:name]}/shared/config/unicorn.rb" do
      source 'unicorn.rb.erb'
      owner app[:app_user] # deploy_username
      group app[:app_user] # deploy_username
      mode '0660'
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        app_workers: app[:server_workers_count] || 2,
        web_urls: app[:web_urls],
        default: app[:server_host_default] || false
      )
    end
  end

  template "#{node[:nginx][:path]}/conf/sites.d/#{app[:name]}.conf" do
    source "nginx_host_#{app[:server] || 'passenger'}.conf.erb"
    owner app[:app_user] # deploy_username
    group app[:app_user] # deploy_username
    mode '0660'
    variables(
      app_name: app[:name],
      app_env: app[:environment],
      app_workers: app[:server_workers_count] || 2,
      web_urls: app[:web_urls],
      default: app[:server_host_default] || false,
      ssl_support: app[:modules].include?('ssl'),
      using_port: using_port,
      ruby_dir: ruby_dir
    )
    notifies :restart, 'service[passenger]'
  end
end
