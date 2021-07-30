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
file](/docs/reference/configuration/#overriding-default-configuration-templates):

```yaml
lifecycle:
  account:
    account-lifetime-days: 365  ## 0 means unbounded validity
    read-only-end-time: false  ## When true, the end time cannot be changed from IAM APIs and dashboard
    expired-account-policy:
      suspension-grace-period-days: 7 ## Accounts will be suspended after 7 days since expiration
      remove-expired-accounts: false ## When false, expired accounts are not removed
      removal-grace-period-days: 30 ## Accounts will be removed after 30 days since expiration (if remove-expired-accounts is true)
    expired-accounts-task:
      cron-schedule:  0 */5 * * * *  ## spring cron schedule for the lifecycle task (default setting is every 5 mins)
      enabled: true ## To disable automatic account expiration set this to false
```
