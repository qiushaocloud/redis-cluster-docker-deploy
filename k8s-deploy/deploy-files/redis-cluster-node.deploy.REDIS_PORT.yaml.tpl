apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-node-svc-6373
spec:
  # clusterIP: None
  selector:
    app: redis-cluster-node-6373
  ports:
    - name: redis-cluster-node-port-6373
      port: 6373
      targetPort: 6373

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-cluster-node-6373
  namespace: redis
spec:
  selector:
    matchLabels:
      app: redis-cluster-node-6373
  template:
    metadata:
      labels:
        app: redis-cluster-node-6373
    spec:
      containers:
      - name: redis-cluster-node-6373
        image: docker.io/bitnami/redis-cluster:latest
        command: ["redis-server"]
        args: ["--port", "6373"]
        envFrom:
        - configMapRef:
            name: redis-cluster-config
        volumeMounts:
        - name: data
          mountPath: /bitnami/redis/data
      volumes:
      - name: data
        emptyDir: {}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-cluster-node-6374
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-cluster-node-6374
  template:
    metadata:
      labels:
        app: redis-cluster-node-6374
    spec:
      containers:
      - name: redis-cluster-node-6374
        image: docker.io/bitnami/redis-cluster:latest
        command: ["redis-server"]
        args: ["--port", "6374"]
        envFrom:
        - configMapRef:
            name: redis-cluster-config
        volumeMounts:
        - name: data
          mountPath: /bitnami/redis/data
      volumes:
      - name: data
        emptyDir: {}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-cluster-node-6375
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-cluster-node-6375
  template:
    metadata:
      labels:
        app: redis-cluster-node-6375
    spec:
      containers:
      - name: redis-cluster-node-6375
        image: docker.io/bitnami/redis-cluster:latest
        command: ["redis-server"]
        args: ["--port", "6375"]
        envFrom:
        - configMapRef:
            name: redis-cluster-config
        volumeMounts:
        - name: data
          mountPath: /bitnami/redis/data
      volumes:
      - name: data
        emptyDir: {}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-cluster-node-6376
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-cluster-node-6376
  template:
    metadata:
      labels:
        app: redis-cluster-node-6376
    spec:
      containers:
      - name: redis-cluster-node-6376
        image: docker.io/bitnami/redis-cluster:latest
        command: ["redis-server"]
        args: ["--port", "6376"]
        envFrom:
        - configMapRef:
            name: redis-cluster-config
       
