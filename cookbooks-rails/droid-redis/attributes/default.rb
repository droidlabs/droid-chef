
include_attribute "redis2::default"

default[:redis][:pid_file] = '/etc/sv/redis_prime/supervise/pid'
default[:redis][:port] = 6379
default[:redis][:dump_file] = '/var/lib/redis/dump.rdb'

# #
# # Locations
# #

# default[:redis][:conf_dir]          = "/etc/redis"
# default[:redis][:log_dir]           = "/var/log/redis"
# default[:redis][:data_dir]          = "/var/lib/redis"

# default[:redis][:home_dir]          = "/usr/local/share/redis"
# default[:redis][:pid_file]          = "/var/run/redis.pid"

# default[:redis][:db_basename]       = "dump.rdb"

# default[:redis ][:user]              = 'redis'
# default[:users ]['redis'][:uid]      = 335
# default[:groups]['redis'][:gid]      = 335

# #
# # Server
# #

# default[:redis][:server][:addr]     = "0.0.0.0"
# default[:redis][:server][:port]     = "6379"

