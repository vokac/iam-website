---
title: "Proxy certificate API"
linkTitle: "Proxy certificate API"
weight: 1
---

IAM provides a RESTful API that can be used to download the X.509 proxy certificate previously uploaded in IAM dashboard by the user. \
This is a plain proxy obtained by running `voms-proxy-init` command.

The API has been added mainly for the integration of IAM with the [RCAuth.eu][RCauth] online certificate authority, but users can also upload their own long lived proxy certificate

```bash
grid-proxy-init -hours 8760:0
( echo -n '{"certificate_chain": "'; cat "/tmp/x509up_u$(id -u)" | sed 's/$/\\n/' | tr -d '\n'; echo -n '"}' ) \
  | curl -s -XPUT \
         -H 'Content-Type: application/json' \
         -H "Authorization: Bearer ${BT}" \
         -d client_id=${CLIENT_ID} \
         -d client_secret=${CLIENT_SECRET} \
         -T - \
         https://localhost:8080/iam/account/me/proxycert
```

The `proxy:generate` OAuth scope is required to access this API. \
Note that this scope is restricted in the default IAM configuration,
i.e. can be assigned to clients only by IAM administrators.

## POST `/iam/proxycert`

Returns a JSON representation of the proxy certificate of the user.

```bash
curl -s -X POST -H "Authorization: Bearer ${BT}" \
  -d client_id=${CLIENT_ID} \
  -d client_secret=${CLIENT_SECRET} \
  -d lifetimeSecs=${PROXY_CERT_LIFETIME_SECS} \
  http://localhost:8080/iam/proxycert
```

The user can request a specific lifetime of the proxy 
that is less than or equal to the maximum lifetime of the proxy itself.

IAM response:

```json
{
  "subject": "CN=2050153474,CN=813462308,CN=John Doe jdoe@infn.it,O=Istituto Nazionale di Fisica Nucleare,C=IT,DC=tcs,DC=terena,DC=org",
  "issuer": "CN=813462308,CN=John Doe jdoe@infn.it,O=Istituto Nazionale di Fisica Nucleare,C=IT,DC=tcs,DC=terena,DC=org",
  "identity": "CN=John Doe jdoe@infn.it,O=Istituto Nazionale di Fisica Nucleare,C=IT,DC=tcs,DC=terena,DC=org",
  "not_after": "1663991299000",
  "certificate_chain": "-----BEGIN CERTIFICATE-----\nMI...lCU=\n-----END CERTIFICATE-----\n"
}
```

Maximum lifetime and key size can by configured in using `proxycert` configuration options `max-lifetime-seconds` and `key-size`.

[RCauth]: http://rcauth.eu/
