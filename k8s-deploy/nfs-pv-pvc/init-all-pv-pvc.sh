#!/bin/bash

set -a
source ../.env
set +a

echo "rm -rf redis-cluster-node.pv-pvc.*.yaml"
rm -rf redis-cluster-node.pv-pvc.*.yaml

for port in `seq $MIN_REDIS_PORT_NUMBER $MAX_REDIS_PORT_NUMBER`; do
  REDIS_PORT_NUMBER=${port}
  cp -ra redis-cluster-node.pv-pvc.REDIS_PORT_NUMBER.yaml.tpl redis-cluster-node.pv-pvc.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PORT_NUMBER>#${REDIS_PORT_NUMBER}#g" redis-cluster-node.pv-pvc.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<K8S_PV_NFS_SERVER>#${K8S_PV_NFS_SERVER}#g" redis-cluster-node.pv-pvc.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<K8S_PV_NFS_PATH>#${K8S_PV_NFS_PATH}#g" redis-cluster-node.pv-pvc.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<K8S_PV_STORAGE_SIZE>#${K8S_PV_STORAGE_SIZE}#g" redis-cluster-node.pv-pvc.${REDIS_PORT_NUMBER}.yaml
done