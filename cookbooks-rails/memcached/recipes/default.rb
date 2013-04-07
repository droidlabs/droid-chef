include_recipe "logrotate"

package "memcached" do
  action :install
end

template "memcached_config" do
  case node["platform_family"]
  when "rhel"
    path "/etc/sysconfig/memcached"
    source "memcached.sysconfig.erb"
  when "debian"
    path "/etc/memcached.conf"
    source "memcached.conf.erb"
  end

  mode "0644"
  variables(
    :listen           => node["memcached"]["listen"],
    :port             => node["memcached"]["port"],
    :max_memory       => node["memcached"]["max_memory"],
    :max_connections  => node["memcached"]["max_connections"],
    :log_file         => node["memcached"]["log_file"]
  )
  notifies :restart, "service[memcached]", :immediately
end

if node["platform_family"] == "debian"
  logrotate_app "memcached" do
    cookbook "logrotate"
    path node["memcached"]["log_file"]
    frequency "daily"
    rotate 7
    create "644 root root"
  end
end

service "memcached" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action :enable
end
