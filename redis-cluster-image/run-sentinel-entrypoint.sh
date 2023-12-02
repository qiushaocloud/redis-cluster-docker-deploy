#!/bin/bash

echo "start run-sentinel-entrypoint.sh"

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

/opt/bitnami/scripts/redis-sentinel/entrypoint.sh $@

echo "finsh run-sentinel-entrypoint.sh"