deploy_username = node[:deploy_user][:username]

deploy_password = `openssl passwd -1 "#{node[:deploy_user][:password]}"`.chomp

node.set[:authorization] = Hash[
  sudo: Hash[
    groups:       [deploy_username, 'vagrant', 'ubuntu', 'sergey'],
    users:        [deploy_username, 'vagrant', 'ubuntu', 'sergey'],
    passwordless: true
  ]
]

###### Create Super Deploy User [Ninja] ######

deploy_user deploy_username do           
  password deploy_password
end

###############################################

######## Create App Users #####################

node["applications"].each do |app|     
  deploy_user app[:app_user] do
    deploy_password = `openssl passwd -1 "#{app[:app_user_password]}"`.chomp
    password deploy_password
  end
end

################################################       
