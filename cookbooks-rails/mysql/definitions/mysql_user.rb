define :mysql_user do
  root_password = node[:deploy_user][:db_root_password]
  mysql_cmd = "mysql -uroot -p#{root_password} mysql -e"

  sql = [params[:name], "IDENTIFIED BY '#{params[:password]}'"].join(' ')

  exists = ["#{mysql_cmd} \"SELECT user FROM user WHERE user='#{params[:name]}';\""]
  exists.push "| grep #{params[:name]}"
  exists = exists.join ' '

  execute "altering mysql user #{params[:name]}" do
    user "root"
    command "#{mysql_cmd} \"SET PASSWORD FOR '#{params[:name]}'@'localhost' = PASSWORD('#{params[:password]}');\""
    only_if exists, user: "root"
  end

  execute "creating mysql user #{params[:name]}" do
    user "root"
    command "#{mysql_cmd} \"CREATE USER '#{params[:name]}'@'localhost' IDENTIFIED BY '#{params[:password]}';\""
    not_if exists, user: "root"
  end

  execute "grant priveligies for mysql user #{params[:name]}" do
    user "root"
    command "#{mysql_cmd} \"GRANT ALL PRIVILEGES ON *.* TO '#{params[:name]}'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;\""
  end
end