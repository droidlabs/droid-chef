define :deployer_gem do
  rbenv_gem params[:name] do
    rbenv_version node[:deploy_user][:ruby_version]
    version params[:version]
    user node[:deploy_user][:username]
  end
end