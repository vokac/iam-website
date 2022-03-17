---
title: "Deploying the IAM VOMS importer"
weight: 140
description: >
  Instructions on how to deploy the IAM VOMS impoter script
---

## VOMS versus importer 

The transition from X.509 to tokens will take time so **IAM was designed to be backward-compatible with our existing infrastructure.**

IAM provides a VOMS endpoint that **can issue VOMS credentials understood by existing clients and libraries**
* VOMS clients $>$= 2.0.16

The [VOMS importer](https://github.com/indigo-iam/voms-importer/) migration script has been developed to import users from VOMS to IAM
* users will **NOT** have to re-register in mass to IAM, and their IAM account will be automagically linked to their CERN account
* the script will keep IAM in sync with the VOMS instances until the VO registration process is migrated to IAM

At some point **IAM will be the only authoritative VOMS server for the infrastructure.**

### The VOMS importer script

Migrate VO structure and users from an existing VOMS VO server:
* VOMS Groups
* VOMS Roles
* VOMS Users
  * Personal information (name, surname, email)
  * X.509 certificates
  * Group and role membership
  * Generic attributes

Requires:
* VOMS Admin v. 3.8.0, IAM $>$= v. 3.7.0
* VOMS proxy with admin privileges on the VOMS VO
* access token with admin privileges on the IAM VO
