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

在 k8s 环境中可以使用 helm 启动该镜像

    helm repo add kungze https://charts.kungze.net
    helm install debug-env kungze ubuntu-develop-env

部署完成后会创建一个 statefulset 和一个 NodePort 类型的 service （默认端口为 30022），另外还会把 pod 对应的
主容器的 /home 目录映射到属主机（属主机对应目录为 /data/ubuntu）当然也可以通过设置 homeStorageClass 参数为容器
的 /home 目录申请一块持久化存储，这种操作会保证即使 pod 重启或者被删除其 /home 目录下的数据也会存在。

可以通过下面的命令登录：

  ```console
  ssh user@<宿主机 IP> -p 30022
  ```

登录之后，还可以切换到 root 用户来执行 kubectl 命令

  ```console
  $ sudo su -
  # kubectl get pods
  NAME                       READY   STATUS    RESTARTS           AGE
  debug-env-statusfulset-0   1/1     Running   1 (8d ago)         25d
  ```

更多细节请参照[文档](chart/README.md)
