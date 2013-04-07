define :setup_app_database do
  app = node.run_state[:current_app]
  deploy_username = node[:deploy_user][:username]

  if app[:database].to_sym == :mongodb
    template "/data/#{app[:name]}/shared/config/mongoid.yml" do
      source "mongoid.yml.erb"
      owner  deploy_username
      group  deploy_username
      mode   "0640"
      variables(app_name: app[:name], app_env: app[:environment], app_database: app[:database])
    end
  else
    template_name = "database.#{app[:database]}.yml.erb"
    template "/data/#{app[:name]}/shared/config/database.yml" do
      source template_name
      owner  deploy_username
      group  deploy_username
      mode   "0640"
      variables(app_name: app[:name], app_env: app[:environment], app_database: app[:database])
    end
  end
  if app[:modules].include?("elasticsearch")
    template "/data/#{app[:name]}/shared/config/elasticsearch.yml" do
      source "elasticsearch.yml.erb"
      owner  deploy_username
      group  deploy_username
      mode   "0640"
      variables(app_name: app[:name], app_env: app[:environment])
    end
  end
  if app[:modules].include?("sidekiq")
    template "/data/#{app[:name]}/shared/config/sidekiq.yml" do
      source "sidekiq.yml.erb"
      owner  deploy_username
      group  deploy_username
      mode   "0640"
      variables(app_name: app[:name], app_env: app[:environment])
    end
  end
end