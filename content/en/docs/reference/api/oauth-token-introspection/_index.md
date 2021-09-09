---
title: "OAuth token introspection API"
linkTitle: "OAuth token introspection API"
---

IAM, through the [MitreID OpenID Connect server implementation][mitreid],
supports the [OAuth token introspection API][oauth-token-introspection] API at
the `/introspect` endpoint.

The `/introspect` endpoint __requires__ client authentication.

[mitreid]: https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/wiki
[oauth-token-introspection]: https://tools.ietf.org/html/rfc7662
