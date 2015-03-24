
# Pull image and create container SkyDock and SkyDNS
include_recipe 'droid-docker::skydock'

include_recipe 'droid-docker::ubuntu_postgres'

# Pull latest image
docker_image "postgres"

# Run container exposing ports
docker_container "postgres" do
  container_name "postgres_master"
  hostname       "postgres_master"
  detach         true
  # link           ["pgpool:pgpool", "postgres_backend2:postgres_backend2"]
  port           ["5433:5432", "22"] # host:container
  dns            "172.17.42.1"
  # env          "SETTINGS_FLAVOR=local"
  volume         "/docker-data/postgres_master/var/lib/postgresql:/var/lib/postgresql"
  action :run
end

# Run container exposing ports
docker_container "postgres" do
  container_name "postgres_slave1"
  hostname       "postgres_slave1"
  detach         true
  # link           ["pgpool:pgpool", "postgres_backend1:postgres_backend1"]
  port           ["5434:5432", "22"] # host:container
  dns            "172.17.42.1"
  # env          "SETTINGS_FLAVOR=local"
  volume         "/docker-data/postgres_slave1/var/lib/postgresql:/var/lib/postgresql"
  action :run
end

# Pull latest image PGPOOL2
docker_image "danharbin/pgpool2"

# Run container exposing ports
docker_container "danharbin/pgpool2" do
  container_name "pgpool"
  hostname       "pgpool"
  detach         true
  port           ["81:80", "22"] # host:container
  dns            "172.17.42.1"
  action :run
end

# sudo docker run -d -p 80:80 clue/adminer

# Pull latest image clue/adminer
docker_image "clue/adminer"

# Run container exposing ports
docker_container "clue/adminer" do
  container_name "adminer"
  hostname       "adminer"
  detach         true
  #expose         "80"
  port           "82:80" # host:container
  dns            "172.17.42.1"  
  action :run
end

# docker run -d -p 9000:9000 --privileged 
# -v /var/run/docker.sock:/var/run/docker.sock dockerui/dockerui

# Pull latest image dockerui/dockerui
docker_image "dockerui/dockerui"

# Run container exposing ports
docker_container "dockerui/dockerui" do
  container_name "dockerui"
  hostname       "dockerui"
  detach         true
  #expose         "80"
  port           "9000:9000" # host:container
  dns            "172.17.42.1"  
  # env          "SETTINGS_FLAVOR=local"
  volume         "/var/run/docker.sock:/var/run/docker.sock"
  action :run
end
