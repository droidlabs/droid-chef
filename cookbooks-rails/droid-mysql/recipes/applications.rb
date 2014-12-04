user_name = node[:deploy_user][:database_username]
root_password = node[:deploy_user][:database_root_password]

# Create Super User in MySQL Database
mysql_user user_name do
  password node[:deploy_user][:database_root_password]
end

# Create MySQL database and owner for app[:name]
node['applications'].each do |app|
  if app[:database] == 'mysql'
    execute "create database for: #{app[:name]}." do
      user node[:deploy_user][:username]
      command "mysql -uroot -p#{root_password} -e \"CREATE DATABASE IF NOT EXISTS #{app[:name]}\""
    end
    mysql_user app[:app_user] do
      password app[:app_password]
    end
  end
end