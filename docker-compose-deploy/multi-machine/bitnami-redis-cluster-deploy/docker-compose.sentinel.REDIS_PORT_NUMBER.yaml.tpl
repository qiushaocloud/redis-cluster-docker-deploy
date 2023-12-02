version: '3'
services:
  redis-sentinel-2<REDIS_PORT_NUMBER>:
    image: qiushaocloud/bitnami-extra-redis-sentinel:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network-2<REDIS_PORT_NUMBER>
    hostname: redis-sentinel-2<REDIS_PORT_NUMBER>
    container_name: redis-sentinel-2<REDIS_PORT_NUMBER>
    environment:
      - REDIS_MASTER_HOST=redis-cluster-node-<REDIS_PORT_NUMBER>
      - REDIS_MASTER_PORT_NUMBER=<REDIS_PORT_NUMBER>
      - REDIS_MASTER_SET=mymaster
      - REDIS_MASTER_PASSWORD=$REDIS_PASSWORD
      - REDIS_SENTINEL_PASSWORD=$REDIS_PASSWORD
      - REDIS_SENTINEL_QUORUM=2
      - REDIS_SENTINEL_PORT_NUMBER=2<REDIS_PORT_NUMBER>  # 设置 Sentinel 端口
      - DOMAIN_TO_IPS=$DOMAIN_TO_IPS
    ports:
      - '2<REDIS_PORT_NUMBER>:2<REDIS_PORT_NUMBER>'

networks:
  redis-cluster-network-2<REDIS_PORT_NUMBER>:

