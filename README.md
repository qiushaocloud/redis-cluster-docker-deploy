# redis-cluster-docker-deploy
该项目提供 redis-cluster 部署及打包镜像，基于 qiushaocloud/redis-cluster 或 bitnami/redis-cluster 进行部署，提供 docker-compose 和 k8s 的 yaml 文件，您根据需要选择部署环境。


#### 打包镜像 qiushaocloud/redis-cluster:latest
> 封装 redis 镜像成 redis-cluster，通过环境变量进行配置，解决创建集群时无法使用域名/主机名问题
* 进入 redis-cluster-image 打包镜像: `cd redis-cluster-image && bash build-docker.sh`
* 可以设置的环境变量参考文件 `redis-cluster-image/run-redis-server.sh`
* 创建集群时，会将 REDIS_NODES 域名/主机名转成对应的 ip，需要注意的是域名/主机名所在的机器需要支持 ping，可以参考脚本 `redis-cluster-image/run-create-cluster.sh`
* 运行 redis 集群节点及创建集群的 docker-compose.yaml 参考 `docker-compose-deploy/single-machine/docker-compose.yaml`


#### 基于 qiushaocloud/redis-cluster 镜像 docker-compose.yaml 单机器部署说明
1.  进入 docker-coompose-deploy/single-machine 目录：`cd docker-compose-deploy/single-machine`
2.  执行 `cp env.tpl .env`，配置 .env
3.  运行 `bash run-docker.sh` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  查看日志: docker-compose logs -f

#### 基于 qiushaocloud/redis-cluster 镜像 docker-compose.yaml 多机器部署说明
1.  进入 docker-coompose-deploy/multi-machine 目录：`cd docker-compose-deploy/multi-machine`
2.  执行 `cp env.tpl .env`，配置 .env
3.  运行 `bash run-docker.sh <REDIS_PORT_NUMBER>`, REDIS_PORT_NUMBER 范围: 3主3从为[6373,6378]，3主0从为[6373,6375] 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  到其它机器重复上面的操作，直到所有节点都启动后，开始分配主从节点: `docker-compose -f docker-compose.redis-cluster-create.yaml up`【在任意一个节点的 docker-compose-deploy/multi-machine 目录下执行】
5.  查看日志: docker-compose -f docker-compose.redis-cluster-create.yaml logs -f 或 docker-compose -f docker-compose.<REDIS_PORT_NUMBER>.yaml logs -f

#### 基于 bitnami/redis-cluster 镜像 docker-compose.yaml 单机器部署说明
1.  进入 docker-coompose-deploy/single-machine/bitnami-redis-cluster-deploy 目录：`cd docker-compose-deploy/single-machine/bitnami-redis-cluster-deploy`
2.  执行 `cp env.tpl .env`，并且配置 .env
3.  运行 `bash run-docker.sh` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  查看日志: docker-compose logs -f

#### 基于 bitnami/redis-cluster 镜像 docker-compose.yaml 多机器部署说明
1.  进入 docker-coompose/multi-machine/bitnami-redis-cluster-deploy 目录：`cd docker-compose-deploy/multi-machine/bitnami-redis-cluster-deploy`
2.  执行 `cp env.tpl .env`，并且配置 .env
3.  运行 `bash run-docker.sh <REDIS_PORT_NUMBER>`, REDIS_PORT_NUMBER 范围: 3主3从为[6373,6378]，3主0从为[6373,6375] 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  到其它机器重复上面的操作，直到所有节点都启动后，开始分配主从节点: `docker-compose -f docker-compose.redis-cluster-create.yaml up`【在任意一个节点的 docker-compose-deploy/multi-machine/bitnami-redis-cluster-deploy 目录下执行】
5.  查看日志: docker-compose -f docker-compose.redis-cluster-create.yaml logs -f 或 docker-compose -f docker-compose.<REDIS_PORT_NUMBER>.yaml logs -f


#### redis k8s yaml 部署说明
1. 进入 k8s-deploy 目录: `cd k8s-deploy`
2. 执行 `cp env.tpl .env`，配置 .env【注: 默认配置只能在k8s集群中连接, 您根据需求调整配置，满足您集群外连接，默认节点选择器的策略为: K8S_NODE_SELECTOR_POLICY=REDIS_GROUP@1，需要您设置某个节点的 label 为 rdc-group-1】
3. 执行初始化操作：`bash init-all.sh`
4. 准备好 .env 配置中所需要的 nfs目录(如果配置了)，如果配置了 REDIS_CLUSTER_ANNOUNCE_IP，确保 REDIS_CLUSTER_ANNOUNCE_IP 在 redis 节点跑起来后能访问到 REDIS_CLUSTER_ANNOUNCE_IP:<REDIS_PORT_NUMBER> 和 REDIS_CLUSTER_ANNOUNCE_IP:1<REDIS_PORT_NUMBER>
5. 如果您配置的 K8S_NODE_SELECTOR_POLICY 为 REDIS_GROUP@1，您需要为 k8s node 设置 label，您可以调用 `bash set-label-redis-cluster-node.sh <NODE_HOSTNAME> <GROUP_INDEX>`，例如: `bash set-label-redis-cluster-node.sh k8s-node01 1`, 同理您配置为 REDIS_PORT 则需要调用 `bash set-label-redis-cluster-node.sh <NODE_HOSTNAME> <REDIS_PORT_NUMBER>`
6. 创建 pv 和 pvc: `bash apply-all-pv-pvc.sh`，等到 pv 和 pvc 准备完毕
7. 部署创建 redis pod: `bash apply-all-deploy.sh`，等到所有 pod 准备完毕
8. 构建 redis 集群以及主从关系: `bash apply-create-cluster.sh`
9. redis 集群部署完毕，您可以使用了
10. 取消部署 redis 集群: `bash delete-create-cluster.sh && bash delete-all-deploy.sh && bash delete-all-pv-pvc.sh` 

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
