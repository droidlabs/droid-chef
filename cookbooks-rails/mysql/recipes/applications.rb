user_name = node[:deploy_user][:db_username]
root_password = node[:deploy_user][:db_root_password]

mysql_user user_name do
  password node[:deploy_user][:db_password]
end

node["applications"].each do |app|
  if app[:database] == 'mysql'
    execute "create database for: #{app[:name]}." do
      user node[:deploy_user][:username]
      command "mysql -uroot -p#{root_password} -e \"CREATE DATABASE IF NOT EXISTS #{app[:name]}\""
    end
  end
end