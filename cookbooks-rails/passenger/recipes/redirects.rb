deploy_username = node[:deploy_user][:username]
template "#{node[:passenger][:production][:path]}/conf/sites.d/nginx_redirects.conf" do
  source "nginx_redirects.conf.erb"
  owner  deploy_username
  group  deploy_username
  mode   "0640"
  variables(redirects: node[:nginx_redirects])
  notifies :restart, 'service[passenger]'
end