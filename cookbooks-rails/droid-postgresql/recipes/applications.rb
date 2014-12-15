# Create Postgresql super user and databases this owner
# Droid Labs
# ver 0.0.3

# Create Superuser in DB PostgreSQL
user_name = node[:deploy_user][:database_username]
postgresql_user user_name do
  superuser true
  createdb true
  login true
  replication true
  createrole true
  password node[:deploy_user][:database_password]
end

node[:applications].each do |app|
  if app[:database] == 'postgresql'

    # Create APP user in DB Postgresql #
    postgresql_user app[:app_user] do
      superuser false
      createdb false
      login true
      replication false
      createrole false
      password app[:app_password]
    end

    # Create Postgresql DB for App
    postgresql_database app[:name] do
      owner app[:app_user]
    end

    if app[:pg_extensions]
      app[:pg_extensions].each do |pg_ext|
        postgresql_extension pg_ext do
         database app[:name]
        end
      end
    end    
  end
end