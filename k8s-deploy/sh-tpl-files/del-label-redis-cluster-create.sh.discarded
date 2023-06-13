#!/bin/bash

NODE_HOSTNAME=$1
if [ -f $NODE_HOSTNAME ]; then
    echo "empty NODE_HOSTNAME"
    exit 1
fi

kubectl label node $NODE_HOSTNAME redis-cluster-create-
