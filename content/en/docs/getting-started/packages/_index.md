---
title: "Deployment with packages"
linkTitle: "Deployment with packages"
weight: 5
---

IAM can be deployed from packages on the CentOS 7 platform.
Packages and repo files are hosted on the [INDIGO IAM package repository][iam-pkg-repo].

{{% alert title="Warning" color="warning" %}}
We no longer maintain packages for the Ubuntu platform.
{{% /alert %}}

## CENTOS 7

1. Install the INDIGO IAM release key:

  ```shell
  $ sudo rpm --import https://indigo-iam.github.io/repo/gpgkeys/indigo-iam-release.pub.gpg
  ```

2. Install the repo files:

  ```shell
  $ sudo yum-config-manager --add-repo https://indigo-iam.github.io/repo/repofiles/rhel/indigoiam-stable-el7.repo
  ```

3. Install packages:

  ```shell
  $ sudo yum makecache
  $ sudo yum install -y iam-login-service
  ```


## IAM service configuration

The IAM service is configured via a configuration file named `iam-login-service`
which holds the settings for the environment variables that drive its
configuration (as described in the [configuration reference
section](/docs/reference/configuration)).

The file is located in the following path:

```
/etc/sysconfig/iam-login-service
```
## Run the service

The IAM login service is managed by `systemd`.

To enable the service use the following command:

```shell
$ sudo systemctl enable iam-login-service
```

To start the service use the following command:

```shell
$ sudo systemctl start iam-login-service
```

To access the service logs, use the following command:

```shell
$ sudo journalctl -fu iam-login-service
```

## Automated provisioning with Puppet


The IAM login service Puppet module can be  found [here][puppet-iam-repo].
The module configures the IAM Login Service packages installation,
configuration and the automatic generation of the JWK keystore.

The setup of the MySQL database used by the service as well as the setup of the
reverse proxy are **not covered** by this module.

However, the module provides an example of setup of both the Login Service and
NginX as reverse proxy, using the official NginX Puppet module.

For more detailed information about the Indigo IAM Puppet module usage, see the
documentation in the [Github repository][puppet-iam-repo].

[puppet-iam-repo]: https://github.com/indigo-iam/puppet-indigo-iam
[iam-pkg-repo]: https://indigo-iam.github.io/repo
