FROM ubuntu:20.04

ARG GOLANG_VERSION=1.17.6
ARG HELM_VERSION=3.8.0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt install -y iputils-arping iputils-ping iputils-tracepath git vim make iproute2 sudo apt-transport-https ca-certificates curl gnupg-agent software-properties-common wget python3 gcc python3-dev nodejs npm \
    && curl https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add - \
    && curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - \
    && add-apt-repository "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" \
    && add-apt-repository "deb https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "export LANG=C.UTF-8" >> /etc/profile \
    && apt clean

RUN apt install -y docker-ce-cli kubectl openssh-client openssh-server dumb-init \
    && systemctl disable ssh.service \
    && apt clean \
    && mkdir -p /run/sshd
COPY sshd_config /etc/ssh/sshd_config

RUN curl https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz -o go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && rm -rf go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile \
    && echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile \
    && echo 'export GOPATH=$HOME/gowork' >> /etc/profile

RUN curl https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && cp linux-amd64/helm /usr/bin/ \
    && helm plugin install https://github.com/chartmuseum/helm-push \
    && rm -rf linux-amd64 \
    && rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz

COPY run_sshd.sh run_sshd
RUN chmod +x run_sshd

COPY kube_config.sh /usr/bin/kube_config
RUN chmod +x /usr/bin/kube_config

VOLUME /home
EXPOSE 22

ENTRYPOINT ["dumb-init", "--"]
CMD ["./run_sshd"]
