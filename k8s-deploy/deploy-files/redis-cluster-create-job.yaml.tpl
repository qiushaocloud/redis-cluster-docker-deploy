apiVersion: v1
kind: ConfigMap
metadata:
  name: run-create-cluster-script
  namespace: redis
data:
  run-create-cluster.sh: |
    #!/bin/bash
    set -e

    echo "start run-create-cluster.sh"


    echo "REDIS_NODES: $REDIS_NODES"
    if [ -z "$REDIS_NODES" ]; then
      echo "empty REDIS_NODES"
      exit 1
    fi

    echo "sleep 10s"
    sleep 10

    REDIS_CLUSTER_REPLICAS_TMP=${REDIS_CLUSTER_REPLICAS:-0}
    NEW_REDIS_NODES=$REDIS_NODES

    if [ "$ALLOW_USE_DOMAIN" == "true" ] || [ "$ALLOW_USE_DOMAIN" == "yes" ]; then
        echo "REDIS_NODES allow use domain"
    else
        echo "REDIS_NODES not allow use domain"
        # 定义要转换的域名和端口, 例如: input="domain1:6373 domain2:6374 192.168.0.1:6375 192.168.0.2:6376 www.domain.com:6377"
        input=$REDIS_NODES
        # 将域名和端口转换为IP地址和端口
        output=""
        for item in $input; do
            address="${item%:*}"
            port="${item#*:}"
            if [[ $address =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                # 输入是IP地址，不进行转换
                output="$output $address:$port"
            else
                # 输入是域名，进行转换
                ip=$(ping -c 1 -n $address | awk -F'[()]' '/PING/{print $2}')
                if [[ -n $ip ]]; then
                    output="$output $ip:$port"
                else
                    echo "无法解析域名: $address"
                fi
            fi
        done
        NEW_REDIS_NODES=$output
    fi

    echo "NEW_REDIS_NODES: $NEW_REDIS_NODES"

    if [ $REDIS_PASSWORD ]; then
      echo "redis-cli -a $REDIS_PASSWORD --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes"
      redis-cli -a $REDIS_PASSWORD --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes
    else
      echo "redis-cli --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes"
      redis-cli --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes
    fi

    echo "sleep 5s"
    sleep 5
    echo "finsh run-create-cluster.sh"

---
apiVersion: batch/v1
kind: Job
metadata:
  name: redis-cluster-create
  namespace: redis
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
        image: docker.io/bitnami/redis-cluster:latest #qiushaocloud/redis-cluster:latest
        imagePullPolicy: Always
        command: ["/bin/bash"]
        args: ["-c", "/run-create-cluster.sh"]
        env:
        - name: REDIS_PASSWORD
          value: <REDIS_PASSWORD>
        - name: REDIS_CLUSTER_REPLICAS
          value: "<REDIS_CLUSTER_REPLICAS>"
        - name: REDIS_NODES
          value: <REDIS_NODES>
        - name: ALLOW_USE_DOMAIN
          value: "yes"
        volumeMounts:
        - name: run-create-cluster-sh-file
          mountPath: /run-create-cluster.sh
      volumes:
      - name: run-create-cluster-sh-file
        configMap:
          name: run-create-cluster-script
      restartPolicy: Never
  backoffLimit: 0
