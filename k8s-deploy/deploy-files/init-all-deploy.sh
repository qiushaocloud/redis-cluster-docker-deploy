#!/bin/bash

set -a
source ../.env
set +a

for port in `seq 6373 6378`; do
  REDIS_PORT_NUMBER=${port}
  cp -ra redis-cluster-node.deploy.REDIS_PORT_NUMBER.yaml.tpl redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i s/\<REDIS_PORT_NUMBER\>/${REDIS_PORT_NUMBER}/g redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i s/\<REDIS_PASSWORD\>/${REDIS_PASSWORD}/g redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i s/\<REDIS_CLUSTER_ANNOUNCE_IP\>/${REDIS_CLUSTER_ANNOUNCE_IP}/g redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
done