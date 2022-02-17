# ubuntu-develop-env

[![build-and-push](https://github.com/kungze/ubuntu-develop-env/actions/workflows/build-and-push.yaml/badge.svg)](https://github.com/kungze/ubuntu-develop-env/actions/workflows/build-and-push.yaml)

[中文文档](README.md)

Rapidly set up a golang and python environment for develop and debug.


## build

You can specify the golang version by arg `GOLANG_VERSION`, the default value is 1.17.6.

    docker build --build-arg GOLANG_VERSION=1.17.5 -t ubuntu-develop-env:latest .

The `docker-ce-cli`, `kubectl` and `helm` will be auto installed.


## deploy

We provide two repos, you can pull the already built image by them.

For dockerhub:

    docker pull kungeze/ubuntu-develop-env:latest

For aliyun:

    docker pull registry.aliyuncs.com/kungze/ubuntu-develop-env:latest

Let's see the features this image support before we run the image:

* The `sshd` is the main process, listen on port 22. The image will auto create a user for container, for default, username: `ubuntu`, usergroup: `ubuntu`, password: `ChangeMe`. You can customize them by the follow envs: `UEW_USER`, `NEW_GROUP`, `NEW_PASSWORD`, such as: `-e NEW_USER=user -e NEW_GROU=group -e NEW_PASSWORD=password`.
* You can mount the host's docker socket to container when you boot a container by the image that make you can operate the host's container in the container. such as: `-v /var/run/docker.sock:/var/run/docker.sock`
* The image can auto generate `kubeconfig` file, the related envs: `KUBE_CLUSTER_NAME`, `KUBE_CLUSTER_API_SERVER`, `KUBE_CLUSTER_CA_DATA`, `KUBE_USER_NAME`, `KUBE_USER_PASSWORD`, `KUBE_USER_CLIENT_CA_DATA`, `KUBE_USER_CLIENT_KEY_DATA`.

Create a container:

    docker run -d -e NEW_USER=user \
                  -e NEW_GROU=group \
                  -e NEW_PASSWORD=password \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -p 2022:22 \
                  kungeze/ubuntu-develop-env:latest

Login container by ssh:

    ssh user@<host node address> -p 2022

### helm chart

    helm repo add kungze https://kungze.github.io/charts
    helm install dev-debug-env kungze k8s-debug-env

For more details please refer to the [document](https://github.com/kungze/charts/tree/main/charts/k8s-debug-env).

**Tip:** You can use vscode's [remote ssh](https://code.visualstudio.com/docs/remote/ssh) extension to connect the container for develop and debug.
