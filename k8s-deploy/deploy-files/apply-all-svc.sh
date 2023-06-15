#!/bin/bash

set -a
source ../.env
set +a

kubectl create ns redis

for port in `seq $MIN_REDIS_PORT_NUMBER $MAX_REDIS_PORT_NUMBER`; do
    REDIS_PORT_NUMBER=${port}
    kubectl apply -f redis-cluster-node.svc.$REDIS_PORT_NUMBER.yaml
done