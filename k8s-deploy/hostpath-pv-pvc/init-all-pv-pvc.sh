#!/bin/bash

set -a
source ../.env
set +a

for port in `seq 6373 6378`; do
  REDIS_PORT=${port}
  cp -ra redis-cluster-node.pv-pvc.REDIS_PORT.yaml.tpl redis-cluster-node.pv-pvc.${REDIS_PORT}.yaml
  sed -i s/\<REDIS_PORT\>/${REDIS_PORT}/g redis-cluster-node.pv-pvc.${REDIS_PORT}.yaml
  sed -i s/\<LOCAL_STORAGE_PATH\>/${LOCAL_STORAGE_PATH}/g redis-cluster-node.pv-pvc.${REDIS_PORT}.yaml
  sed -i s/\<K8S_PV_STORAGE_SIZE\>/${K8S_PV_STORAGE_SIZE}/g redis-cluster-node.pv-pvc.${REDIS_PORT}.yaml
done