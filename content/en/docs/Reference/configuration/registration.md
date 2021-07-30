---
title: "Registration & Enrollment"
linkTitle: "Registration & Enrollment"
weight: 6
---


IAM implements a basic registration service that implements an
administrator-vetted registration flow, where users apply for membership in an
organization and administrators are asked to validate membership requests.

## Requiring external authentication

Starting with version 1.6.0, IAM allows to request that users are authenticated
from a trusted identity provider (SAML or OIDC) in order to apply for
membership. It's also possible to control how information in authentication
tokens and assertions is mapped to IAM registration fields.

For example, see the following fragment that requires authentication with the
CERN SSO and defines how information from identity tokens issued by CERN SSO is
mapped to IAM membership information

```yaml

iam:
  registration:
    require-external-authentication: true
    oidc-issuer: https://auth.cern.ch/auth/realms/cern
    authentication-type: oidc
    fields:
      name:
        read-only: true  # When false, allows user to override what comes from the authentication information
        external-auth-attribute: given_name
      surname:
        read-only: true
        external-auth-attribute: family_name
      email:
        read-only: false
        external-auth-attribute: email
      username:
        read-only: false
        external-auth-attribute: preferred_username
```

## User editable fields

Starting with version 1.6.0, IAM allows to limit which fields of the user profile are editable by users.

The default, backward-compatible settings that allow users to edit all their
profile fields are defined as follows:

```yaml

iam:
  user-profile:
    editable-fields:
      - email
      - name
      - picture
      - surname
```

To prevent modifications to any of the fields remove the field name from
`editable-fields` list.

External configuration can be managed by placing directives as shown above in a
[custom configuration
file](/docs/reference/configuration/#overriding-default-configuration-templates).
