---
title: "Health checks"
linkTitle: "Health checks"
---

The IAM Login Service exposes a set of health endpoints that can be used to
monitor the status of the service.

Health endpoints expose a different set of information depending on the user
privileges; users with administrator privileges will see more details, while
anonymous requests typically receive only a summary of the health status.

The health endpoints return:
- HTTP status code 200 if everything is ok;
- HTTP status code 500 if any health check fails.

## `/actuator/health`

This is a general application health check endpoint which composes disk space
and database health checks.

Examples.

```console
$ curl -s https://iam.local.io/actuator/health | jq
{
  "status": "UP"
}
```

Sending basic authentication, the endpoint returns a response with more details:

```console
$ curl -s -u $ADMINUSER:$ADMINPASSWORD https://iam.local.io/actuator/health | jq
{
  "status": "UP",
  "diskSpace": {
    "status": "UP",
    "total": 10725883904,
    "free": 9872744448,
    "threshold": 10485760
  },
  "db": {
    "status": "UP",
    "database": "MySQL",
    "hello": 1
  }
}
```

## `/health/mail`

This endpoint monitors the connection to the SMTP server configured for the
IAM Notification Service.

```console
$ curl -s https://iam.local.io/health/mail | jq
{
  "status": "UP"
}
```

With an authenticated request, the SMTP server details are returned:
```console
$ curl -u $ADMINUSER:$ADMINPASSWORD https://iam.local.io/health/mail | jq
{
  "status": "UP",
  "mail": {
    "status": "UP",
    "location": "smtp.local.io:25"
  }
}
```

## `/actuator/health/externalConnectivity`

This endpoint checks service connectivity to the Internet. By default, the
endpoint triggers a check on the connectivity to Google.

```console
$ curl -s https://iam.local.io/actuator/health/externalConnectivity | jq
{
  "status": "UP"
}
```

With an authenticated request, the external service URL is shown in the details.
```console
$ curl -s -u $ADMINUSER:$ADMINPASSWORD https://iam.local.io/actuator/health/externalConnectivity | jq
{
  "status": "UP",
  "google": {
    "status": "UP",
    "location": "http://www.google.it"
  }
}
```
