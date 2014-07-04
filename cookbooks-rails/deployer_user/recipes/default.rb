deploy_username = node[:deploy_user][:username]

deploy_password = `openssl passwd -1 "#{node[:deploy_user][:password]}"`.chomp

node.set[:authorization] = Hash[
  sudo: Hash[
    groups: [deploy_username, 'vagrant', 'ubuntu'],
    users: [deploy_username, 'vagrant', 'ubuntu'],
    passwordless: true
  ]
]

Chef::Log.debug("# create deploy group and user with name: #{deploy_username}")

group deploy_username
user deploy_username do
  comment "Deploy User"
  home "/home/#{deploy_username}"
  gid deploy_username
  shell "/bin/bash"
  password deploy_password
  supports manage_home: true
end

Chef::Log.debug("generate ssh keys for: #{deploy_username}")

execute "generate ssh keys for: #{deploy_username}." do
  user deploy_username
  creates "/home/#{deploy_username}/.ssh/id_rsa.pub"
  command "ssh-keygen -t rsa -q -f /home/#{deploy_username}/.ssh/id_rsa -P \"\""
end

keys = ["github.com", "bitbucket.org"].map { |h| `ssh-keyscan -H -trsa,dsa -p 22 #{h}` }
hosts_path = "/home/#{deploy_username}/.ssh/known_hosts"
file "ssh_known_hosts" do
  user deploy_username
  group deploy_username
  path hosts_path
  action :create
  content "#{keys.join($/)}#{$/}"
  not_if { File.exists?(hosts_path) }
end

# create ".bash_profile"
file "/home/#{deploy_username}/.bash_profile" do
  user deploy_username
  group deploy_username
  action :touch
end

# directory for file downloads
directory "/home/#{deploy_username}/downloads" do
  user deploy_username
  group deploy_username
  action :create
end

execute "change /usr/local owner" do
  command "chown -R #{deploy_username}:#{deploy_username} /usr/local"
end