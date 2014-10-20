# attributes_include




include_attribute "mysql::default"

#############################################################################
#DROID ATTRIBUTES

node['mysql']['tunable']['collation-server']     = 'utf8_unicode_ci'
node['mysql']['tunable']['character-set-server'] = 'utf8'
node['mysql']['tunable']['key_buffer_size']      = '256M'
node['mysql']['tunable']['myisam-recover']       = 'BACKUP'
node['mysql']['tunable']['max_allowed_packet']   = '16M'

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

