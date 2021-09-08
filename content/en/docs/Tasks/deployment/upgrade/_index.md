---
title: "Upgrade"
linkTitle: "Upgrade"
weight: 100
---

This section provides instructions to upgrade the IAM service to the latest
available version.

### Deployment from packages

Stop the service:

```shell
$ systemctl stop iam-login-service
```

Update the package:

```shell
$ yum update -y iam-login-service
```

Restart the service:

```shell
$ systemctl start iam-login-service
```

### Deployment with Docker 

Stop and remove the running container:

```shell
$ docker stop iam-login-service
$ docker rm iam-login-service
```

Pull the latest image:
```shell
$ docker pull indigoiam/iam-login-service:latest
```

Restart the container:
```shell
$ docker run \
  --name iam-login-service \
  --net=iam -p 8080:8080 \
  --env-file=/path/to/iam-login-service/env \
  -v /path/to/keystore.jks:/keystore.jks:ro \
  indigoiam/iam-login-service:latest
```

Otherwise, you can specify the exact tag version. For example, if the latest
tag is `v1.1.0-latest`:
```shell
$ docker run \
  --name iam-login-service \
  --net=iam -p 8080:8080 \
  --env-file=/path/to/iam-login-service/env \
  -v /path/to/keystore.jks:/keystore.jks:ro \
  indigoiam/iam-login-service:v1.1.0-latest
```
