
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
