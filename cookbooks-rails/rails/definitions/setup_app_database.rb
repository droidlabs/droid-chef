require 'securerandom'

define :setup_app_database do
  app = node.run_state[:current_app]
  # deploy_username = node[:deploy_user][:username]

  database = app[:database] || node[:deploy_user][:database] || 'mysql'
  database_host = app[:database_host] || node[:deploy_user][:database_host] || 'localhost'
  database_username = app[:database_username] || node[:deploy_user][:database_username] || 'root'
  database_password = app[:database_password] || node[:deploy_user][:database_password] || ''

  if database.to_sym == :mongodb
    template "/data/#{app[:name]}/shared/config/mongoid.yml" do
      source 'mongoid.yml.erb'
      owner app[:name] # deploy_username
      group app[:name] # deploy_username
      mode '0640'
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        database: database,
        database_host: database_host
      )
    end
  else
    template_name = "database.#{database}.yml.erb"
    template "/data/#{app[:name]}/shared/config/database.yml" do
      source template_name
      owner app[:name] # deploy_username
      group app[:name] # deploy_username
      mode '0640'
      variables(
        app_name: app[:name],
        app_env: app[:environment],
        database: database,
        database_host: database_host,
        database_username: database_username,
        database_password: database_password
      )
    end
  end

  ################# SECRET KEY BASE ###############################
  template "/data/#{app[:name]}/shared/config/secret_key_base.yml" do
    source 'secret_key_base.yml.erb'
    owner app[:name] # deploy_username
    group app[:name] # deploy_username
    mode '0660'
    action :create_if_missing
    variables(
      app_secret_key_base: SecureRandom.hex(128)
    )
  end
  ##################################################################
  if app[:modules].include?('elasticsearch')
    template "/data/#{app[:name]}/shared/config/elasticsearch.yml" do
      source 'elasticsearch.yml.erb'
      owner app[:name] # deploy_username
      group app[:name] # deploy_username
      mode '0640'
      variables(app_name: app[:name], app_env: app[:environment])
    end
  end
  if app[:modules].include?('sidekiq')
    template "/data/#{app[:name]}/shared/config/sidekiq.yml" do
      source 'sidekiq.yml.erb'
      owner app[:name] # deploy_username
      group app[:name] # deploy_username
      mode '0640'
      variables(app_name: app[:name], app_env: app[:environment])
    end
  end
end
