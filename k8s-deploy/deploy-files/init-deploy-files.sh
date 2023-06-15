#!/bin/bash

set -a
source ../.env
set +a

echo "rm -rf redis-cluster-node.deploy.*.yaml"
rm -rf redis-cluster-node.deploy.*.yaml

echo "rm -rf redis-cluster-node.svc.*.yaml"
rm -rf redis-cluster-node.svc.*.yaml

REDIS_NODES=""

for port in `seq $MIN_REDIS_PORT_NUMBER $MAX_REDIS_PORT_NUMBER`; do
  REDIS_PORT_NUMBER=${port}
  echo "REDIS_PORT_NUMBER: $REDIS_PORT_NUMBER"

  if [ "$REDIS_NODES" == "" ]; then
    REDIS_NODES="redis-cluster-node-svc-$REDIS_PORT_NUMBER.redis:$REDIS_PORT_NUMBER"
  else
    REDIS_NODES="$REDIS_NODES redis-cluster-node-svc-$REDIS_PORT_NUMBER.redis:$REDIS_PORT_NUMBER"
  fi

  cp -ra redis-cluster-node.deploy.REDIS_PORT_NUMBER.yaml.tpl redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  cp -ra redis-cluster-node.svc.REDIS_PORT_NUMBER.yaml.tpl redis-cluster-node.svc.${REDIS_PORT_NUMBER}.yaml

  K8S_SVC_TYPE_TMP=$K8S_SVC_TYPE

  if [ "$IS_USE_HOST_NETWORK" == "yes" ]; then
    # redis 节点使用 hostNetwork 模式
    echo "k8s redis cluster node use hostNetwork"

    if [ "$K8S_SVC_TYPE_TMP" == "NodePort" ]; then
      echo "hostNetwork force K8S_SVC_TYPE_TMP to ClusterIP"
      K8S_SVC_TYPE_TMP="ClusterIP"
    fi

    sed -i "/<NOT_USE_HOST_NETWORK_MODE>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<USE_HOST_NETWORK_MODE>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    echo "k8s redis cluster node not use hostNetwork"

    sed -i "/clusterIP: None/d" redis-cluster-node.svc.${REDIS_PORT_NUMBER}.yaml
    
    sed -i "/<USE_HOST_NETWORK_MODE>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<NOT_USE_HOST_NETWORK_MODE>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ "$K8S_SVC_TYPE_TMP" != "NodePort" ]; then
    echo "del nodePort:"
    sed -i "/nodePort:/d" redis-cluster-node.svc.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ $ENV_FILE_HOST_PATH_DIR ]; then
    sed -i "s#<USE_ENV_FILE_HOST_PATH_DIR>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<ENV_FILE_HOST_PATH_DIR>#${ENV_FILE_HOST_PATH_DIR}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    sed -i "/<USE_ENV_FILE_HOST_PATH_DIR>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ "$K8S_NODE_SELECTOR_POLICY" == "REDIS_PORT" ]; then
    # 使用 redis 端口作为选择器
    node_selector_key="rdc-port-$REDIS_PORT_NUMBER"
    echo "node_selector_key: $node_selector_key"
    sed -i "s#<USE_NODE_SELECTOR>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<NODE_SELECTOR_KEY>#${node_selector_key}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  elif [[ "$K8S_NODE_SELECTOR_POLICY" == "REDIS_GROUP@"* ]]; then
    # 使用组的方式作为选择器
    group_num=$(echo "$K8S_NODE_SELECTOR_POLICY" | awk -F'@' '{print $2}')
    echo "group_num: $group_num"
    group_index=$((REDIS_PORT_NUMBER % group_num + 1))
    node_selector_key="rdc-group-$group_index"
    echo "node_selector_key: $node_selector_key"
    sed -i "s#<USE_NODE_SELECTOR>##g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
    sed -i "s#<NODE_SELECTOR_KEY>#${node_selector_key}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    # 空值/NONE/无效的节点选择策略，不需要节点选择器
    echo "Empty value/NONE/Invalid node selector policy. No node selector is needed"
    sed -i "/<USE_NODE_SELECTOR>/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi

  if [ "$DOMAIN_TO_IPS" ]; then
    echo "DOMAIN_TO_IPS is not empty, DOMAIN_TO_IPS: $DOMAIN_TO_IPS"
    sed -i "s#<DOMAIN_TO_IPS>#${DOMAIN_TO_IPS}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  else
    echo "DOMAIN_TO_IPS is empty"
    sed -i "/DOMAIN_TO_IPS/d" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  fi


  sed -i "s#<K8S_SVC_TYPE>#${K8S_SVC_TYPE_TMP}#g" redis-cluster-node.svc.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PORT_NUMBER>#${REDIS_PORT_NUMBER}#g" redis-cluster-node.svc.${REDIS_PORT_NUMBER}.yaml

  sed -i "s#<REDIS_PORT_NUMBER>#${REDIS_PORT_NUMBER}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_PASSWORD>#${REDIS_PASSWORD}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
  sed -i "s#<REDIS_CLUSTER_ANNOUNCE_IP>#${REDIS_CLUSTER_ANNOUNCE_IP}#g" redis-cluster-node.deploy.${REDIS_PORT_NUMBER}.yaml
done


cp -ra redis-cluster-create-job.yaml.tpl redis-cluster-create-job.yaml
sed -i "s#<REDIS_PASSWORD>#${REDIS_PASSWORD}#g" redis-cluster-create-job.yaml
sed -i "s#<REDIS_CLUSTER_REPLICAS>#${REDIS_CLUSTER_REPLICAS}#g" redis-cluster-create-job.yaml
sed -i "s#<REDIS_NODES>#${REDIS_NODES}#g" redis-cluster-create-job.yaml
if [ "$DOMAIN_TO_IPS" ]; then
  echo "DOMAIN_TO_IPS is not empty, change redis-cluster-create-job.yaml, DOMAIN_TO_IPS: $DOMAIN_TO_IPS"
  sed -i "s#<DOMAIN_TO_IPS>#${DOMAIN_TO_IPS}#g" redis-cluster-create-job.yaml
else
  echo "DOMAIN_TO_IPS is empty, change redis-cluster-create-job.yaml"
  sed -i "/DOMAIN_TO_IPS/d" redis-cluster-create-job.yaml
fi
