REDIS_PASSWORD=qiushaocloud # redis 密码
REDIS_CLUSTER_ANNOUNCE_IP=xxx.xxx.xxx.xxx # 节点服务的IP，一般为宿主机的IP

REDIS_CLUSTER_REPLICAS=1 # 每个 reid 从节点个数
# redis 集群的节点
REDIS_NODES="xxx.xxx.xxx.xx1:6373 xxx.xxx.xxx.xx2:6374 xxx.xxx.xxx.xx3:6375 xxx.xxx.xxx.xx4:6376 xxx.xxx.xxx.xx5:6377 xxx.xxx.xxx.xx6:6378"

STORAGES_DIR=/mnt/redis-cluster-storages # 宿主机上存储仓库的目录
