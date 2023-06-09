#!/bin/bash
set -e

echo "start run-create-cluster.sh"

if [ -f '/.env' ]; then
    echo "exist /.env file, load env, file content:"
    echo `cat /.env`

    set -a
    source /.env
    set +a
fi

echo "REDIS_NODES: $REDIS_NODES"
if [ -z "$REDIS_NODES" ]; then
	echo "empty REDIS_NODES"
	exit 1
fi

if [[ -n "$DOMAIN_TO_IPS" ]]; then
  # 将域名映射列表按逗号分隔拆分为数组
  IFS=',' read -ra MAPPINGS <<< "$DOMAIN_TO_IPS"

  for mapping in "${MAPPINGS[@]}"; do
    # 将每个映射按井号分隔为域名和IP地址
    IFS='@' read -ra PARTS <<< "$mapping"
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

echo "sleep 10s"
sleep 10

REDIS_CLUSTER_REPLICAS_TMP=${REDIS_CLUSTER_REPLICAS:-0}
NEW_REDIS_NODES=$REDIS_NODES

if [ "$ALLOW_USE_DOMAIN" == "true" ] || [ "$ALLOW_USE_DOMAIN" == "yes" ]; then
    echo "REDIS_NODES allow use domain"
else
    echo "REDIS_NODES not allow use domain"
    # 定义要转换的域名和端口, 例如: input="domain1:6373 domain2:6374 192.168.0.1:6375 192.168.0.2:6376 www.domain.com:6377"
    input=$REDIS_NODES
    # 将域名和端口转换为IP地址和端口
    output=""
    for item in $input; do
        address="${item%:*}"
        port="${item#*:}"
        if [[ $address =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            # 输入是IP地址，不进行转换
            output="$output $address:$port"
        else
            # 输入是域名，进行转换
            ip=$(ping -c 1 -n $address | awk -F'[()]' '/PING/{print $2}')
            if [[ -n $ip ]]; then
                output="$output $ip:$port"
            else
                echo "无法解析域名: $address"
            fi
        fi
    done
    NEW_REDIS_NODES=$output
fi

echo "NEW_REDIS_NODES: $NEW_REDIS_NODES"

if [ $REDIS_PASSWORD ]; then
	echo "redis-cli -a $REDIS_PASSWORD --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes"
	redis-cli -a $REDIS_PASSWORD --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes
else
	echo "redis-cli --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes"
	redis-cli --cluster create $NEW_REDIS_NODES --cluster-replicas $REDIS_CLUSTER_REPLICAS_TMP  --cluster-yes
fi

echo "sleep 5s"
sleep 5
echo "finsh run-create-cluster.sh"