# ubuntu-develop-env

快速启动 python 和 golang 开发环境

## 编译

在编译可以通过 `GOLANG_VERSION` 指定安装的 golang 版本，默认是 1.17.6

    docker build --build-arg GOLANG_VERSION=1.17.5 -t ubuntu-develop-env:latest .

编译好的镜像安装了一下常用工具，包括 docker-cli 和 kubectl 等

## 部署

**支持的功能：**

* 该镜像启动的容器使用 sshd 作为主服务，监听端口 22，并自动创建登录用户，默认用户名为：ubuntu，用户组：ubuntu，密码：ChangeMe，也可以在启动时通过指定环境 `NEW_USER`，  `NEW_GROUP`，`NEW_PASSWORD` 自定义用户名，用户组和密码，如：`-e NEW_USER=user -e NEW_GROU=group -e NEW_PASSWORD=password`
* 可以通过挂载宿主机上的 docker socket，使容器支持 docker 命令，如：`-v /var/run/docker.sock:/var/run/docker.sock`
* 可以自动生成 kubeconfig 文件，相关环境变量：`KUBE_CLUSTER_NAME`，`KUBE_CLUSTER_API_SERVER`，`KUBE_CLUSTER_CA_DATA`，`KUBE_USER_NAME`，`KUBE_USER_PASSWORD`，`KUBE_USER_CLIENT_CA_DATA`，`KUBE_USER_CLIENT_KEY_DATA`