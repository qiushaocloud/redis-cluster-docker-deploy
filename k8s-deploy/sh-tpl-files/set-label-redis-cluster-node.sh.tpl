#!/bin/bash

NODE_HOSTNAME=$1
<NODE_SELECTOR_KEY_SUFFIX>=$2

if [ -f $NODE_HOSTNAME ]; then
    echo "empty NODE_HOSTNAME"
    exit 1
fi

# REDIS_PORT_NUMBER/GROUP_INDEX
if [ -f $<NODE_SELECTOR_KEY_SUFFIX> ]; then
    echo "empty <NODE_SELECTOR_KEY_SUFFIX>"
    exit 1
fi

kubectl label node $NODE_HOSTNAME <NODE_SELECTOR_KEY_PREFIX>$<NODE_SELECTOR_KEY_SUFFIX>="yes"
