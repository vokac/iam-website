---
title: "Audit log"
linkTitle: "Audit log"
weight: 10
---

IAM Login Service traces interesting, security related events with an audit log.

Audit log messages are marked with the tag `AUDIT` in the Java class name
field.

An example of audit log message is the following:

```console
2017-09-11 09:58:14.560  INFO 13 --- [o-8080-exec-311] AUDIT : {"@type":"IamAuthenticationSuccessEvent","timestamp":1505116694560,"category":"AUTHENTICATION","principal":"794fb313-6e93-4d02-9d0a-4ed773ee2c5e","message":"794fb313-6e93-4d02-9d0a-4ed773ee2c5e authenticated succesfully","sourceEvent":{"principal":"794fb313-6e93-4d02-9d0a-4ed773ee2c5e","type":"InteractiveAuthenticationSuccessEvent"},"source":"UsernamePasswordAuthenticationToken"}
```

The IAM login service writes logs to standard output in the default
configuration. When deployed from packages, all logs are collected by the
system journal.
