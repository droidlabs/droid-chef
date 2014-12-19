include_recipe "redis2::default_instance"

include_recipe 'droid-monit::redis'
include_recipe 'droid-backup::redis'


