docker pull redis:latest
docker pull bitnami/redis-cluster:latest
docker pull bitnami/redis-sentinel:latest

docker build -t qiushaocloud/redis-cluster:latest .
docker build -f Dockerfile.bitnami-create-redis-cluster -t qiushaocloud/bitnami-create-redis-cluster:latest .
docker build -f Dockerfile.bitnami-extra-redis -t qiushaocloud/bitnami-extra-redis:latest .
docker build -f Dockerfile.bitnami-extra-redis-sentinel -t qiushaocloud/bitnami-extra-redis-sentinel:latest .