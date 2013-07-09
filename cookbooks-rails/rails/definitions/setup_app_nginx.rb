require 'fileutils'
define :setup_app_nginx do
  app = node.run_state[:current_app]
  using_port = node.run_state[:using_port]
  deploy_username = node[:deploy_user][:username]

  if app[:modules].include?("ssl")
    local_ssl_path = "#{Chef::Config[:file_cache_path]}/ssl"
    ssl_path = "#{node[:nginx][:path]}/ssl"
    FileUtils.cp "#{local_ssl_path}/#{app[:name]}.key", "#{ssl_path}/#{app[:name]}.key"
    FileUtils.cp "#{local_ssl_path}/#{app[:name]}.crt", "#{ssl_path}/#{app[:name]}.crt"
  end

  if app[:modules].include?("websockets")
    template "#{node[:nginx][:path]}/conf/sites-tcp.d/#{app[:name]}.conf" do
      source "nginx_host_websockets.conf.erb"
      owner  deploy_username
      group  deploy_username
      mode   "0640"
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        web_urls: app[:web_urls],
        default: app[:server_host_default] || false,
        ssl_support: app[:modules].include?("ssl"),
        using_port: using_port
      )
      notifies :restart, 'service[passenger]'
    end
  end

  if app[:server] == 'thin'
    template "/data/#{app[:name]}/shared/config/thin.yml" do
      servers_count = app[:modules].include?("websockets") ? 6 : 3
      source "thin.yml.erb"
      owner  deploy_username
      group  deploy_username
      mode   "0640"
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
      source "unicorn.rb.erb"
      owner  deploy_username
      group  deploy_username
      mode   "0640"
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        app_workers: app[:server_workers_count],
        web_urls: app[:web_urls],
        default: app[:server_host_default] || false
      )
    end
  end

  template "#{node[:nginx][:path]}/conf/sites.d/#{app[:name]}.conf" do
    source "nginx_host_#{app[:server] || 'passenger'}.conf.erb"
    owner  deploy_username
    group  deploy_username
    mode   "0640"
    variables(
      app_name: app[:name],
      app_env: app[:environment],
      app_workers: app[:server_workers_count],
      web_urls: app[:web_urls],
      default: app[:server_host_default] || false,
      ssl_support: app[:modules].include?("ssl"),
      using_port: using_port
    )
    notifies :restart, 'service[passenger]'
  end
end