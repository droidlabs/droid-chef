# =======================================================
# NEWRELIC-NG

include_attribute "newrelic-ng::defaults"

default['newrelic-ng']['license_key'] = node[:newrelic][:license_key]

default['newrelic-ng']['user']['name']   = 'newrelic'
default['newrelic-ng']['user']['group']  = 'newrelic'
default['newrelic-ng']['user']['shell']  = '/bin/sh'
default['newrelic-ng']['user']['system'] = true
default['newrelic-ng']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i386'

# =======================================================
# NEWRELIC MEETME PLUGIN

include_attribute "newrelic_meetme_plugin"
 
default['newrelic_meetme_plugin']['license'] = node[:newrelic][:license_key]
default['newrelic_meetme_plugin']['python_recipe'] = 'python::pip'
default['newrelic_meetme_plugin']['python_pip_action'] = :install
default['newrelic_meetme_plugin']['python_pip_version'] = 'latest'
default['newrelic_meetme_plugin']['python_pip_venv'] = nil
default['newrelic_meetme_plugin']['service_name'] = 'newrelic-plugin-agent'
default['newrelic_meetme_plugin']['service_actions'] = [:enable, :start] # starts the service if it's not running and enables it to start at system boot time
default['newrelic_meetme_plugin']['wake_interval'] = 60
default['newrelic_meetme_plugin']['proxy'] = nil
default['newrelic_meetme_plugin']['config_file'] = '/etc/newrelic/newrelic-plugin-agent.cfg'
default['newrelic_meetme_plugin']['pid_file'] = '/var/run/newrelic/newrelic-plugin-agent.pid'
default['newrelic_meetme_plugin']['log_file'] = '/var/log/newrelic/newrelic-plugin-agent.log'
default['newrelic_meetme_plugin']['user'] = 'newrelic'
default['newrelic_meetme_plugin']['additional_requirements'] = ["postgresql"] # "postgresql", "mongodb"

# =======================================================
# NEWRELIC PLUGINS

include_attribute 'newrelic_plugins::default'

default['newrelic']['license_key'] = node[:newrelic][:license_key]

# mysql plugin attributes
default[:newrelic][:mysql][:version]      = "2.0.0"
default[:newrelic][:mysql][:user]         = "root"   #mysql auth info is in a conf file controled by this user
default[:newrelic][:mysql][:download_url] = "https://raw.github.com/newrelic-platform/newrelic_mysql_java_plugin/master/dist/newrelic_mysql_plugin-#{node[:newrelic][:mysql][:version]}.tar.gz"
default[:newrelic][:mysql][:install_path] = "/opt/newrelic"
default[:newrelic][:mysql][:plugin_path]  = "#{node[:newrelic][:mysql][:install_path]}/newrelic_mysql_plugin"
default[:newrelic][:mysql][:java_options] = '-Xmx128m'

# Attribute for [:newrelic][:mysql][:servers] load from recipe
# default[:newrelic][:mysql][:servers] = [ 
#                                          {  
#                                             name:         node.name,
#                                             host:         'localhost',	
#                                             metrics:      'status,newrelic',
#                                             mysql_user:   'root',
#                                             mysql_passwd: node[:deploy_user][:database_root_password]
#                                          }
# ]