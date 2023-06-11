#!/bin/bash

echo "start run-redis-server.sh"

CLUSTER_ANNOUNCE_PORT_TMP=$REDIS_PORT_NUMBER
CLUSTER_ANNOUNCE_BUS_PORT_TMP=1$REDIS_PORT_NUMBER
REDISCLI_AUTH_TMP=$REDIS_PASSWORD
if [ $CLUSTER_ANNOUNCE_PORT ]; then
    CLUSTER_ANNOUNCE_PORT_TMP=$CLUSTER_ANNOUNCE_PORT
fi
if [ $CLUSTER_ANNOUNCE_BUS_PORT ]; then
    CLUSTER_ANNOUNCE_BUS_PORT_TMP=$CLUSTER_ANNOUNCE_BUS_PORT
fi
if [ $REDISCLI_AUTH ]; then
    REDISCLI_AUTH_TMP=$REDISCLI_AUTH
fi

echo "redis-server \
    --port $REDIS_PORT_NUMBER \
    --cluster-announce-port $CLUSTER_ANNOUNCE_PORT_TMP \
    --cluster-announce-bus-port $CLUSTER_ANNOUNCE_BUS_PORT_TMP \
    --cluster-announce-ip $REDIS_CLUSTER_ANNOUNCE_IP \
    --requirepass $REDIS_PASSWORD \
    --masterauth $REDISCLI_AUTH \
    --protected-mode no \
    --daemonize no \
    --appendonly yes \
    --cluster-enabled yes \
    --cluster-config-file nodes.conf \
    --cluster-node-timeout 5000"

redis-server \
    --port $REDIS_PORT_NUMBER \
    --cluster-announce-port $CLUSTER_ANNOUNCE_PORT_TMP \
    --cluster-announce-bus-port $CLUSTER_ANNOUNCE_BUS_PORT_TMP \
    --cluster-announce-ip $REDIS_CLUSTER_ANNOUNCE_IP \
    --requirepass $REDIS_PASSWORD \
    --masterauth $REDIS_PASSWORD \
    --protected-mode no \
    --daemonize no \
    --appendonly yes \
    --cluster-enabled yes \
    --cluster-config-file nodes.conf \
    --cluster-node-timeout 5000

echo "finsh run-redis-server.sh"
