#!/bin/bash

set -a
source ../.env
set +a

K8S_SVC_TYPE_TMP=$K8S_SVC_TYPE
if [ "$IS_USE_HOST_NETWORK" == "yes" ] && [ "$K8S_SVC_TYPE_TMP" == "NodePort" ]; then
    echo "hostNetwork force K8S_SVC_TYPE_TMP to ClusterIP"
    K8S_SVC_TYPE_TMP="ClusterIP"
fi

svc_ports_str=""
for port in `seq $MIN_REDIS_PORT_NUMBER $MAX_REDIS_PORT_NUMBER`; do
    REDIS_PORT_NUMBER=${port}
    svc_ports_str="$svc_ports_str
    - name: redis-cluster-node-port-$REDIS_PORT_NUMBER
      port: $REDIS_PORT_NUMBER
      targetPort: $REDIS_PORT_NUMBER
      nodePort: $REDIS_PORT_NUMBER
    - name: redis-cluster-node-announce-bus-port-$REDIS_PORT_NUMBER
      port: 1$REDIS_PORT_NUMBER
      targetPort: 1$REDIS_PORT_NUMBER
      nodePort: 1$REDIS_PORT_NUMBER
    "
done

echo "start write redis-cluster-svc.yaml"
cat <<EOF | tee redis-cluster-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-svc
  namespace: redis
spec:
  type: $K8S_SVC_TYPE_TMP
  clusterIP: None
  selector:
    svc-headless: redis-cluster-headless
    pod-svc-name: redis-cluster-svc
  ports:
    $svc_ports_str
EOF
echo "finsh write redis-cluster-svc.yaml"

if [ "$K8S_SVC_TYPE_TMP" != "NodePort" ]; then
    echo "del nodePort:"
    sed -i "/nodePort:/d" redis-cluster-svc.yaml
fi

if [ "$IS_USE_HOST_NETWORK" != "yes" ]; then
    echo "del clusterIP: None"
    sed -i "/clusterIP: None/d" redis-cluster-svc.yaml
fi