apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-cluster-node-<REDIS_PORT_NUMBER>
  namespace: redis
  labels:
    app: redis-cluster-node-<REDIS_PORT_NUMBER>
spec:
  serviceName: redis-cluster-node-<REDIS_PORT_NUMBER>
  selector:
    matchLabels:
      app: redis-cluster-node-<REDIS_PORT_NUMBER>
  template:
    metadata:
      labels:
        app: redis-cluster-node-<REDIS_PORT_NUMBER>
        pod-svc-name: redis-cluster-svc
        svc-headless: redis-cluster-headless
    spec:
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/control-plane
      nodeSelector:<USE_NODE_SELECTOR>
        <NODE_SELECTOR_KEY>: "yes"<USE_NODE_SELECTOR>
      hostNetwork: true<USE_HOST_NETWORK_MODE>
      containers:
      - name: redis-cluster-node-<REDIS_PORT_NUMBER>
        image: qiushaocloud/redis-cluster:latest
        imagePullPolicy: Always
        ports:<NOT_USE_HOST_NETWORK_MODE>
        - containerPort: <REDIS_PORT_NUMBER><NOT_USE_HOST_NETWORK_MODE>
        - containerPort: 1<REDIS_PORT_NUMBER><NOT_USE_HOST_NETWORK_MODE>
        env:
        - name: REDIS_PASSWORD
          value: <REDIS_PASSWORD>
        - name: REDIS_CLUSTER_ANNOUNCE_IP
          value: <REDIS_CLUSTER_ANNOUNCE_IP>
        - name: REDIS_PORT_NUMBER
          value: "<REDIS_PORT_NUMBER>"
        - name: DOMAIN_TO_IPS
          value: "<DOMAIN_TO_IPS>"
        volumeMounts:
        - name: redis-data-<REDIS_PORT_NUMBER>
          mountPath: /data
        - name: redis-hostpath-env-<REDIS_PORT_NUMBER><USE_ENV_FILE_HOST_PATH_DIR>
          mountPath: /.env<USE_ENV_FILE_HOST_PATH_DIR>
          readOnly: true<USE_ENV_FILE_HOST_PATH_DIR>
      volumes:
      - name: redis-data-<REDIS_PORT_NUMBER>
        persistentVolumeClaim:
          claimName: redis-cluster-pvc-<REDIS_PORT_NUMBER>
      - name: redis-hostpath-env-<REDIS_PORT_NUMBER><USE_ENV_FILE_HOST_PATH_DIR>
        hostPath:<USE_ENV_FILE_HOST_PATH_DIR>
          path: <ENV_FILE_HOST_PATH_DIR>/hostpath-env-<REDIS_PORT_NUMBER><USE_ENV_FILE_HOST_PATH_DIR>
          type: File<USE_ENV_FILE_HOST_PATH_DIR>
       
