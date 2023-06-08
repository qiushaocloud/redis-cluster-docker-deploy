#!/bin/bash

set -a
source .env
set +a

for port in `seq 6373 6378`; do
  REDIS_PORT=${port}
  mkdir -p redis_confs
  cp -ra redis-cluster-conf.tmpl redis_confs/redis_${REDIS_PORT}.conf
  sed -i s/\<REDIS_PASSWORD\>/${REDIS_PASSWORD}/g redis_confs/redis_${REDIS_PORT}.conf
  sed -i s/\<REDIS_CLUSTER_ANNOUNCE_IP\>/${REDIS_CLUSTER_ANNOUNCE_IP}/g redis_confs/redis_${REDIS_PORT}.conf
  sed -i s/\<REDIS_PORT\>/${REDIS_PORT}/g redis_confs/redis_${REDIS_PORT}.conf
done