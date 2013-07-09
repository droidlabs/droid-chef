define :mysql_user do
  root_password = node[:deploy_user][:database_root_password]
  mysql_cmd = "mysql -uroot -p#{root_password} mysql -e"

  access_from = node[:deploy_user][:database_access_from] || []
  access_from += ['localhost']

  sql = [params[:name], "IDENTIFIED BY '#{params[:password]}'"].join(' ')

  exists = ["#{mysql_cmd} \"SELECT user FROM user WHERE user='#{params[:name]}';\""]
  exists.push "| grep #{params[:name]}"
  exists = exists.join ' '

  access_from.each do |host|
    execute "altering mysql user #{params[:name]}" do
      user "root"
      command "#{mysql_cmd} \"SET PASSWORD FOR '#{params[:name]}'@'#{host}' = PASSWORD('#{params[:password]}');\""
      only_if exists, user: "root"
    end

    execute "creating mysql user #{params[:name]}" do
      user "root"
      command "#{mysql_cmd} \"CREATE USER '#{params[:name]}'@'#{host}' IDENTIFIED BY '#{params[:password]}';\""
      not_if exists, user: "root"
    end

    execute "grant priveligies for mysql user #{params[:name]}" do
      user "root"
      command "#{mysql_cmd} \"GRANT ALL PRIVILEGES ON *.* TO '#{params[:name]}'@'#{host}' WITH GRANT OPTION; FLUSH PRIVILEGES;\""
    end
  end
end