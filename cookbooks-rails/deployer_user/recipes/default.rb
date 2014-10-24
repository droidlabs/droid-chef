deploy_username = node[:deploy_user][:username]

deploy_password = `openssl passwd -1 "#{node[:deploy_user][:password]}"`.chomp

node.set[:authorization] = Hash[
  sudo: Hash[
    groups:       [deploy_username, 'vagrant', 'ubuntu'],
    users:        [deploy_username, 'vagrant', 'ubuntu'],
    passwordless: true
  ]
]

###### Create Super Deploy User [Ninja] ######

deploy_user deploy_username do           
  password deploy_password
end

###############################################

######## Create App_Deploy_Users ##############

node["applications"].each do |app|     
  deploy_user app[:name]+"_deployer" do
    deploy_password = `openssl passwd -1 "#{app[:name]}_PASSWORD"`.chomp
    password deploy_password
  end
end

###############################################       
