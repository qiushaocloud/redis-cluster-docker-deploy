#!/bin/bash

set -a
source ../.env
set +a

for port in `seq $MIN_REDIS_PORT_NUMBER $MAX_REDIS_PORT_NUMBER`; do
    REDIS_PORT_NUMBER=${port}
    kubectl delete -f redis-cluster-node.deploy.$REDIS_PORT_NUMBER.yaml
done

# kubectl delete -f redis-cluster-create-job.yaml