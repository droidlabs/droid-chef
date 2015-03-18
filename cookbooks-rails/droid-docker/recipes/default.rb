# Pull latest image
docker_image "postgres"

# Run container exposing ports
docker_container "postgres" do
  container_name "postgres_backend1"
  hostname       "postgres_backend1"
  detach true
  port "5433:5432" # host:container
  # env "SETTINGS_FLAVOR=local"
  volume "/var/lib/docker-postgresql:/var/lib/postgresql"
  action :run
end

# Run container exposing ports
docker_container "postgres" do
  container_name "postgres_backend2"
  hostname       "postgres_backend2"
  detach         true
  port           "5434:5432" # host:container
  # env "SETTINGS_FLAVOR=local"
  volume "/var/lib/docker-postgresql:/var/lib/postgresql"
  action :run
end
