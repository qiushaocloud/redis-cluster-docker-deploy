apiVersion: batch/v1
kind: Job
metadata:
  name: redis-cluster-create
spec:
  template:
    spec:
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/control-plane
      #nodeSelector:
      #  redis-cluster-create: "yes"
      containers:
      - name: redis-cluster-create
        image: qiushaocloud/redis-cluster:latest
        command: ["/bin/bash"]
        args: ["-c", "/run-create-cluster.sh"]
        env:
        - name: REDIS_PASSWORD
          value: <REDIS_PASSWORD>
        - name: REDIS_CLUSTER_REPLICAS
          value: "<REDIS_CLUSTER_REPLICAS>"
        - name: REDIS_NODES
          value: <REDIS_NODES>
      restartPolicy: Never
  backoffLimit: 0
