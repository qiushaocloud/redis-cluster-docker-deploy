# 设定 redis cluster 端口范围，例如: [6373,6378]
MIN_REDIS_PORT_NUMBER=6373 # redis 最小端口
MAX_REDIS_PORT_NUMBER=6378 # redis 最大端口

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
REDIS_CLUSTER_ANNOUNCE_IP= # 所有节点配置统一的 REDIS_CLUSTER_ANNOUNCE_IP，REDIS_CLUSTER_ANNOUNCE_IP 可以是 IP/域名

# 域名映射列表，会将 列表中的内容追加到 /etc/hosts 中,为空则表示不追加
# 如果您 REDIS_CLUSTER_ANNOUNCE_IP 配置成了域名，但是您的域名又没有走 DNS 解析，那么您可以配置这个让您的域名写到 pod 里的 /etc/hosts 中, 例如: DOMAIN_TO_IPS=xxx.xxx.xxx.xxx@192.168.3.81
DOMAIN_TO_IPS= # 例如: DOMAIN_TO_IPS=xxx.xxx.xxx.xx1@192.168.3.81,xxx.xxx.xxx.xx2@192.168.3.82

# 指定每个节点上环境变量文件所在的目录，文件中设置的环境变量会覆盖 yaml 文件传入的环境变量
# 您需要提前将环境变量文件放到该目录下，环境变量文件命名规则 hostpath-env-<REDIS_PORT_NUMBER>，例如:/mnt/.redis-cluster-envs/hostpath-env-6373，可以参考 sh-tpl-files/hostpath-env-REDIS_PORT_NUMBER.tpl
ENV_FILE_HOST_PATH_DIR= # 如果需要在各个 redis 节点上配置不同的环境变量，则可以配置使用该配置，例如: /mnt/.redis-cluster-envs

REDIS_PASSWORD= # redis 密码

REDIS_CLUSTER_REPLICAS=1 # 每个 master 对应从节点个数