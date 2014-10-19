#
# Cookbook Name:: droid-postgresql //Wrapper cookbook
# Attributes:: default
#
# Author:: Fadeev <fadeev2010@gmail.com>
#
# 
#

include_attribute "postgresql"  #LOAD default attributes for postrgresql
include_attribute "postgresql::postgis"     # ????

# DROID ATTRIBUTIONS: ---------------------------------------------------------
default["postgresql"]["version"]                         = "9.2"
default["postgresql"]["ssl"]                             = false
default["postgresql"]["pg_hba_defaults"]                 = false
#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------
default["postgresql"]["data_directory"]                  = "/var/lib/postgresql/#{node["postgresql"]["version"]}/main"
default["postgresql"]["hba_file"]                        = "/etc/postgresql/#{node["postgresql"]["version"]}/main/pg_hba.conf"
default["postgresql"]["ident_file"]                      = "/etc/postgresql/#{node["postgresql"]["version"]}/main/pg_ident.conf"
default["postgresql"]["external_pid_file"]               = "/var/run/postgresql/#{node["postgresql"]["version"]}-main.pid"


default["postgresql"]["pg_hba"]["type"]                  = ['local', 'host',         'host',      'host'   ]
default["postgresql"]["pg_hba"]["db"]                    = ['all',   'all',          'all',       'all'    ]
default["postgresql"]["pg_hba"]["user"]                  = ['all',   'all',          'all',       'all'    ]
default["postgresql"]["pg_hba"]["addr"]                  = [' ',     '127.0.0.1/32', 'localhost', '::1/128']
default["postgresql"]["pg_hba"]["method"]                = ['trust', 'trust',        'trust',     'trust'  ]

#default["postgresql"]["pg_hba"]                          = Hash[
#	type:   [ "local", "host",         "host",      "host"   ],
#	db:     [ "all",   "all",          "all",       "all"    ],
#	user:   [ "all",   "all",          "all",       "all"    ],
#	addr:   [ " ",     "127.0.0.1/32", "localhost", "::1/128"],
#	method: [ "trust", "trust",        "trust",     "trust"  ]
#]	


#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

if Gem::Version.new(node["postgresql"]["version"]) >= Gem::Version.new("9.3")
  default["postgresql"]["unix_socket_directories"]       = "/var/run/postgresql"
else
  default["postgresql"]["unix_socket_directory"]         = "/var/run/postgresql"
end