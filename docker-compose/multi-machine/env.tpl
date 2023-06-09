REDIS_PORT=6373 # reids 端口
REDIS_PASSWORD=qiushaocloud # redis 密码
REDIS_CLUSTER_ANNOUNCE_IP=xxx.xxx.xxx.xxx # 节点服务的IP，一般为宿主机的IP

REDIS_CLUSTER_REPLICAS=1 # 每个 reid 从节点个数
# redis 集群的节点
REDIS_NODES=redis-cluster-node-6373:6373 redis-cluster-node-6374:6374 redis-cluster-node-6375:6375 redis-cluster-node-6376:6376 redis-cluster-node-6377:6377 redis-cluster-node-6378:6378

STORAGES_DIR=/mnt/redis-cluster-storages # 宿主机上存储仓库的目录