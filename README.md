# Docker Compose 微服务架构项目

## 概述

此项目基于 Docker Compose 构建，集成了 MySQL、Nacos、Redis、RabbitMQ、MinIO、vsftpd 等常用中间件，以及网关、测试平台和物联网服务等微服务组件，形成了完整的微服务架构体系。

## 目录结构

```
├── app/                          # 应用程序目录
│   ├── gateway/                  # 网关服务
│   ├── iot/                      # 物联网服务
│   ├── test-rig/                 # 测试平台服务
│   ├── avionics-simulation/      # 航电仿真服务
│   └── win-log/                  # Windows 日志工具
├── ftp/                          # FTP 服务数据和日志目录
├── images/                       # Docker 镜像文件
├── logs/                         # 通用日志目录
├── minio/                        # MinIO 对象存储配置
│   ├── config/                   # MinIO 配置文件
│   ├── data/                     # MinIO 数据目录
│   └── init.sh                   # MinIO 初始化脚本
├── mysql/                        # MySQL 数据库配置
│   ├── data/                     # MySQL 数据目录
│   ├── sqls/                     # SQL 初始化脚本
│   └── init.sql                  # MySQL 初始化脚本
├── nacos/                        # Nacos 配置中心
│   ├── conf/                     # Nacos 配置文件
│   └── logs/                     # Nacos 日志目录
├── rabbitmq/                     # RabbitMQ 消息队列
│   ├── conf/                     # RabbitMQ 配置文件
│   ├── data/                     # RabbitMQ 数据目录
│   └── init.sh                   # RabbitMQ 初始化脚本
├── redis/                        # Redis 缓存
│   ├── conf/                     # Redis 配置文件
│   └── data/                     # Redis 数据目录
├── .env                          # 环境变量配置文件
├── docker-compose.yml            # Docker Compose 配置文件
├── docker-compose-prod.yaml      # 生产环境 Docker Compose 配置文件
└── README.md                     # 本说明文件
```

## 服务说明

### 1. MySQL (8.0.35)
- **容器名称**: mysql
- **端口映射**: 3306:3306
- **环境变量**:
    - `MYSQL_ROOT_PASSWORD`: $*nM2Kc4
    - `TZ`: Asia/Shanghai
- **功能**: 作为数据存储中心，支持 nacos 等应用的数据存储，配置了字符集、SQL模式等参数
- **初始化**: 通过 init.sql 和 sqls 目录中的脚本初始化数据库

### 2. Nacos (v3.1.1)
- **容器名称**: nacos
- **端口映射**: 8080:8080, 8848:8848, 9848:9848
- **环境变量**:
    - `MODE`: standalone (单机模式)
    - `SPRING_DATASOURCE_PLATFORM`: mysql # 数据库连接配置指向 MySQL
- **功能**: 服务发现与配置中心
- **访问**: 3.x 访问地址为 IP:8080，用户名 nacos，首次登录后设置密码

### 3. Redis (8.4.0)
- **容器名称**: redis
- **端口映射**: 6379:6379
- **密码**: fUD5&b6%
- **功能**: 缓存服务
- **配置**: 启用认证，配置文件位于 redis/conf/redis.conf

### 4. RabbitMQ (4.2.2-management)
- **容器名称**: rabbitmq
- **端口映射**: 5672:5672, 15672:15672
- **默认用户**: admin
- **默认密码**: (Xc7X%u5
- **功能**: 消息队列服务
- **初始化**: 通过 init.sh 脚本进行初始化配置

### 5. MinIO (RELEASE.2025-09-07T16-13-09Z)
- **容器名称**: minio
- **端口映射**: 9000:9000, 9001:9001
- **默认用户**: admin
- **默认密码**: _4DR#v5x
- **功能**: 对象存储服务
- **初始化**: 通过 init.sh 脚本创建存储桶和用户权限

### 6. vsftpd (FTP 服务)
- **容器名称**: vsftpd-server
- **端口映射**: 20:20, 21:21, 21100-21110:21100-21110
- **默认用户**: ftpuser
- **默认密码**: ftpuser
- **功能**: FTP 文件传输服务
- **配置**: 支持被动模式，自动获取宿主机IP地址

### 7. Gateway (Spring Boot Application)
- **容器名称**: gateway
- **端口映射**: 8088:8080
- **功能**: API 网关服务
- **配置**: 连接 Nacos 服务发现，命名空间 zjmfz-mini-rig

### 8. Test-Rig (测试平台)
- **容器名称**: test-rig
- **功能**: 测试平台微服务
- **配置**: 连接 Nacos 服务发现

### 9. IoT (物联网服务)
- **容器名称**: iot
- **端口映射**: 9082:9082/udp
- **功能**: 物联网服务，支持 UDP 通信
- **配置**: 连接 Nacos 服务发现

## Docker Compose 配置说明

### 网络配置
- **网络名称**: app-network
- **驱动**: bridge
- **作用**: 所有服务通过此网络进行通信

### 服务依赖关系
- MySQL 作为基础数据服务，无依赖
- Nacos 依赖 MySQL，等待 MySQL 健康检查通过后启动
- 其他服务连接到 Nacos 进行服务注册发现

### 健康检查
- MySQL: 使用 `mysqladmin ping` 检查服务状态
- Nacos: 通过 HTTP 请求检查控制台接口
- Redis: 使用 `redis-cli` 命令测试连接
- RabbitMQ: 使用 `rabbitmq-diagnostics ping` 检查
- MinIO: 检查健康端点 `/minio/health/live`
- 应用服务: 通过 `/actuator/health` 检查应用状态

## windows 安装部署
> 进入此文件目录下的 cmd 命令行
#### 安装WSL2内核
- 双击运行 ·./install/wsl.2.6.3.0.x64.msi`

#### 安装docker
- 双击运行 ·./install/Docker Desktop Installer.exe`,按提示傻瓜式安装
- 重启
- 重启后打开 Docker Desktop（桌面会有对应图标）
#### ip 配置
> 因 ftp 被动模式需要知道宿主机ip，需进行如下配置
> 
> 1. 修改 `.env` 文件中的`VSFTPD_PASV_ADDRESS` 参数值为当前宿主机IP地址
> 
> 2. 程序中连接的FTP服务器地址改为对应的宿主机IP地址
#### 加载镜像
- docker load < ./images/app-images.tar
- 需等待几分钟，过程中可能卡输出，可不定时按下回车，查看是否已完成，完成后会显示加载的镜像列表

#### 启动
- docker compose up -d

#### 验证
- docker compose ps

#### 设置开机自启
- 打开windows任务管理（按住win+R,输入taskschd.msc）
- 常规：
  - 名称：Docker Desktop Auto Start
  - 描述：Docker开机自启
  - 安全选项：
    - 勾选：不管用户是否登录都要运行
    - 勾选：使用最高权限运行
  - 配置选项：
    - 勾选：windows10（按自己 windows 版本选择）
- 触发器：
  - 点击新建
    - 开始任务：选择“启动时”
    - 最底部勾选“已启用”
    - 点击确定
- 操作：
  - 点击新建
  - 操作：选择“启动程序”
  - 程序：输入：`docker`
  - 添加参数：输入：`desktop start`
  - 点击确定
- 条件：所有框全部取消勾选
- 设置：所有框全部取消勾选
- 点击确定（可能需要输入账户密码，输入对应的账户密码即可，若没有密码则设置账户密码）
- 重启计算机，测试docker 程序是否有启动，可以通过cmd运行 `docker compose ps` 命令查看服务是否正常运行
## 访问地址

| 服务 | Web 访问地址 | 服务连接地址 | 账号密码 |
|------|-------------|-------------|----------|
| Nacos | http://127.0.0.1:8080 | 127.0.0.1:8848 | nacos/admin |
| RabbitMQ | http://127.0.0.1:15672 | 127.0.0.1:5672 | admin/(Xc7X%u5 |
| MinIO Console | http://127.0.0.1:9001 | 127.0.0.1:9000 | admin/_4DR#v5x |
| Gateway | http://127.0.0.1:8088 | 127.0.0.1:8088 | - |

## 服务管理

### 启动服务
```bash
docker compose up -d
```

### 停止服务
```bash
docker compose down
```

### 查看日志
```bash
docker compose logs -f <service-name>
```

### 重启特定服务
```bash
docker compose restart <service-name>
```

### 构建并启动
```bash
docker compose build
docker compose up -d
```

## 环境变量配置

项目使用 `.env` 文件统一管理环境变量，包括：
- 时区配置
- 各服务端口配置
- 用户名密码配置
- 镜像版本配置

## 安全说明

- 所有服务密码已在配置文件中设置，请在生产环境中更改默认密码
- MySQL 使用安全连接参数
- Redis 启用认证保护模式
- Nacos 启用身份验证
- 网络隔离使用专用桥接网络
- FTP 服务禁用了匿名访问

## 故障排除

1. **服务启动失败**: 检查端口占用情况，确保所需端口未被其他服务占用
2. **健康检查失败**: 检查依赖服务是否正常运行
3. **数据库连接失败**: 确认 MySQL 服务正常，数据库初始化完成
4. **服务发现异常**: 确认 Nacos 服务正常，网络连通性良好
5. **FTP 连接问题**: 确认 PASV_ADDRESS 配置正确，防火墙允许相应端口

## 维护说明

- 日志文件存储在各服务对应的 logs 目录
- 数据持久化存储在各服务对应的 data 目录
- 配置文件可通过挂载卷进行自定义
- 定期备份数据目录确保数据安全
- 使用 docker-compose 的健康检查功能监控服务状态
## other
### svit
>
> 添加：netsh interface portproxy add v4tov4 listenport=18080 listenaddress=0.0.0.0 connectport=80 connectaddress=192.168.56.101
>
> 删除: netsh interface portproxy delete v4tov4 listenport=18080 listenaddress=0.0.0.0
>
>1.启动虚拟机软件Oracle VirtualBox，启动镜像svit-docker(2.0.9.1-p1)，直至启动完毕
>
>2.打开远程SSH工具，远程地址：192.168.56.101，用户名：svit，密码：svit123
>
>3.输入命令：cd /home/svit/svit-docker/
>
>4.输入命令：sudo docker compose -f dockercompose/server-only/docker-compose.yml --env-file init-env/server-config.env up -d
>
>5.浏览器输入地址：192.168.56.101，可利用管理员账户登录：admin@svit.com，密码：svit123456

