include_recipe "droid-monit"

monitrc 'droid-redis' do
   	template_cookbook 'droid-monit'
    template_source   'droid-redis.conf.erb'
end