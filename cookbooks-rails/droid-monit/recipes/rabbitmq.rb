include_recipe "droid-monit"

monitrc 'droid-rabbitmq' do
 	template_cookbook 'droid-monit'
  template_source   'droid-rabbitmq.conf.erb'
end