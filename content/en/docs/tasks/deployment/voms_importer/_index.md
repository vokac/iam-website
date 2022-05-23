---
title: "Deploying the IAM VOMS importer"
weight: 140
description: >
  Instructions on how to deploy the IAM VOMS importer script
---

## The VOMS-importer script

The [voms importer](https://github.com/indigo-iam/voms-importer/) script is a temporary solution until IAM will take place of VOMS definitely. It imports users from VOMS to IAM at CERN. It is CERN-specific: however, it can be generalized to other sites. The script keeps IAM in sync with the VOMS instances until the VO registration process is migrated to IAM.

The migratition of VO structure and users from an existing VOMS VO server means to consider the following information:
* VOMS Groups
* VOMS Roles
* VOMS Users
  * Personal information (name, surname, email)
  * X.509 certificates
  * Group and role membership
  * Generic attributes

The script needs admininistrative privileges on both VOMS and IAM represented respectively by the VOMS proxy and IAM access token.

### VOMS Groups and roles migration

IAM and VOMS have the same group concept. On the other hand the role concept is different: VOMS has a clear role definition, while in IAM the role is an optional group.

To import groups in IAM, you can turn `/atlas/production` into `atlas/production`. To import roles as IAM optional groups, you have to turn `/atlas/Role=VO-Admin` into `atlas/VO-Admin`.

**Groups and roles are imported only if not already present in IAM.**

### Users migration

Only **active VOMS users** are migrated. You need to keep in mind that **a user, suspended by a VO Admin in VOMS, may not be also suspended in IAM.** Since IAM is also integrated with the Human Resource (HR) database, the HR check will ensure that users are suspended/removed from the VO when experiment membership is no longer valid.

The importer script generates a username for the IAM account (i.e., VOMS accounts did not have username), which corresponds to the CERN username.

### CERN SSO automatic linking

The importer script can be configured to automatically link the imported account to the CERN SSO identity in two ways: 
1. using the nickname VOMS account generic attribute
2. resolving the CERN username from the CERN LDAP

Currently CMS and ATLAS both use the LDAP strategy. 

### Unique email address for users in IAM

VOMS allowed different users to share the email address. Instead IAM requires unique email address for users. 

The import script implements an email override mechanism (currently deployed for ATLAS) but the best strategy is to clean up the VOMS database in order to avoid multiple accounts sharing email addresses.

### VOMS importer log

The importer script produces a detailed log. 
