# Create SUPER DEPLOY USER in the System

define :deploy_user do

  Chef::Log.debug("# create deploy group and user with name: #{params[:name]}")

  group params[:name]
  user params[:name] do
    comment "Deploy User"
    home "/home/#{params[:name]}"
    gid params[:name]
    shell "/bin/bash"
    password params[:password]
    supports manage_home: true
  end

  Chef::Log.debug("generate ssh keys for: #{params[:name]}")

  execute "generate ssh keys for: #{params[:name]}." do
    user params[:name]
    creates "/home/#{params[:name]}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f /home/#{params[:name]}/.ssh/id_rsa -P \"\""
  end

  # create ".bash_profile"
  file "/home/#{params[:name]}/.bash_profile" do
    user params[:name]
    group params[:name]
    action :touch
  end

  # directory for file downloads
  directory "/home/#{params[:name]}/downloads" do
    user params[:name]
    group params[:name]
    action :create
  end

end
