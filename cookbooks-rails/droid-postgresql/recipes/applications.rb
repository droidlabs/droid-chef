user_name = node[:deploy_user][:database_username]
pg_user user_name do
  privileges superuser: true, createdb: true, login: user_name
  encrypted_password node[:deploy_user][:database_encrypted_password]
end


node[:applications].each do |app|
  if app[:database] == 'postgresql'
    
    pg_user app[:app_user] do
    privileges superuser: false, createdb: false, login: true
    encrypted_password app[:app_user_encrypted_password]      # MD5 HASH
    end
    
    pg_database app[:name] do
      owner app[:app_user]
    end

  end
end



#node[:applications].each do |app|
#  if app[:database] == 'postgresql'
#    pg_database app[:name] do
#      owner user_name
#    end
#  end
#end



#  create a user with an MD5-encrypted password
#  pg_user "myuser" do
#  privileges superuser: false, createdb: false, login: true
#  encrypted_password "667ff118ef6d196c96313aeaee7da519"