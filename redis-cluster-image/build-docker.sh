docker pull redis:latest
docker build -t qiushaocloud/redis-cluster:latest .
docker build -f Dockerfile.bitnami-create-redis-cluster -t qiushaocloud/bitnami-create-redis-cluster:latest .