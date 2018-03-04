mkdir -Force /tmp/docker
cp /vagrant/Dockerfile /tmp/docker/Dockerfile
cd /tmp/docker

docker build --tag hello-world:local .
docker run --name hello-world-local hello-world:local

docker rm hello-world-local
