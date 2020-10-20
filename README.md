# docker-spug

主要解决docker方式安装的spug, 构建项目期间无法使用docker的问题

使用 [docker in docker](https://hub.docker.com/_/docker) 达到在spug容器中调用docker


## 启动

```shel
git clone https://github.com/hteen/docker-spug.git
cd docker-spug
docker-compose up -d
```

访问 [http://127.0.0.1:8080/](http://127.0.0.1:8080/)

初始账号: `admin`, 密码: `spug.dev`

## 数据持久化

* `data/db/` 数据库目录, 使用sqlite3
* `data/repos/` 仓库目录
* `data/logs/` spug日志目录

## 升级

```shel
docker-compose down
docker pull hteen/docker-spug
docker-compose up -d
```