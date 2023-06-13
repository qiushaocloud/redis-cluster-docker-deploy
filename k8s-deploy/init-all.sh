#!/bin/bash

set -a
source .env
set +a

echo "start init-all sh"
CURR_DIR=`pwd`

if [ $K8S_PV_NFS_SERVER ] && [ $K8S_PV_NFS_PATH ]; then
    echo 'run nfs-pv-pvc init-all-pv-pvc.sh'
    cd $CURR_DIR/nfs-pv-pvc
    bash init-all-pv-pvc.sh
else
    echo 'run hostpath-pv-pvc init-all-pv-pvc.sh'
    cd $CURR_DIR/hostpath-pv-pvc
    bash init-all-pv-pvc.sh
fi

echo 'run deploy-files init-all-deploy.sh'
cd $CURR_DIR/deploy-files
bash init-all-deploy.sh

cd $CURR_DIR
cp -ra sh-tpl-files/set-label-redis-cluster-node.sh.tpl set-label-redis-cluster-node.sh
cp -ra sh-tpl-files/del-label-redis-cluster-node.sh.tpl del-label-redis-cluster-node.sh
if [ "$K8S_NODE_SELECTOR_POLICY" == "REDIS_PORT" ]; then
    # 使用 redis 端口作为选择器
    node_selector_key_prefix="rdc-port-"
    node_selector_key_suffix="REDIS_PORT_NUMBER"
    echo "node_selector_key_prefix: $node_selector_key_prefix, node_selector_key_suffix: $node_selector_key_suffix"
    sed -i "s#<NODE_SELECTOR_KEY_PREFIX>#${node_selector_key_prefix}#g" set-label-redis-cluster-node.sh
    sed -i "s#<NODE_SELECTOR_KEY_PREFIX>#${node_selector_key_prefix}#g" del-label-redis-cluster-node.sh
    sed -i "s#<NODE_SELECTOR_KEY_SUFFIX>#${node_selector_key_suffix}#g" set-label-redis-cluster-node.sh
    sed -i "s#<NODE_SELECTOR_KEY_SUFFIX>#${node_selector_key_suffix}#g" del-label-redis-cluster-node.sh
elif [[ "$K8S_NODE_SELECTOR_POLICY" == "REDIS_GROUP@"* ]]; then
    # 使用组的方式作为选择器
    node_selector_key_prefix="rdc-group-"
    node_selector_key_suffix="GROUP_INDEX"
    echo "node_selector_key_prefix: $node_selector_key_prefix, node_selector_key_suffix: $node_selector_key_suffix"
    sed -i "s#<NODE_SELECTOR_KEY_PREFIX>#${node_selector_key_prefix}#g" set-label-redis-cluster-node.sh
    sed -i "s#<NODE_SELECTOR_KEY_PREFIX>#${node_selector_key_prefix}#g" del-label-redis-cluster-node.sh
    sed -i "s#<NODE_SELECTOR_KEY_SUFFIX>#${node_selector_key_suffix}#g" set-label-redis-cluster-node.sh
    sed -i "s#<NODE_SELECTOR_KEY_SUFFIX>#${node_selector_key_suffix}#g" del-label-redis-cluster-node.sh
else
    # 空值/NONE/无效的节点选择策略，不需要节点选择器
    echo "Empty value/NONE/Invalid node selector policy. No node selector is needed"
    rm -rf set-label-redis-cluster-node.sh
    rm -rf del-label-redis-cluster-node.sh
fi

echo "finsh init-all sh"