include_recipe "droid-monit"

monitrc 'droid-nginx' do
  template_cookbook 'droid-monit'
  template_source   'droid-nginx-monit.conf.erb'
end
