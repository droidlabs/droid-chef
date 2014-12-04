# Create Postgresql super user and databases this owner
# Droid Labs
# ver 0.0.3

# Create Superuser db Postgresql
user_name = node[:deploy_user][:database_username]
pg_user user_name do
  privileges superuser: true, createdb: true, login: user_name
  password node[:deploy_user][:database_password]
end

node[:applications].each do |app|
  if app[:database] == 'postgresql'

    # Create APP user in DB Postgresql #
    pg_user app[:app_user] do
      privileges superuser: false, createdb: false, login: true
      password app[:app_password]
    end

    pg_database app[:name] do
      owner app[:app_user]    # user_name
    end

  end
end