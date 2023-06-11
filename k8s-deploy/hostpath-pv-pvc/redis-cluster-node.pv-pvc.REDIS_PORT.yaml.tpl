apiVersion: v1
kind: PersistentVolume
metadata:
  name: qiushaocloud-redis-cluster-pv-<REDIS_PORT>
  namespace: redis
  labels:
    pv: qiushaocloud-redis-cluster-pv-<REDIS_PORT>
spec:
  capacity:
    storage: <K8S_PV_STORAGE_SIZE>
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: qiushaocloud-redis-cluster-local-storage
  hostPath:
    path: <LOCAL_STORAGE_PATH>/redis-data-<REDIS_PORT>

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: qiushaocloud-redis-cluster-pvc-<REDIS_PORT>
  namespace: redis
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: <K8S_PV_STORAGE_SIZE>
  selector:
    matchLabels:
      pv: qiushaocloud-redis-cluster-pv-<REDIS_PORT>
  storageClassName: qiushaocloud-redis-cluster-local-storage
  volumeName: qiushaocloud-redis-cluster-pv-<REDIS_PORT>