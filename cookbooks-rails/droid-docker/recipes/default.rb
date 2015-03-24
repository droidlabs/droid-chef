
# Pull image and create container SkyDock and SkyDNS
include_recipe 'droid-docker::skydock'

include_recipe 'droid-docker::ubuntu_postgres'

include_recipe 'droid-docker::postgres_cluster_pgpool'

include_recipe 'droid-docker::adminer_dockerui'
