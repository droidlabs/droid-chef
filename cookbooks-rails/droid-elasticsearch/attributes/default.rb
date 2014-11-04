
# LOAD DEFAULT ATTRIBUTES

include_attribute "elasticsearch::default"

# DROID ATTRIBUTES

default.elasticsearch[:version]       = "0.90.13"

# === USER & PATHS
#
default.elasticsearch[:dir]       = "/usr/local"
default.elasticsearch[:bindir]    = "/usr/local/bin"
default.elasticsearch[:user]      = "elasticsearch"
default.elasticsearch[:uid]       = nil
default.elasticsearch[:gid]       = nil

default.elasticsearch[:path][:conf] = "/usr/local/etc/elasticsearch"
default.elasticsearch[:path][:data] = "/usr/local/var/data/elasticsearch"
  default.elasticsearch[:path][:logs] = "/var/log/elasticsearch"
# default.elasticsearch[:path][:logs] = "/usr/local/var/log/elasticsearch" # Default

  default.elasticsearch[:pid_path]  = "/usr/local/var/run/elasticsearch"   # ????
# default.elasticsearch[:pid_path]  = "/usr/local/var/run" # Default
default.elasticsearch[:pid_file]  = "#{node.elasticsearch[:pid_path]}/#{node.elasticsearch[:node][:name].to_s.gsub(/\W/, '_')}.pid"

default.elasticsearch[:templates][:elasticsearch_env] = "elasticsearch-env.sh.erb"
default.elasticsearch[:templates][:elasticsearch_yml] = "elasticsearch.yml.erb"
default.elasticsearch[:templates][:logging_yml]       = "logging.yml.erb"

# === MEMORY
#
# Maximum amount of memory to use is automatically computed as one half of total available memory on the machine.
# You may choose to set it in your node/role configuration instead.
#
# allocated_memory = "1000m"
allocated_memory = "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
default.elasticsearch[:allocated_memory] = allocated_memory

# === GARBAGE COLLECTION SETTINGS
#
default.elasticsearch[:gc_settings] =<<-CONFIG
  -XX:+UseParNewGC
  -XX:+UseConcMarkSweepGC
  -XX:CMSInitiatingOccupancyFraction=75
  -XX:+UseCMSInitiatingOccupancyOnly
  -XX:+HeapDumpOnOutOfMemoryError
CONFIG

# === LIMITS
#
# By default, the `mlockall` is set to true: on weak machines and Vagrant boxes,
# you may want to disable it.
#
# default.elasticsearch[:mlockall] = true ?????
default.elasticsearch[:bootstrap][:mlockall] = ( node.memory.total.to_i >= 1048576 ? true : false )
default.elasticsearch[:limits][:memlock] = 'unlimited'
default.elasticsearch[:limits][:nofile]  = '64000'

# === PRODUCTION SETTINGS
#
# default.elasticsearch[:index_shards] = 5    #??
# default.elasticsearch[:index_replicas] = 1  #?? 	
default.elasticsearch[:index][:mapper][:dynamic]   = true
default.elasticsearch[:action][:auto_create_index] = true
default.elasticsearch[:action][:disable_delete_all_indices] = true
default.elasticsearch[:node][:max_local_storage_nodes] = 1

default.elasticsearch[:discovery][:zen][:ping][:multicast][:enabled] = true
default.elasticsearch[:discovery][:zen][:minimum_master_nodes] = 1
default.elasticsearch[:gateway][:type] = 'local'
default.elasticsearch[:gateway][:expected_nodes] = 1

default.elasticsearch[:thread_stack_size] = "256k"

default.elasticsearch[:env_options] = ""

# === OTHER SETTINGS
#
default.elasticsearch[:skip_restart] = false
default.elasticsearch[:skip_start] = false

# === PORT
#
default.elasticsearch[:http][:port] = 9200

# === CUSTOM CONFIGURATION
#
default.elasticsearch[:custom_config] = {}

# === LOGGING
#
# See `attributes/logging.rb`
#
default.elasticsearch[:logging] = {}