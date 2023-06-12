#!/bin/bash

set -a
source ../.env
set +a

REDIS_NODES=""

for port in `seq 6373 6378`; do
  REDIS_PORT_NUMBER=${port}
  echo "REDIS_PORT_NUMBER: $REDIS_PORT_NUMBER"

  if [ "$REDIS_NODES" == "" ]; then
    REDIS_NODES="redis-cluster-node-svc-$REDIS_PORT_NUMBER.redis:$REDIS_PORT_NUMBER"
  else
    REDIS_NODES="$REDIS_NODES redis-cluster-node-svc-$REDIS_PORT_NUMBER.redis:$REDIS_PORT_NUMBER"
  fi

  cp -ra redis-cluster-node.deploy.REDIS_PORT_NUMBER.yaml.tpl redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml

  K8S_SVC_TYPE_TMP=$K8S_SVC_TYPE

  if [ "$IS_USE_HOST_NETWORK" == "yes" ]; then
    # redis 节点使用 hostNetwork 模式
    echo "k8s redis cluster node use hostNetwork"

    if [ "$K8S_SVC_TYPE_TMP" != "ClusterIP" ]; then
      echo "hostNetwork force K8S_SVC_TYPE_TMP to ClusterIP"
      K8S_SVC_TYPE_TMP="ClusterIP"
    fi

    sed -i "/<NOT_USE_HOST_NETWORK_MODE>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<USE_HOST_NETWORK_MODE>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    echo "k8s redis cluster node not use hostNetwork"

    sed -i "/clusterIP: None/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "/<USE_HOST_NETWORK_MODE>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<NOT_USE_HOST_NETWORK_MODE>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ "$K8S_SVC_TYPE_TMP" != "NodePort" ]; then
    echo "del nodePort:"
    sed -i "/nodePort:/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ $ENV_FILE_HOST_PATH_DIR ]; then
    sed -i "s#<USE_ENV_FILE_HOST_PATH_DIR>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<ENV_FILE_HOST_PATH_DIR>#${ENV_FILE_HOST_PATH_DIR}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    sed -i "/<USE_ENV_FILE_HOST_PATH_DIR>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  sed -i "s#<K8S_SVC_TYPE>#${K8S_SVC_TYPE_TMP}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PORT_NUMBER>#${REDIS_PORT_NUMBER}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PASSWORD>#${REDIS_PASSWORD}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_CLUSTER_ANNOUNCE_IP>#${REDIS_CLUSTER_ANNOUNCE_IP}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
done


cp -ra redis-cluster-create-job.yaml.tpl redis-cluster-create-job.yaml
sed -i "s#<REDIS_PASSWORD>#${REDIS_PASSWORD}#g" redis-cluster-create-job.yaml
sed -i "s#<REDIS_CLUSTER_REPLICAS>#${REDIS_CLUSTER_REPLICAS}#g" redis-cluster-create-job.yaml
sed -i "s#<REDIS_NODES>#${REDIS_NODES}#g" redis-cluster-create-job.yaml
