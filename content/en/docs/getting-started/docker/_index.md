---
title: "Deployment with Docker"
linkTitle: "Deployment with Docker"
weight: 4
---

The IAM service is provided on the following DockerHub repositories:

- [indigoiam/iam-login-service](https://hub.docker.com/r/indigoiam/iam-login-service/)

The docker image tag corresponding to this version of the documentation is:

{{% pageinfo color="primary" %}}
indigoiam/iam-login-service:{{< param version >}}
{{% /pageinfo %}}

### Configuration and run

Prepare an environment file that will contain the environment variables
settings for the IAM service container. See [the configuration
reference][config-reference] for a description of the variables.

The IAM service is run starting the docker container with the following command:

```shell
$ docker run \
  --name iam-login-service \
  --net=iam -p 8080:8080 \
  --env-file=/path/to/iam-login-service/env \
  -v /path/to/keystore.jks:/keystore.jks:ro \
  indigoiam/iam-login-service:{{< param version >}}
```

Check the logs with:

```shell
$ docker logs -f iam-login-service
```
[config-reference]: {{< ref "/docs/reference/configuration" >}}
