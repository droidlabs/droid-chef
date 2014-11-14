# attributes_include
# Wrapper-Cookbook droid-mysql
# attributes/defaul.rb
# Droid Labs LLC
# faeev2010@gmail.com

include_attribute "mysql::default"

#############################################################################
#DROID ATTRIBUTES

default['mysql']['data_dir'] 						   = '/var/lib/mysql' # '/opt/local/lib/mysql'

default['mysql']['tunable']['collation-server']        = 'utf8_unicode_ci'
default['mysql']['tunable']['character-set-server']    = 'utf8'
default['mysql']['tunable']['key_buffer_size']         = '256M'
default['mysql']['tunable']['myisam-recover']          = 'BACKUP'
default['mysql']['tunable']['max_allowed_packet']      = '16M'
default['mysql']['tunable']['innodb_buffer_pool_size'] = '256M'
default['mysql']['bind_address']                       = '127.0.0.1' # node.name # ipadress

# used in grants.sql
default['mysql']['allow_remote_root']				   = false
default['mysql']['remove_anonymous_users'] 			   = true
default['mysql']['root_network_acl'] 				   = nil           #!!!!!!!!

default['mysql']['remove_test_database']			   = true

#############################################################################

# passwords
default['mysql']['server_root_password']   = node[:deploy_user][:database_root_password]
default['mysql']['server_debian_password'] = nil
default['mysql']['server_repl_password']   = nil

# port
default['mysql']['port'] = '3306'

# server package version and action
default['mysql']['version']                = '5.6'
#default['mysql']['server_package_version'] = '5.6'
default['mysql']['server_package_action']  = 'install'

