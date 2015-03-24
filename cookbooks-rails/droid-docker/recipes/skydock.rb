# docker pull crosbymichael/skydns
# docker pull crosbymichael/skydock
# docker pull crosbymichael/skydns


# docker run -d -p 172.17.42.1:53:53/udp
# --name skydns crosbymichael/skydns
# -nameserver 8.8.8.8:53 -domain docker

# Pull latest image
docker_image "crosbymichael/skydns"

# Run container exposing ports
docker_container "crosbymichael/skydns" do
  container_name "skydns"
  hostname       "skydns"
  command        "-nameserver 8.8.8.8:53 -domain docker"
  detach         true
  port           "172.17.42.1:53:53/udp" # host:container
  action :run
end


# sudo docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock -ttl 30 -environment dev -s /docker.sock -domain docker -name skydns

# Pull latest image
docker_image "crosbymichael/skydock"

# Run container exposing ports
docker_container "crosbymichael/skydock" do
  container_name "skydock"
  hostname       "skydock"
  command        "-ttl 30 -environment dev -s /docker.sock -domain docker -name skydns"
  detach         true
  volume         "/var/run/docker.sock:/docker.sock"
  action :run
end


