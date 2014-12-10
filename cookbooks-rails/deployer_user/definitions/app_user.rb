# CREATE APP USERS AND GROUP

define :app_user do

  # Chef::Log.debug("# create deploy group and user with name: #{params_name}")
  params_name = params[:name] 
  app = node.run_state[:current_app] 

  group params_name
  user params_name do
    comment 'Deploy User'
    home "/home/#{params_name}"
    gid params_name
    shell '/bin/bash'
    password params[:password]
    supports manage_home: true
  end

  # Chef::Log.info("# params[:deploy_username1] = #{params[:deploy_username1]}")

  group params_name do
    members ["#{params_name}", "#{node[:deploy_user][:username]}"]
    action :create
  end


  #Chef::Log.debug("generate ssh keys for: #{params_name}")

  execute "generate ssh keys for: #{params_name}." do
    user params_name
    creates "/home/#{params_name}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f /home/#{params_name}/.ssh/id_rsa -P \"\""
  end

  keys = ["github.com", "bitbucket.org"].map { |h| `ssh-keyscan -H -trsa,dsa -p 22 #{h}` }
  hosts_path = "/home/#{params_name}/.ssh/known_hosts"
  file "ssh_known_hosts" do
    user params_name
    group params_name
    path hosts_path
    action :create
    content "#{keys.join($/)}#{$/}"
    not_if { File.exists?(hosts_path) }
  end

  # create ".bash_profile"
  template "/home/#{params_name}/.bash_profile" do
    source "bash_profile.erb"
    user params_name
    group params_name
    variables(
        app_env: app[:environment]
      )
  end

  # directory for file downloads
  directory "/home/#{params_name}/downloads" do
    user params_name
    group params_name
    action :create
  end

end
