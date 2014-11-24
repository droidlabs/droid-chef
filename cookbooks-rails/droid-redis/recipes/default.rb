
include_recipe 'redis::install_from_package'

include_recipe 'droid-monit::redis'
