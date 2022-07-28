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

The IAM image has been tested to run properly with either Docker or Podman. The configuration for the
IAM service container is the same but the details to run the container slightly differ. Differences
are covered in the next sections. In both cases, it is **highly** recommended to enable SELinux for
increased security.


## Configuring the IAM service

Prepare an environment file that will contain the environment variables
settings for the IAM service container. See [the configuration
reference][config-reference] for a description of the variables.

This environment file will be passed to the container with the `--env-file` option of the 
container engine. You can choose whatever file path/name you want.


## Running the container

### Docker

First create a Docker network for the IAM service with the command (the example uses
the network name `iam` but you are free to use another name as long as you use the same
one in the `run`command). It has to be done once (not at every restart of the container):

```shell
$ docker network create iam
```

When using Docker the IAM service is run starting container with the following command:

```shell
$ docker run -d \
  --name iam-login-service \
  --net=iam -p 8080:8080 \
  --env-file=/path/to/iam-login-service/env \
  -v /path/to/keystore.jks:/keystore.jks:ro \
  --restart unless-stopped \
  indigoiam/iam-login-service:{{< param version >}}
```

*Note: `--restart` is recommended if you want the IAM service to restart automatically
when the server running Docker is restarted.*

Check the logs with:

```shell
# Adapt the container name to the value you provided to --name in previous command
$ docker logs -f iam-login-service
```

### Podman

When using Podman, the `docker` command must be replaced by `podman` with the following 
differences in options:

* `--restart` is silently ignored as start/stop of the container at boot time is controlled
with `systemd` (see Podman documentation, [here][podman-generate-systemd]).
* You need to add option `Z` to third field of `-v` option so that the SELinux context
type is properly managed and the use of the volume by another container is prevented.
* Ensure that the directories containing the environment file and the keystore are 
labeled. It can be checked with `stat` command. If they are unlabeled use the following
command to fix it:

    ```shell
    $ chcon -R -t default_t /path/to/directory
    ```

The required commands to start the container then become:

```shell
$ podman network create iam      # First time only
$ podman run -d \
  --name iam-login-service \
  --net=iam -p 8080:8080 \
  --env-file=/path/to/iam-login-service/env \
  -v /path/to/keystore.jks:/keystore.jks:ro,Z \
  indigoiam/iam-login-service:{{< param version >}}
$ podman logs -f iam-login-service
```

[config-reference]: {{< ref "/docs/reference/configuration" >}}
[podman-generate-systemd]: https://docs.podman.io/en/latest/markdown/podman-generate-systemd.1.html
