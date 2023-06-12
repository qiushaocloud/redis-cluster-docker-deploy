#!/bin/bash

NODE_HOSTNAME=$1
REDIS_PORT_NUMBER=$1

if [ -f $NODE_HOSTNAME ]; then
    echo "empty NODE_HOSTNAME"
    exit 1
fi

if [ -f $REDIS_PORT_NUMBER ]; then
    echo "empty REDIS_PORT_NUMBER"
    exit 1
fi

kubectl label node $NODE_HOSTNAME redis-cluster-node-$REDIS_PORT_NUMBER=yes
