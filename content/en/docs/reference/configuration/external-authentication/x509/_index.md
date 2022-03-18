---
title: "X.509 authentication"
linkTitle: "X.509 authentication"
weight: 3
---


X509 authentication in IAM doesn't require any specific configuration in IAM itself.
It is enabled as soon as the proper options have been set in the Nginx configuration.

For the X509 authentication to work, it is critical that the user certificate CA
is known to Nginx. If it is not part of the CAs configured in `/etc/ssl`, you may need
to add the following line to your Nginx configuration:

```
ssl_client_certificate  CA_certificates_file;
```

where `CA_certificates_file` is the path to a file containing the certificates (in PEM
format) of the CAs that must be accepted by Nginx.

