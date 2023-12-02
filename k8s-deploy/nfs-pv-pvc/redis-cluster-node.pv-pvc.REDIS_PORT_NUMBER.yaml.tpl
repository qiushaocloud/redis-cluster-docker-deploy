apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis-cluster-pv-<REDIS_PORT_NUMBER>
  namespace: redis
  labels:
    pv: redis-cluster-pv-<REDIS_PORT_NUMBER>
spec:
  capacity:
    storage: <K8S_PV_STORAGE_SIZE>
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: redis-cluster-nfs
  nfs:
    server: <K8S_PV_NFS_SERVER>
    path: <K8S_PV_NFS_PATH>/redis-cluster-data-<REDIS_PORT_NUMBER>

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-cluster-pvc-<REDIS_PORT_NUMBER>
  namespace: redis
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: <K8S_PV_STORAGE_SIZE>
  selector:
    matchLabels:
      pv: redis-cluster-pv-<REDIS_PORT_NUMBER>
  storageClassName: redis-cluster-nfs
  volumeName: redis-cluster-pv-<REDIS_PORT_NUMBER>