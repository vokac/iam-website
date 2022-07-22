---
title: "Local authentication"
linkTitle: "Local authentication"
weight: 7
---

IAM has the ability to limit or disable
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
    # possible values: hidden, hidden-with-link, visible
    login-page-visibility: hidden 
```
In alternative, one can configure the local authentication settings using environment variables as
described in the [Configuration][conf] section.

When the local authentication (username/password) fields are hidden on the login page, it is possible
to display them by adding the query string `?sll=y` to the login page URL. It may be useful, for
example, to access the `admin` account if only username/password authentication has been configured
for it and if `enable-for` has been set to `vo-admins`.

Note that hiding local authentication on the login page without restricting the category of users
able to use it doesn't really provide additional security.

[conf]: ../#local-authentication-settings