# attributes_include




include_attribute "mysql::default"

#############################################################################
#DROID ATTRIBUTES

default['mysql']['tunable']['collation-server']        = 'utf8_unicode_ci'
default['mysql']['tunable']['character-set-server']    = 'utf8'
default['mysql']['tunable']['key_buffer_size']         = '256M'
default['mysql']['tunable']['myisam-recover']          = 'BACKUP'
default['mysql']['tunable']['max_allowed_packet']      = '16M'
default['mysql']['tunable']['innodb_buffer_pool_size'] = '256M'
default['mysql']['bind_address']                       = ipaddress

#############################################################################

# passwords
default['mysql']['server_root_password']   = 'ilikerandompasswords'
default['mysql']['server_debian_password'] = nil
default['mysql']['server_repl_password']   = nil

# port
default['mysql']['port'] = '3306'

# server package version and action
default['mysql']['server_package_version'] = '5.6'
default['mysql']['server_package_action'] = 'install'

