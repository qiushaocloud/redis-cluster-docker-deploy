#!/bin/bash

set -a
source ../.env
set +a

for port in `seq 6373 6378`; do
  REDIS_PORT_NUMBER=${port}
  cp -ra redis-cluster-node.deploy.REDIS_PORT_NUMBER.yaml.tpl redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml

  if [ "$K8S_SVC_CLUSTERIP_IS_NODE" != "yes" ]; then
    echo "del clusterIP: None"
    sed -i "/clusterIP: None/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ "$K8S_SVC_TYPE" == "ClusterIP" ] && [ "$K8S_SVC_CLUSTERIP_IS_NODE" == "yes" ]; then
    # redis 节点使用 hostNetwork 模式【hostNetwork 模式即：K8S_SVC_TYPE == ClusterIP && K8S_SVC_CLUSTERIP_IS_NODE == yes】
    echo "k8s redis cluster node use hostNetwork"
    sed -i "/[USE_HOST_NETWORK_MODE]/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    echo "k8s redis cluster node not use hostNetwork"
    sed -i "/hostNetwork: true/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#[USE_HOST_NETWORK_MODE]##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  sed -i "s#<K8S_SVC_TYPE>#${K8S_SVC_TYPE}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PORT_NUMBER>#${REDIS_PORT_NUMBER}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PASSWORD>#${REDIS_PASSWORD}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_CLUSTER_ANNOUNCE_IP>#${REDIS_CLUSTER_ANNOUNCE_IP}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<ENV_FILE_HOST_PATH_DIR>#${ENV_FILE_HOST_PATH_DIR}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
done