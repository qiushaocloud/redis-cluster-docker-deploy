
# k8s hostPath 存储在本地的仓库路径
LOCAL_STORAGE_PATH=/mnt/redis-cluster-storages

# k8s pv 配置，如果配置了，则 LOCAL_STORAGE_PATH 无效
K8S_PV_NFS_SERVER=
K8S_PV_NFS_PATH=
K8S_PV_STORAGE_SIZE=30Gi

K8S_SVC_TYPE=NodePort # ClusterIP 或者 NodePort
K8S_SVC_CLUSTERIP_IS_NODE=no # k8s svc clusterIP 是否设置为 None

# 如果 K8S_SVC_TYPE 设置为 ClusterIP 且 K8S_SVC_CLUSTERIP_IS_NODE 设置为 yes，则 redis 节点使用 hostNetwork 模式
# 而使用 hostNetwork 模式可以为每个节点配置单独的 REDIS_CLUSTER_ANNOUNCE_IP，覆盖统一配置的 REDIS_CLUSTER_ANNOUNCE_IP, 或者将统一的 REDIS_CLUSTER_ANNOUNCE_IP 配置成空
# 如果不需要 hostNetwork 模式，那么可以走 K8S SVC, REDIS_CLUSTER_ANNOUNCE_IP 则配置成 SVC 接入点即可
REDIS_CLUSTER_ANNOUNCE_IP=xxx.xxx.xxx.xxx # 所有节点配置统一的 REDIS_CLUSTER_ANNOUNCE_IP

# 当 redis 节点使用 hostNetwork 模式，指定每个节点上环境变量文件所在的目录【hostNetwork 模式即：K8S_SVC_TYPE == ClusterIP && K8S_SVC_CLUSTERIP_IS_NODE == yes】
ENV_FILE_HOST_PATH_DIR=/mnt/redis-cluster-envs # 您需要提前将环境变量文件放到该目录下，环境变量文件命名规则 .env-<REDIS_PORT_NUMBER>，例如:/mnt/redis-cluster-envs/.env-6373

REDIS_PASSWORD=qiushaocloud # redis 密码