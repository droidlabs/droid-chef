# CREATE APP USERS AND GROUP

define :app_user do

  app = node.run_state[:current_app]
  app_user = params[:name]

  # Crete group and app_user
  user app_user do
    comment 'Deploy User'
    home "/home/#{app_user}"
    shell '/bin/bash'
    password params[:password]
    supports manage_home: true
  end

  # Change app_user groups, add to it a group deploy_user
  group app_user do
    members [app_user, node[:deploy_user][:username]]
    action :create
  end

  # Generate RSA keys
  execute "generate ssh keys for: #{app_user}." do
    user app_user
    creates "/home/#{app_user}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f /home/#{app_user}/.ssh/id_rsa -P \"\""
  end

  # Add github, bitbucket in ssh known hosts  
  if !File.exist?("/home/#{app_user}/.ssh/known_hosts")
    hosts_path = "/home/#{app_user}/.ssh/known_hosts"
    keys = ["github.com", "bitbucket.org"].map { |h| `ssh-keyscan -H -trsa,dsa -p 22 #{h}` }
    file "ssh_known_hosts for #{app_user}" do
      user app_user
      group app_user
      path hosts_path
      action :create
      content "#{keys.join($/)}#{$/}"
    end
  end

  # Create ".bash_profile"
  template "/home/#{app_user}/.bash_profile" do
    source "bash_profile.erb"
    user app_user
    group app_user
    variables(
        app_env: app[:environment]
      )
  end
end
