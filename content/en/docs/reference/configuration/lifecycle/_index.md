---
title: "Membership lifecycle"
linkTitle: "Membership lifecycle"
weight: 5
---

Starting with version 1.6.0, IAM introduces support for basic account life
cycle management.

It's now possible to set an expiration time for IAM accounts. Once the account
expires, login for the account is disabled.

IAM can be configured to remove expired accounts after a configurable grace
period.

## Account end time settings

By default, accounts in IAM do not have an end time set, i.e. the lifetime is
unbounded.

A default account validity period (e.g., 12 months) can be configured and will
be set for users at registration time.

The relevant settings are managed  by placing `lifecycle` directives in a
[custom configuration
file][custom-config-file]:

```yaml
lifecycle:
  account:
    # 0 means unbounded validity
    account-lifetime-days: 0
    # When true, the end time cannot be changed from IAM APIs and dashboard
    read-only-end-time: false
    expired-account-policy:
      # Accounts will be suspended after 7 days since expiration
      suspension-grace-period-days: 7
      # When false, expired accounts are not removed
      remove-expired-accounts: true
      # Accounts will be removed after 30 days since expiration
      # (if remove-expired-accounts is true)
      removal-grace-period-days: 30
    expired-accounts-task:
      # Internal cron schedule for the lifecycle task.
      # Default setting is every 5 mins
      cron-schedule:  0 */5 * * * *
      # To disable automatic account expiration set this to false
      enabled: true
```


[custom-config-file]: {{< ref "/docs/reference/configuration/#overriding-default-configuration-templates" >}}
