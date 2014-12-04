# Wrapper-cookbook monit

# Execute default recipe
include_recipe 'monit::default'

# SSH monit cfg
monitrc 'droid-ssh' do
  template_cookbook 'droid-monit'
  template_source   'droid-ssh.conf.erb'
end

# System monit cfg
monitrc 'droid-system' do
  template_cookbook 'droid-monit'
  template_source   'droid-system.conf.erb'
end

# Security monit cfg
monitrc 'droid-security' do
  template_cookbook 'droid-monit'
  template_source   'droid-security.conf.erb'
end

# Add logrotate cfg for monit
include_recipe "logrotate"
logrotate_app "droid-monit" do
  path "/var/log/syslog.log"
  rotate 12
end