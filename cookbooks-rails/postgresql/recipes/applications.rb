user_name = node[:deploy_user][:db_username]
pg_user user_name do
  privileges superuser: true, createdb: true, login: user_name
  password node[:deploy_user][:db_password]
end

node[:applications].each do |app|
  if app[:database] == 'postgresql'
    pg_database app[:name] do
      owner user_name
    end
  end
end