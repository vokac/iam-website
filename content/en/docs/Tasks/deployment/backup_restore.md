---
title: "Backup & Restore"
linkTitle: "Backup & Restore"
weight: 5
---


## Backup

The IAM data that needs to saved by a backup is:

- database data;
- service configuration, typically maintained in an environment file: `/etc/sysconfig/iam-login-service` on CentOS, `/etc/default/iam-login-service` on Ubuntuu; 
- the keystore used to sign JWT tokens: `/var/lib/indigo/iam-login-service/keystore.jks`;
- the SAML keystore, used when SAML authentication is enabled: `/var/lib/indigo/iam/iam-login-service/example.ks`.

The above locations apply when installing from packages on CentOS or Ubuntu.

An example of backup script is given below:

```bash
timestamp=`date +'%Y-%m-%d_%H%M%S'`

MYSQL_HOST="mydbhost"
MYSQL_USER="iamloginserviceuser"
MYSQL_PWD="iamloginservicepassword"
MYSQL_DBNAME="iamloginservicedb"

MYSQL_DUMP_OPTS="-u ${MYSQL_USER} -p${MYSQL_PWD} --host ${MYSQL_HOST}"

dumpfile=iam_dump.sql

mysqldump ${MYSQL_DUMP_OPTS} ${MYSQL_DBNAME} > ${dumpfile}

tar czf iam_backup.tar.gz \
  ${dumpfile} \
  /etc/sysconfig/iam-login-service \
  /var/lib/indigo/iam-login-service/keystore.jks \
  /var/lib/indigo/iam/iam-login-service/example.ks
```

The keystore paths can be customized, so adapt the backup script according your configuration.

If you are deploying IAM with Docker and use a volume to provide configuration
to the service, backup the contents of such volume.

## Restore

From the backup, import the database data from the SQL dump:

```shell
$ export MYSQL_HOST="mydbhost"
$ export MYSQL_USER="iamloginserviceuser"
$ export MYSQL_PWD="iamloginservicepassword"
$ export MYSQL_DBNAME="iamloginservicedb"

$ mysql --host ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PWD} ${MYSQL_DBNAME} < iam_backup/iam_dump.sql
```

### Deployment from packages

To restore the IAM service from scratch, install the package.  

On CentOS:
```shell
$ sudo yum install -y iam-login-service
```

Restore the environment file.  

On CentOS:
```shell
$ sudo cp iam_backup/etc/sysconfig/iam-login-service /etc/sysconfig/iam-login-service
```
On Ubuntu:
```shell
$ sudo cp iam_backup/etc/default/iam-login-service /etc/default/iam-login-service
```

Copy the keystores in the correct path, according to your configuration:
```shell
$ sudo cp iam_backup/var/lib/indigo/iam-login-service/keystore.jks /var/lib/indigo/iam-login-service/keystore.jks
$ sudo cp iam_backup/var/lib/indigo/iam/iam-login-service/example.ks /var/lib/indigo/iam/iam-login-service/example.ks
```

Ensure the keystores have the right ownership:
```shell
$ sudo chown -R iam:iam /var/lib/indigo/iam-login-service
```

Start the IAM Login Service daemon:
```shell
$ sudo systemctl start iam-login-service
```

### Deployment with Docker 

Copy the files from the backup to the volume location:

```shell
$ cp iam_backup/iam-login-service/env /path/to/iam-login-service/env
$ cp iam_backup/keystore.jks /path/to/keystore.jks
```

Start the container:
```shell
$ docker run \
  --name iam-login-service \
  --net=iam -p 8080:8080 \
  --env-file=/path/to/iam-login-service/env \
  -v /path/to/keystore.jks:/keystore.jks:ro \
  indigoiam/iam-login-service:latest
```
