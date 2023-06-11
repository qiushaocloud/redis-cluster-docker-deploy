# redis-cluster-docker-deploy
该项目提供 redis-cluster 部署，基于 qiushaocloud/redis-cluster 或 bitnami/redis-cluster 进行部署，提供 docker-compose 和 k8s 的 yaml 文件，您根据需要选择部署环境。


#### 打包镜像 qiushaocloud/redis-cluster:latest
> 封装 redis 镜像成 redis-cluster，通过环境变量进行配置，解决创建集群时无法使用域名/主机名问题
* 进入 redis-cluster-image 打包镜像: `cd redis-cluster-image && bash build-docker.sh`
* 可以设置的环境变量参考文件 `run-redis-server.sh`
``` shell
#!/bin/bash

echo "start run-redis-server.sh"

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
```
* 创建集群时，会将 REDIS_NODES 域名/主机名转成对应的 ip，需要注意的是域名/主机名所在的机器需要支持 ping，可以参考脚本 `run-create-cluster.sh`
* 运行 redis 集群节点及创建集群的 docker-compose.yaml 参考
``` yaml
version: '3'
services:
  redis-cluster-node-6373:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-node-6373
    container_name: redis-cluster-node-6373
    volumes:
      - $STORAGES_DIR/redis-data-6373:/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=6373
    ports:
      - 6373:6373
      - 16373:16373

  redis-cluster-node-6374:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-node-6374
    container_name: redis-cluster-node-6374
    volumes:
      - $STORAGES_DIR/redis-data-6374:/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=6374
    ports:
      - 6374:6374
      - 16374:16374

  redis-cluster-node-6375:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-node-6375
    container_name: redis-cluster-node-6375
    volumes:
      - $STORAGES_DIR/redis-data-6375:/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=6375
    ports:
      - 6375:6375
      - 16375:16375

  redis-cluster-node-6376:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-node-6376
    container_name: redis-cluster-node-6376
    volumes:
      - $STORAGES_DIR/redis-data-6376:/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=6376
    ports:
      - 6376:6376
      - 16376:16376

  redis-cluster-node-6377:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-node-6377
    container_name: redis-cluster-node-6377
    volumes:
      - $STORAGES_DIR/redis-data-6377:/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=6377
    ports:
      - 6377:6377
      - 16377:16377
  
  redis-cluster-node-6378:
    image: qiushaocloud/redis-cluster:latest
    restart: always
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-node-6378
    container_name: redis-cluster-node-6378
    volumes:
      - $STORAGES_DIR/redis-data-6378:/data
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_ANNOUNCE_IP=$REDIS_CLUSTER_ANNOUNCE_IP
      - REDIS_PORT_NUMBER=6378
    ports:
      - 6378:6378
      - 16378:16378


  redis-cluster-create:
    image: qiushaocloud/redis-cluster:latest
    #network_mode: host
    networks:
      - redis-cluster-network
    hostname: redis-cluster-create
    container_name: redis-cluster-create
    command: bash /run-create-cluster.sh
    environment:
      - REDIS_PASSWORD=$REDIS_PASSWORD
      - REDIS_CLUSTER_REPLICAS=1
      - REDIS_NODES=redis-cluster-node-6373:6373 redis-cluster-node-6374:6374 redis-cluster-node-6375:6375 redis-cluster-node-6376:6376 redis-cluster-node-6377:6377 redis-cluster-node-6378:6378
    depends_on:
      - redis-cluster-node-6373
      - redis-cluster-node-6374
      - redis-cluster-node-6375
      - redis-cluster-node-6376
      - redis-cluster-node-6377
      - redis-cluster-node-6378
    links:
      - redis-cluster-node-6373
      - redis-cluster-node-6374
      - redis-cluster-node-6375
      - redis-cluster-node-6376
      - redis-cluster-node-6377
      - redis-cluster-node-6378

networks:
  redis-cluster-network:
    driver: bridge
```


#### 基于 redis 镜像 docker-compose.yaml 单机器部署说明
1.  进入 docker-coompose/single-machine 目录：`cd docker-compose-deploy/single-machine`
2.  执行 `cp env.tpl .env`，配置 .env
3.  运行 `bash run-docker.sh` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  查看日志: docker-compose logs -f

#### 基于 redis 镜像 docker-compose.yaml 多机器部署说明
1.  进入 docker-coompose/multi-machine/bitnami-redis-cluster-deploy 目录：`cd docker-compose-deploy/multi-machine/bitnami-redis-cluster-deploy`
2.  执行 `cp env.tpl .env`，配置 .env
3.  运行 `bash run-docker.sh <REDIS_PORT>`, REDIS_PORT 范围: 3主3从为[6373,6378]，3主0从为[6373,6375] 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  到其它机器重复上面的操作，直到所有节点都启动后，开始分配主从节点: `docker-compose -f docker-compose.redis-cluster-create.yaml up`【在任意一个节点的 docker-compose-deploy/multi-machine/bitnami-redis-cluster-deploy 目录下执行】
5.  查看日志: docker-compose -f docker-compose.redis-cluster-create.yaml logs -f 或 docker-compose -f docker-compose.<REDIS_PORT>.yaml logs -f

#### 基于 bitnami/redis-cluster docker-compose.yaml 单机器部署说明
1.  进入 docker-coompose/single-machine 目录：`cd docker-compose-deploy/single-machine`
2.  执行 `cp env.tpl .env`，并且配置 .env
3.  运行 `bash run-docker.sh` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  查看日志: docker-compose logs -f

#### 基于 bitnami/redis-cluster docker-compose.yaml 多机器部署说明
1.  进入 docker-coompose/multi-machine 目录：`cd docker-compose-deploy/multi-machine/bitnami-redis-cluster-deploy`
2.  执行 `cp env.tpl .env`，并且配置 .env
3.  运行 `bash run-docker.sh <REDIS_PORT>`, REDIS_PORT 范围: 3主3从为[6373,6378]，3主0从为[6373,6375] 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  到其它机器重复上面的操作，直到所有节点都启动后，开始分配主从节点: `docker-compose -f docker-compose.redis-cluster-create.yaml up`【在任意一个节点的 docker-compose-deploy/multi-machine 目录下执行】
5.  查看日志: docker-compose -f docker-compose.redis-cluster-create.yaml logs -f 或 docker-compose -f docker-compose.<REDIS_PORT>.yaml logs -f

#### 基于 bitnami/redis-cluster k8s yaml 部署说明
> 暂时没提供


#### redis k8s yaml 部署说明
> 暂时没提供


#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 分享者信息

1. 分享者邮箱: qiushaocloud@126.com
2. [分享者网站](https://www.qiushaocloud.top)
3. [分享者自己搭建的 gitlab](https://gitlab.qiushaocloud.top/qiushaocloud) 
3. [分享者 gitee](https://gitee.com/qiushaocloud/dashboard/projects) 
3. [分享者 github](https://github.com/qiushaocloud?tab=repositories) 
