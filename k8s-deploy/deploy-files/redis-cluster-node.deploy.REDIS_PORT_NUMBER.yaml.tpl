apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-node-svc-<REDIS_PORT_NUMBER>
spec:
  type: <K8S_SVC_TYPE>
  clusterIP: None
  selector:
    app: redis-cluster-node-<REDIS_PORT_NUMBER>
  ports:
    - name: redis-cluster-node-port-<REDIS_PORT_NUMBER>
      port: <REDIS_PORT_NUMBER>
      targetPort: <REDIS_PORT_NUMBER>
      nodePort: <REDIS_PORT_NUMBER>
    - name: redis-cluster-node-announce-bus-port-<REDIS_PORT_NUMBER>
      port: 1<REDIS_PORT_NUMBER>
      targetPort: 1<REDIS_PORT_NUMBER>
      nodePort: 1<REDIS_PORT_NUMBER>

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-cluster-node-<REDIS_PORT_NUMBER>
  namespace: redis
spec:
  selector:
    matchLabels:
      app: redis-cluster-node-<REDIS_PORT_NUMBER>
  template:
    metadata:
      labels:
        app: redis-cluster-node-<REDIS_PORT_NUMBER>
    spec:
      nodeSelector:
        redis-cluster-app: node-<REDIS_PORT_NUMBER>
      hostNetwork: true
      containers:
      - name: redis-cluster-node-<REDIS_PORT_NUMBER>
        image: qiushaocloud/redis-cluster:latest:latest
        hostname: redis-cluster-node-<REDIS_PORT_NUMBER>
        ports:<USE_HOST_NETWORK_MODE>
        - containerPort: <REDIS_PORT_NUMBER><USE_HOST_NETWORK_MODE>
        - containerPort: 1<REDIS_PORT_NUMBER><USE_HOST_NETWORK_MODE>
        env:
        - name: REDIS_PASSWORD
          value: <REDIS_PASSWORD>
        - name: REDIS_CLUSTER_ANNOUNCE_IP
          value: <REDIS_CLUSTER_ANNOUNCE_IP>
        - name: REDIS_PORT_NUMBER
          value: <REDIS_PORT_NUMBER>
        volumeMounts:
        - name: redis-data-<REDIS_PORT_NUMBER>
          mountPath: /data
        - name: redis-env-<REDIS_PORT_NUMBER><USE_HOST_NETWORK_MODE>
          mountPath: /etc/profile.d/.env-<REDIS_PORT_NUMBER><USE_HOST_NETWORK_MODE>
      volumes:
      - name: redis-data-<REDIS_PORT_NUMBER>
        persistentVolumeClaim:
          claimName: redis-cluster-pvc-<REDIS_PORT_NUMBER>
      - name: redis-env-<REDIS_PORT_NUMBER><USE_HOST_NETWORK_MODE>
        hostPath:<USE_HOST_NETWORK_MODE>
          path: <ENV_FILE_HOST_PATH_DIR>/.env-<REDIS_PORT_NUMBER><USE_HOST_NETWORK_MODE>
          type: File<USE_HOST_NETWORK_MODE>
       
