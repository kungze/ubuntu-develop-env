# k8s-debug-env

The chart used to deploy a development environment quickly. The container image
builed base on ubuntu 20.04.

## Parameters

### Global parameters

| Name                   | Form title    | Description                                                                | Value                          |
| ---------------------- | ------------- | -------------------------------------------------------------------------- | ------------------------------ |
| `imageRegistry`        | imageRegistry | Container image registry                                                   | `registry.aliyuncs.com/kungze` |
| `tag`                  |               | The container image tag                                                    | `latest`                       |
| `homeStorageClass`     |               | The storagaclass name used to claim volume for container's home dirtctory. | `""`                          |
| `homeStorageSize`      |               | The storage size of container's home directory                             | `10Gi`                         |
| `createServiceAccount` |               | Where or not create a serviceaccount for the pod.                          | `true`                         |

### Host Parameters

| Name                   | Form title  | Description                                                                                                       | Value          |
| ---------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------- | -------------- |
| `hostConf.nodePort`    | nodePort    | The nodePort of k8s service, you can login the environment by the port use ssh client.                            | `30022`        |
| `hostConf.homeDirPath` | hostDirPath | The host node's directory path, the directory will mount to the main container as the container's home directory. | `/data/ubuntu` |

### Container parameters

| Name                         | Form title | Description                                                                                                          | Value      |
| ---------------------------- | ---------- | -------------------------------------------------------------------------------------------------------------------- | ---------- |
| `containerConf.userName`     |            | The environment's user name, it will be auto created when pod start, you can use this user to login the environment. | `ubuntu`   |
| `containerConf.userPassword` |            | The above's user password.                                                                                           | `ChangeMe` |
| `containerConf.userGroup`    |            | The environment's user group, it will be auto created when pod start.                                                | `ubuntu`   |
