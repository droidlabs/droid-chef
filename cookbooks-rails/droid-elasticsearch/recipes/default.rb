# Wrapper-cookbook elasticsearch

# Execute default recipe
include_recipe 'elasticsearch::default'

# Change shell for elsticsearch user 
user node.elasticsearch[:user] do
  comment "ElasticSearch User"
  home    "#{node.elasticsearch[:dir]}/elasticsearch"
  shell   "/bin/false"
  uid     node.elasticsearch[:uid]
  gid     node.elasticsearch[:user]
  supports :manage_home => false
  action  :modify
  system true
end

# Make sure the service is started
service("elasticsearch") { action :start }

# Add monit cfg for elastic service
# Use after start elasticsearch and monit service !
include_recipe 'droid-monit::elasticsearch'