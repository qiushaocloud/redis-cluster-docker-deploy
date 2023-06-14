
# k8s hostPath 存储在本地的仓库路径
LOCAL_STORAGE_PATH=/mnt/redis-cluster-storages

# k8s pv 配置，如果配置了，则 LOCAL_STORAGE_PATH 无效
K8S_PV_NFS_SERVER=
K8S_PV_NFS_PATH=
K8S_PV_STORAGE_SIZE=30Gi

K8S_SVC_TYPE=ClusterIP # ClusterIP 或者 NodePort
IS_USE_HOST_NETWORK=no # redis pod 是否设置为 hostNetwork，如果设置为 hostNetwork，则 K8S_SVC_TYPE 会强制修改为 ClusterIP 且 clusterIP 设置为 None

# 节点选择器的策略
# 空值/NONE: 不需要选择器(建议在 NFS 存储方式下使用，在本地存储下使用会导致 pod 重启后数据保存到其它机器上的问题)
# REDIS_PORT: 使用 redis 端口作为选择器, 需要设置 k8s node label 的规则为: rdc-port-<REDIS_PORT>=true，例如: rdc-port-6373=true
# REDIS_GROUP@GROUP_NUM: 使用组的方式作为选择器，GROUP_NUM 表示分成几个组，用 (REDIS_PORT%GROUP_NUM + 1) 确定 GROUP_INDEX， 需要设置 k8s node label 的规则为: rdc-group-<GROUP_INDEX>=true，例如: rdc-group-1=true
K8S_NODE_SELECTOR_POLICY=REDIS_GROUP@1 # 值有: 空值/NONE、REDIS_PORT、REDIS_GROUP@GROUP_NUM(GROUP_NUM 表示分成几个组，例如: REDIS_GROUP@1)

# 使用 hostNetwork 模式可以为每个节点配置单独的 REDIS_CLUSTER_ANNOUNCE_IP，覆盖统一配置的 REDIS_CLUSTER_ANNOUNCE_IP, 或者将统一的 REDIS_CLUSTER_ANNOUNCE_IP 配置成空
# 如果不需要 hostNetwork 模式，那么可以走 K8S SVC, REDIS_CLUSTER_ANNOUNCE_IP 则配置成 SVC 接入点即可
REDIS_CLUSTER_ANNOUNCE_IP=xxx.xxx.xxx.xxx # 所有节点配置统一的 REDIS_CLUSTER_ANNOUNCE_IP

# 指定每个节点上环境变量文件所在的目录，文件中设置的环境变量会覆盖 yaml 文件传入的环境变量
# 您需要提前将环境变量文件放到该目录下，环境变量文件命名规则 hostpath-env-<REDIS_PORT_NUMBER>，例如:/mnt/redis-cluster-envs/hostpath-env-6373，可以参考 sh-tpl-files/hostpath-env-REDIS_PORT_NUMBER.sh.tpl
ENV_FILE_HOST_PATH_DIR= # 如果需要在各个 redis 节点上配置不同的环境变量，则可以配置使用该配置，例如: /mnt/redis-cluster-envs

REDIS_PASSWORD=password # redis 密码

REDIS_CLUSTER_REPLICAS=1 # 每个 master 对应从节点个数