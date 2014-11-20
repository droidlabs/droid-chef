# Cookbook Name:: droid-newrelic
# Recipe:: default
# DroidLabs, fadeev2010@gmail.com

include_recipe 'newrelic-ng::nrsysmond-default'
# include_recipe 'newrelic-ng::plugin-agent-default'
# include_recipe 'newrelic-ng::generic-agent-default'

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# NEWRELIC PLUGINS
#
if node['newrelic']['plugins']['mysql']
  # Set attribute for mysql plugin
  node.default[:newrelic][:mysql][:servers] = [ 
                                         {  
                                            name:         node.name,
                                            host:         'localhost',  
                                            metrics:      'status,newrelic',
                                            mysql_user:   'root',
                                            mysql_passwd: node[:deploy_user][:database_root_password]
                                          }
  ]
   
  # install mysql newrelic plugin
  include_recipe 'newrelic_plugins::mysql'
end

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# NEWRELIC MEETME PLUGIN BEGIN

# Meetme
meetme_config = {}

if node['newrelic']['plugins']['postgresql']
  meetme_config['postgresql'] = {
    host:      'localhost',
    port:      5432,
    user:      'postgres',
    dbname:    'postgres',
    superuser: 'False'
  }
end  

if node['newrelic']['plugins']['elasticsearch']
  meetme_config['elasticsearch'] = {
    name:    'elasticsearch',
    host:    'localhost',
    port:    '9200',
    scheme:  'http'
  }
end
  
if node['newrelic']['plugins']['rabbitmq']
   #needs to be run before hand to set attributes (port specifically)
   meetme_config['rabbitmq'] = {
    name:     node['hostname'],
    host:     'localhost',
    port:     15_672,
    username: 'guest',  # add user monitor in rabbit and change here
    password: 'guest',
    api_path: '/api'
  }
end
 
if node['newrelic']['plugins']['nginx']
  meetme_config['nginx'] = {
    name: node['hostname'],
    host: 'localhost',
    port: '80',
    path: '/nginx_stub_status'
  }
end

#if node.recipe?('redis::default' || 'redis::install_from_package')
#  meetme_config['redis'] = {
#    name: node['hostname'],
#    host: 'localhost',
#   port: node[:redis][:server][:port]
#  }
#end

node.override['newrelic_meetme_plugin']['services'] = meetme_config

# Install lib for make newrelic-plugin-agent
package 'python-dev'

#Include recipe after attribute override ['newrelic_meetme_plugin']['services']
include_recipe 'newrelic_meetme_plugin'

# NEWRELIC MEETME PLUGIN END  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


