name = "nginx"
deploy_user = node[:deploy_user][:username]
tmp_dir = "/home/#{deploy_user}/downloads"
plugins_dir = node[:newrelic][:plugins_dir]
agent_dir = File.join(plugins_dir, "newrelic_#{name}_agent")

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
  cookbook_file "#{tmp_dir}/newrelic_#{name}_agent.gz" do
    owner deploy_user
    group deploy_user
    mode 0755
  end
  bash "extract plugin" do
    code "sudo -u #{deploy_user} tar -xzf #{tmp_dir}/newrelic_#{name}_agent.gz -C #{plugins_dir}"
  end
end

template "#{agent_dir}/config/newrelic_plugin.yml" do
  source "newrelic_#{name}_plugin.yml.erb"
  owner deploy_user
  group deploy_user
  mode "640"
  variables(:license_key => node[:newrelic][:license_key])
  notifies(:restart, "service[newrelic-#{name}]") if node[:newrelic][:enabled]
end

directory "#{agent_dir}/tmp" do
  mode 0755
  owner deploy_user
  group deploy_user
  action :create
end

service "newrelic-#{name}" do
  service_name "newrelic-#{name}"
  enabled true
  running true
  restart_command "sudo -u #{deploy_user} -i #{agent_dir}/newrelic_#{name}_agent.daemon restart"
  start_command "sudo -u #{deploy_user} -i #{agent_dir}/newrelic_#{name}_agent.daemon start"
  stop_command "sudo -u #{deploy_user} -i #{agent_dir}/newrelic_#{name}_agent.daemon stop"
  supports [ :start, :stop, :restart ]
  action [ :nothing ]
end