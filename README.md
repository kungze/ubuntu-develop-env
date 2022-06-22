# ubuntu-develop-env

[![build-and-push](https://github.com/kungze/ubuntu-develop-env/actions/workflows/build-and-push.yaml/badge.svg)](https://github.com/kungze/ubuntu-develop-env/actions/workflows/build-and-push.yaml)

[English README](README_en.md)

快速启动 python 和 golang 开发环境

## 编译

可以通过 `GOLANG_VERSION` 指定安装的 golang 版本，默认是 1.17.6

    docker build --build-arg GOLANG_VERSION=1.17.5 -t ubuntu-develop-env:latest .

编译好的镜像安装了一些常用工具，包括 docker-ce-cli, kubectl, helm 等

## 部署

可以通过下面两种方式下载已经编译好的镜像：

Dockerhub:

    docker pull kungeze/ubuntu-develop-env:latest

国内:

    docker pull registry.aliyuncs.com/kungze/ubuntu-develop-env:latest

**支持的功能：**

* 该镜像启动的容器使用 sshd 作为主服务，监听端口 22，并自动创建登录用户，默认用户名为：ubuntu，用户组：ubuntu，密码：ChangeMe，也可以在启动时通过指定环境 `NEW_USER`，  `NEW_GROUP`，`NEW_PASSWORD` 自定义用户名，用户组和密码，如：`-e NEW_USER=user -e NEW_GROU=group -e NEW_PASSWORD=password`
* 可以通过挂载宿主机上的 docker socket，使容器支持 docker 命令，如：`-v /var/run/docker.sock:/var/run/docker.sock`

启动命令

    docker run -d -e NEW_USER=user \
                  -e NEW_GROU=group \
                  -e NEW_PASSWORD=password \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -p 2022:22 \
                  kungeze/ubuntu-develop-env:latest

容器启动后可以通过下面命令登录容器

    ssh user@<宿主机 IP> -p 2022

### 使用 helm 部署

    helm repo add kungze https://kungze.github.io/charts
    helm install dev-debug-env kungze k8s-debug-env

更多细节请参照[文档](https://github.com/kungze/charts/tree/main/charts/k8s-debug-env)
