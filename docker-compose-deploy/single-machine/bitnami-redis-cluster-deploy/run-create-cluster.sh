#!/bin/bash

echo "start run-create-cluster.sh"

echo "sleep 10s"
sleep 10

if [ $$REDIS_PASSWORD ]; then
    echo "redis-cli -a $REDIS_PASSWORD --cluster create $REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS  --cluster-yes"
    redis-cli -a $REDIS_PASSWORD --cluster create $REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS  --cluster-yes
else
    echo "redis-cli --cluster create $REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS  --cluster-yes"
    redis-cli --cluster create $REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS  --cluster-yes
fi

sleep 5
echo "finsh run-create-cluster.sh"