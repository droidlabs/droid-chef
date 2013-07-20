name = "mysql"
deploy_user = node[:deploy_user][:username]
tmp_dir = "/home/#{deploy_user}/downloads"
plugins_dir = node[:newrelic][:plugins_dir]
agent_dir = File.join(plugins_dir, "newrelic_#{name}_plugin-1.0.5")

rbenv_gem "newrelic_plugin" do
  package_name    "newrelic_plugin"
  user            deploy_user
  rbenv_version   rbenv_version node[:deploy_user][:ruby_version]
end

directory "#{plugins_dir}" do
  mode 0755
  owner deploy_user
  group deploy_user
  recursive true
  action :create
end

unless File.exists? "#{agent_dir}/config/newrelic_plugin.yml"
  cookbook_file "#{tmp_dir}/newrelic_#{name}_plugin.gz" do
    owner deploy_user
    group deploy_user
    mode 0755
  end
  bash "extract plugin" do
    code "sudo -u #{deploy_user} tar -xzf #{tmp_dir}/newrelic_#{name}_plugin.gz -C #{plugins_dir}"
  end
end

template "#{agent_dir}/config/newrelic.properties" do
  source "newrelic_#{name}.properties.erb"
  owner deploy_user
  group deploy_user
  mode "640"
  variables(:license_key => node[:newrelic][:license_key])
  notifies(:restart, "service[newrelic-#{name}]") if node[:newrelic][:enabled]
end

template "#{agent_dir}/config/mysql.instance.json" do
  source "newrelic_#{name}.instance.json.erb"
  owner deploy_user
  group deploy_user
  mode "640"
  variables(:license_key => node[:newrelic][:license_key])
  notifies(:restart, "service[newrelic-#{name}]") if node[:newrelic][:enabled]
end

template "/etc/init.d/newrelic-mysql" do
  source "newrelic_#{name}_service.erb"
  owner 'root'
  group 'root'
  mode "770"
  variables(:agent_dir => agent_dir)
  notifies(:restart, "service[newrelic-#{name}]") if node[:newrelic][:enabled]
end

directory "#{agent_dir}/tmp" do
  mode 0755
  owner deploy_user
  group deploy_user
  action :create
end

service "newrelic-#{name}" do
  action :nothing
end