version: '3.3'

services:
  redis-cluster-node-<REDIS_PORT_NUMBER>:
    user: root
    image: docker.io/bitnami/redis-cluster:latest
    restart: always
    hostname: redis-cluster-node-<REDIS_PORT_NUMBER>
    container_name: redis-cluster-node-<REDIS_PORT_NUMBER>
    networks:
      - redis-cluster-network-<REDIS_PORT_NUMBER>
    volumes:
      - $STORAGES_DIR/node-data-<REDIS_PORT_NUMBER>:/bitnami/redis/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDISCLI_AUTH=$REDIS_PASSWORD
      - REDIS_PORT_NUMBER=<REDIS_PORT_NUMBER>
      - REDIS_CLUSTER_ANNOUNCE_PORT=<REDIS_PORT_NUMBER>
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP # 主机IP或公网IP，不要使用127.0.0.1或localhost
      - REDIS_CLUSTER_ANNOUNCE_BUS_PORT=1<REDIS_PORT_NUMBER>
      - REDIS_CLUSTER_DYNAMIC_IPS=no
      - REDIS_NODES=$REDIS_NODES
      - DOMAIN_TO_IPS=$DOMAIN_TO_IPS
    ports:
      - <REDIS_PORT_NUMBER>:<REDIS_PORT_NUMBER>
      - 1<REDIS_PORT_NUMBER>:1<REDIS_PORT_NUMBER>

networks:
  redis-cluster-network-<REDIS_PORT_NUMBER>:
