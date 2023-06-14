#!/bin/bash

echo "start run-redis-server.sh"

if [ -f '/.env' ]; then
    echo "exist /.env file, load env, file content:"
    echo `cat /.env`

    set -a
    source /.env
    set +a
fi

if [[ -n "$DOMAIN_TO_IPS" ]]; then
  # 将域名映射列表按逗号分隔拆分为数组
  IFS=',' read -ra MAPPINGS <<< "$DOMAIN_TO_IPS"

  for mapping in "${MAPPINGS[@]}"; do
    # 将每个映射按井号分隔为域名和IP地址
    IFS='#' read -ra PARTS <<< "$mapping"
    domain="${PARTS[0]}"
    ip="${PARTS[1]}"

    # 检查是否已存在相同的映射
    if grep -q -w "$domain" /etc/hosts; then
      echo "Skipping duplicate mapping: $domain"
    else
      echo "add item($ip    $domain) to /etc/hosts"
      # 追加映射到/etc/hosts文件
      echo "$ip    $domain" >> /etc/hosts
    fi
  done
fi

REDIS_PORT_NUMBER_TMP=${REDIS_PORT_NUMBER:-6379}
CLUSTER_ANNOUNCE_PORT_TMP=${CLUSTER_ANNOUNCE_PORT:-$REDIS_PORT_NUMBER_TMP}
CLUSTER_ANNOUNCE_BUS_PORT_TMP=${CLUSTER_ANNOUNCE_BUS_PORT:-1$REDIS_PORT_NUMBER_TMP}
REDIS_PASSWORD_TMP=${REDIS_PASSWORD:-}
REDISCLI_AUTH_TMP=${REDISCLI_AUTH:-$REDIS_PASSWORD_TMP}
PROTECTED_MODE_TMP=${PROTECTED_MODE:-no}
DAEMONIZE_TMP=${DAEMONIZE:-no}
APPENDONLY_TMP=${APPENDONLY:-yes}
CLUSTER_ENABLED_TMP=${CLUSTER_ENABLED:-yes}
CLUSTER_CONFIG_FILE_TMP=${CLUSTER_CONFIG_FILE:-nodes.conf}
CLUSTER_NODE_TIMEOUT_TMP=${CLUSTER_NODE_TIMEOUT:-5000}

redisArgs="--port $REDIS_PORT_NUMBER_TMP \
    --cluster-announce-bus-port $CLUSTER_ANNOUNCE_BUS_PORT_TMP \
    --protected-mode $PROTECTED_MODE_TMP \
    --daemonize $DAEMONIZE_TMP \
    --appendonly $APPENDONLY_TMP \
    --cluster-enabled $CLUSTER_ENABLED_TMP \
    --cluster-config-file $CLUSTER_CONFIG_FILE_TMP \
    --cluster-node-timeout $CLUSTER_NODE_TIMEOUT_TMP"

if [ $REDIS_PASSWORD_TMP ]; then
	redisArgs="$redisArgs --requirepass $REDIS_PASSWORD_TMP"
fi

if [ $REDISCLI_AUTH_TMP ]; then
	redisArgs="$redisArgs --masterauth $REDISCLI_AUTH_TMP"
fi

if [ $REDIS_CLUSTER_ANNOUNCE_IP ]; then
	redisArgs="$redisArgs --cluster-announce-port $CLUSTER_ANNOUNCE_PORT_TMP \
    --cluster-announce-ip $REDIS_CLUSTER_ANNOUNCE_IP"
fi

echo "redis-server $redisArgs"

redis-server $redisArgs

if [ $REDIS_NODES ] && [ "$AUTO_RUN_CREATE_CLUSTER" == "yes" ]; then
	echo "auto run create cluster sh file"
    bash /run-create-cluster.sh
fi

echo "finsh run-redis-server.sh"
