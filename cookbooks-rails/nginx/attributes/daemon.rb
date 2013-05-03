default[:nginx][:nginx_version] = '1.3.15'
default[:nginx][:path] = '/opt/nginx'
default[:nginx][:configure_flags] = '--with-ipv6 --with-http_stub_status_module --with-http_ssl_module'
default[:nginx][:log_path] = '/var/log/passenger/'

# Tune these for your environment, see:
# http://www.modrails.com/documentation/Users%20guide%20Nginx.html#_resource_control_and_optimization_options
default[:nginx][:max_pool_size] = 15
default[:nginx][:min_instances] = 2
default[:nginx][:pool_idle_time] = 0
default[:nginx][:max_instances_per_app] = 0
# a list of URL's to pre-start.
default[:nginx][:pre_start] = []

default[:nginx][:sendfile] = true
default[:nginx][:tcp_nopush] = false
# Nginx's default is 0, but we don't want that.
default[:nginx][:keepalive_timeout] = 65
default[:nginx][:gzip] = true
default[:nginx][:worker_connections] = 1024

# Enable the status server on 127.0.0.1
default[:nginx][:status_server] = false
