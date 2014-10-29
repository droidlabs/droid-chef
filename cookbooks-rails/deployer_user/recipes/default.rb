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

def normalize_username(username)
  username.to_s.gsub(/[^A-Za-z0-9\_\-]/ui, "")[0..15]
end

node["applications"].each do |app|
  username = app[:deploy_username] || normalize_username(app[:name])
  password = app[:deploy_password] || "#{app[:name]}_PASSWORD"
  app_user username do
    deploy_password = `openssl passwd -1 #{password}`.chomp
    password deploy_password
  end
end

###############################################
