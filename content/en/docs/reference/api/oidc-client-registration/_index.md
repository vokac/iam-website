---
title: OpenID Connect client registration API
---

IAM, through the [MitreID OpenID Connect server implementation][mitreid],
supports the [OpenID Connect Dynamic Client Registration
API][oidc-dynclientreg] API at the `/register` endpoint.

Client registration does not require authentication.

## Example: registering and deleting a client from the command line

With the following template JSON you can easily register a client in the IAM:

```json
{
  "redirect_uris": [
    "https://another.client.example/oidc"
  ],
  "client_name": "another-example-client",
  "contacts": [
    "test@iam.test"
  ],
  "token_endpoint_auth_method": "client_secret_basic",
  "scope": "address phone openid email profile offline_access",
  "grant_types": [
    "refresh_token",
    "authorization_code"
  ],
  "response_types": [
    "code"
  ]
}
```

Save the above JSON into a file (after changing the relevant fields, like
contact, rediret_uris, etc...). We will use the `client-req.json` file name for
this example. You can then use [httpie][httpie] as  follows to generate the
client on the IAM

```
http https://iam.local.io/register < client-req.json > client.json
```

If the command terminates correctly, you will have the client configuration
saved in the `client.json` file. You can use [jq][jq] to display in a pretty
way its contents:

```
$ jq . client.json
{
  "client_id": "4b2556d7-65c5-4a15-81c0-7b80c604940e",
  "client_secret": "R4u3v-SUqKX1XTFQbGGr-S5qcOAA8JrLT0xAOHYZl1Up65ChHYNsl-8y6gv7qJLaxVI5Z6UXBmSkwSDZLtAAWw",
  "client_secret_expires_at": 0,
  "client_id_issued_at": 1507223860,
  "registration_access_token": "eyJraWQiOiJyc2ExIiwiYWxnIjoiUlMyNTYifQ.eyJhdWQiOiI0YjI1NTZkNy02NWM1LTRhMTUtODFjMC03YjgwYzYwNDk0MGUiLCJpc3MiOiJodHRwczpcL1wvaWFtLmxvY2FsLmlvXC8iLCJpYXQiOjE1MDcyMjM4NjAsImp0aSI6IjRmNTQ2YmEyLWE3ZWEtNDA4ZC1iYWI1LTdlZGMyNDZlOWJhMiJ9.Iyr7fwKy3OSl3wVjaw5HVVxBFl62A-vDlrKJpJA2W2t1GmPMcz5ZZOhp9PStd2RbMpuu6WwVhhDMN706IOzk03dGD3wPy_ag2MaiJfdT0-AT2nMviuPNylgU4bK0wFs9r9cwxBI0PpJ5pkkQE__z_lfWHylKMf9mLrZp81WUvt8",
  "registration_client_uri": "https://iam.local.io/register/4b2556d7-65c5-4a15-81c0-7b80c604940e",
  "redirect_uris": [
    "https://another.client.example/oidc"
  ],
  "client_name": "another-example-client",
  "contacts": [
    "test@iam.test"
  ],
  "token_endpoint_auth_method": "client_secret_basic",
  "scope": "address phone openid email profile offline_access",
  "grant_types": [
    "refresh_token",
    "authorization_code"
  ],
  "response_types": [
    "code"
  ]
}
```

and also to extract information from it conveniently from the command line.
For example, you can extract the `client_id` and `registration_access_token`
with the following commands:

```
$ export CID=$(jq -r .client_id client.json)
$ export RAT=$(jq -r .registration_access_token client.json)
```

and use them to delete the client:

```
$ http DELETE https://iam.local.io/register/${CID} Authorization:"Bearer ${RAT}"
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: *
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Connection: keep-alive
Content-Language: en-US
Date: Thu, 05 Oct 2017 17:10:42 GMT
Expires: 0
Pragma: no-cache
Server: nginx/1.13.1
Strict-Transport-Security: max-age=31536000 ; includeSubDomains
X-Application-Context: INDIGO IAM:mysql,google,registration,saml,mysql-test:8080
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
```



[oidc-dynclientreg]: https://openid.net/specs/openid-connect-registration-1_0.html
[mitreid]: https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/wiki
[jq]: https://stedolan.github.io/jq/
[httpie]: https://httpie.org/
