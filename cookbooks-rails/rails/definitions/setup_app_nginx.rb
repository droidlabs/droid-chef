define :setup_app_nginx do
  app = node.run_state[:current_app]
  using_port = node.run_state[:using_port]

  ruby_version = app[:ruby_version] || node[:deploy_user][:ruby_version]
  ruby_dir = "#{node[:rbenv][:root_path]}/versions/#{ruby_version}"

  if app[:modules].include?('ssl')

    cookbook_file "#{node[:nginx][:path]}/ssl/#{app[:name]}.crt" do
      source "ssl/#{app[:name]}.crt"
      owner 'root'
      group 'root'
      mode 0755
    end
    cookbook_file "#{node[:nginx][:path]}/ssl/#{app[:name]}.key" do
      source "ssl/#{app[:name]}.key"
      owner 'root'
      group 'root'
      mode 0755
    end
  end

  if app[:server] == 'thin' || app[:server] == 'double'
    template_name =  app[:server] == 'thin' ? 'thin.yml.erb' : 'thin.double.yml.erb'
    template "/data/#{app[:name]}/shared/config/thin.yml" do
      source template_name
      owner app[:app_user]
      group app[:app_user]
      mode 0660
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        web_urls: app[:web_urls],
        default: app[:server_host_default] || false,
        using_port: using_port,
        servers_count: app[:server_workers_count] || 2,
        backend_folder: app[:backend_folder]
      )
    end
  end

  if app[:server] == 'unicorn'
    template "/data/#{app[:name]}/shared/config/unicorn.rb" do
      source 'unicorn.rb.erb'
      owner app[:app_user]
      group app[:app_user]
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
    owner app[:app_user]
    group app[:app_user]
    mode '0660'
    variables(
      app_name: app[:name],
      app_env: app[:environment],
      app_workers: app[:server_workers_count] || 2,
      web_urls: app[:web_urls],
      default: app[:server_host_default] || false,
      ssl_support: app[:modules].include?('ssl'),
      using_port: using_port,
      ruby_dir: ruby_dir,
      frontend_folder: app[:frontend_folder]
    )
    notifies :restart, 'service[passenger]'
  end
end
