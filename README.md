# redis-cluster-docker-deploy
该项目提供 redis-cluster 部署，基于 bitnami/redis-cluster 或 redis 进行部署，提供 docker-compose.yaml 和 k8s yaml 文件，您根据需要选择部署环境。


#### 基于 bitnami/redis-cluster docker-compose.yaml 单机器部署说明
1.  进入 docker-coompose/single-machine 目录：`cd docker-compose/single-machine`
2.  执行 `cp env.tpl .env`，并且配置 .env
3.  运行 `bash run-docker.sh` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  查看日志: docker-compose logs -f

#### 基于 bitnami/redis-cluster docker-compose.yaml 多机器部署说明
1.  进入 docker-coompose/multi-machine 目录：`cd docker-compose/multi-machine`
2.  执行 `cp env.tpl .env`，并且配置 .env
3.  执行 `cp hosts.tpl hosts`，并且配置 hosts，需要配置所有集群节点
4.  运行 `bash run-docker.sh <REDIS_PORT>`, REDIS_PORT 范围: 3主3从为[6373,6378]，3主0从为[6373,6375] 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
5.  到其它机器重复上面的操作，直到所有节点都启动后，开始分配主从节点: `docker-compose -f docker-compose.redis-cluster-create.yaml up`【在任意一个节点的 docker-compose/multi-machine 目录下执行】
6.  查看日志: docker-compose -f docker-compose.redis-cluster-create.yaml logs -f 或 docker-compose -f docker-compose.<REDIS_PORT>.yaml logs -f

#### 基于 redis 镜像 docker-compose.yaml 单机器部署说明
1.  进入 docker-coompose/single-machine 目录：`cd docker-compose/single-machine`
2.  拷贝 env 并进入 redis-image-deploy 目录，执行 `cp env.tpl redis-image-deploy/.env && cd redis-image-deploy`，配置 .env
3.  生成所需的 redis.conf, 执行 `bash init-cluster-conf.sh`
4.  运行 `bash run-docker.sh` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
5.  查看日志: docker-compose logs -f

#### 基于 redis 镜像 docker-compose.yaml 多机器部署说明
1.  进入 docker-coompose/multi-machine 目录：`cd docker-compose/multi-machine`
2.  拷贝 env 并进入 redis-image-deploy 目录，执行 `cp env.tpl redis-image-deploy/.env && cd redis-image-deploy`，配置 .env
3.  执行 `cp hosts.tpl hosts`，并且配置 hosts，需要配置所有集群节点
4.  生成所需的 redis.conf, 执行 `bash init-cluster-conf.sh`
5.  运行 `bash run-docker.sh <REDIS_PORT>`, REDIS_PORT 范围: 3主3从为[6373,6378]，3主0从为[6373,6375] 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
6.  到其它机器重复上面的操作，直到所有节点都启动后，开始分配主从节点: `docker-compose -f docker-compose.cluster-redis-create.yaml up`【在任意一个节点的 docker-compose/multi-machine/redis-image-deploy 目录下执行】
7.  查看日志: docker-compose -f docker-compose.cluster-redis-create.yaml logs -f 或 docker-compose -f docker-compose.<REDIS_PORT>.yaml logs -f

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