include_recipe "droid-monit"

monitrc 'droid-newrelic' do
   	template_cookbook 'droid-monit'
    template_source   'droid-newrelic.conf.erb'
end