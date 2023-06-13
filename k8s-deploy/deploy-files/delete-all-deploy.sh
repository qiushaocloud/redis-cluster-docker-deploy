#!/bin/bash

for port in `seq 6373 6378`; do
    REDIS_PORT_NUMBER=${port}
    kubectl delete -f redis-cluster-node.deploy.$REDIS_PORT_NUMBER.yaml
done

kubectl delete -f redis-cluster-create-job.yaml