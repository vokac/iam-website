---
title: "Local authentication"
linkTitle: "Local authentication"
weight: 7
---

Starting with version 1.6.0, IAM introduces the ability to limit or disable
authentication with local IAM credentials, so that external, brokered
authentication is required.

It's possible to hide the local login form from the IAM login page and also to
control for which users local authentication is enabled (all users,
VO administrators, no users).

```yaml
iam:
  local-authn:
    # possible values for enabled-for: all, vo-admins, none
    enabled-for: vo-admins 
    # possible values: hidden, visible
    login-page-visibility: hidden 
```

Local authentication settings are configured providing a custom configuration
file, as described
[here](/docs/reference/configuration/#overriding-default-configuration-templates).
