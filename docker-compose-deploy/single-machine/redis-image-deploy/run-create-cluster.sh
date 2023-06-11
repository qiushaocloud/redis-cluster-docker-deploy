#!/bin/bash

echo "start run-create-cluster.sh"

echo "sleep 20s"
sleep 20

echo "redis-cli -a $REDIS_PASSWORD --cluster create $REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS  --cluster-yes"
redis-cli -a $REDIS_PASSWORD --cluster create $REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS  --cluster-yes

sleep 5
echo "finsh run-create-cluster.sh"