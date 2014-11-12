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