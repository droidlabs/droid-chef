include_recipe "droid-monit"

monitrc 'droid-mysql' do
  template_cookbook 'droid-monit'
  template_source   'droid-mysql.conf.erb'
end