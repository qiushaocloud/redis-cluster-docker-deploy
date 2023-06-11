
# k8s hostPath 存储在本地的仓库路径
LOCAL_STORAGE_PATH=mnt/redis-cluster-storages

# k8s pv 配置，如果配置了，则 LOCAL_STORAGE_PATH 无效
K8S_PV_NFS_SERVER=
K8S_PV_NFS_PATH=
K8S_PV_STORAGE_SIZE=30Gi