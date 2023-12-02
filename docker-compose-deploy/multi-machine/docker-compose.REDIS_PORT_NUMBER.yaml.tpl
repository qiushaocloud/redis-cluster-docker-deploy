version: '3'
services:
  redis-cluster-node-<REDIS_PORT_NUMBER>:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network-<REDIS_PORT_NUMBER>
    hostname: redis-cluster-node-<REDIS_PORT_NUMBER>
    container_name: redis-cluster-node-<REDIS_PORT_NUMBER>
    volumes:
      - $STORAGES_DIR/redis-data-<REDIS_PORT_NUMBER>:/data
    ports:
      - <REDIS_PORT_NUMBER>:<REDIS_PORT_NUMBER>
      - 1<REDIS_PORT_NUMBER>:1<REDIS_PORT_NUMBER>
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=<REDIS_PORT_NUMBER>
      - DOMAIN_TO_IPS=$DOMAIN_TO_IPS

networks:
  redis-cluster-network-<REDIS_PORT_NUMBER>:

