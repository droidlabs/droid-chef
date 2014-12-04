include_recipe "droid-monit"

monitrc 'droid-postgresql' do
  template_cookbook 'droid-monit'
  template_source   'droid-postgresql.conf.erb'
end