
# Pull latest image
docker_image "ubuntu"

# Run container exposing ports
docker_container "ubuntu" do
  container_name "ubuntu_master"
  hostname       "ubuntu_master"
  detach         true
  # link           ["pgpool:pgpool", "ubuntu_backend2:ubuntu_backend2"]
  port           ["5435:5432", "22"] # host:container
  dns            "172.17.42.1"
  # env          "SETTINGS_FLAVOR=local"
  volume         "/docker-data/ubuntu_master/var/lib/postgresql:/var/lib/postgresql"
  command        "/bin/sh -c \"while true; do echo hello world; sleep 1; done\" "
  action :run
end

# Run container exposing ports
docker_container "ubuntu" do
  container_name "ubuntu_slave1"
  hostname       "ubuntu_slave1"
  detach         true
  # link           ["pgpool:pgpool", "ubuntu_backend1:ubuntu_backend1"]
  port           ["5436:5432", "22"] # host:container #"5436:5432", 
  dns            "172.17.42.1"
  # env          "SETTINGS_FLAVOR=local"
  volume         "/docker-data/ubuntu_slave1/var/lib/postgresql:/var/lib/postgresql"
  command        "/bin/sh -c \"while true; do echo hello world; sleep 1; done\" "
  action :run
end