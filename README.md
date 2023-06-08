# redis-cluster-docker-deploy
该项目提供 redis-cluster 部署，基于 bitnami/redis-cluster 或 redis 进行部署，提供 docker-compose.yaml 和 k8s yaml 文件，您根据需要选择部署环境。


#### 基于 bitnami/redis-cluster docker-compose.yaml 部署说明

1.  执行 `cp env.tpl .env`，并且配置 .env
2.  运行 `docker-compose up -d` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
3.  查看日志: docker-compose logs -f


#### 基于 redis docker-compose.yaml 部署说明

1.  执行 `cp env.tpl redis-deploy/.env`，进入 redis-deploy 并且配置 .env
2.  生成所需的 redis.conf, 执行 `bash init-cluster-conf.sh`
3.  运行 `docker-compose up -d` 【注：docker-compose 低版本识别不了 .env，需要进行升级，作者用的版本是: 1.29.2】
4.  查看日志: docker-compose logs -f


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