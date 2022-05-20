---
title: "Deploying the IAM VOMS importer"
weight: 140
description: >
  Instructions on how to deploy the IAM VOMS importer script
---

## VOMS versus importer 

The transition from X.509 to tokens takes time, therefore **IAM was designed to be backward-compatible with our existing infrastructure.** 

IAM provides a VOMS endpoint that **can issue VOMS credentials understood by existing clients and libraries**.
* VOMS clients $>$= 2.0.16

The [VOMS importer](https://github.com/indigo-iam/voms-importer/) migration script has been developed to import users from VOMS to IAM:
* users will **NOT** have to re-register in mass to IAM, and their IAM account will be automagically linked to their CERN account;
* the script will keep IAM in sync with the VOMS instances until the VO registration process is migrated to IAM.

At some point **IAM will be the only authoritative VOMS server for the infrastructure**.

### The VOMS importer script

The migratition of VO structure and users from an existing VOMS VO server means to consider the following information:
* VOMS Groups
* VOMS Roles
* VOMS Users
  * Personal information (name, surname, email)
  * X.509 certificates
  * Group and role membership
  * Generic attributes

The script requires:
* VOMS Admin v. 3.8.0, IAM $>$= v. 1.7.0
* VOMS proxy with admin privileges on the VOMS VO
* access token with admin privileges on the IAM VO

### VOMS Groups and roles migration

To import groups in IAM:
* /atlas/production -> atlas/production

To import roles as IAM optional groups:
* /atlas/Role=VO-Admin -> atlas/VO-Admin

**Groups and roles are imported only if not already present in IAM.**

### Users migration

Only **active VOMS users** are migrated. Furthermore, do not expect that a user suspended by a VO Admin in VOMS is suspended also in IAM:
* since IAM is also integrated with the HR db, the HR check will ensure users are suspended/removed from the VO when experiment membership is no longer valid.

The importer script generates a username for the IAM account (i.e., VOMS accounts did not have username): currently `user.<voms userid>`, there is the plan to use CERN username instead.

### CERN SSO automatic linking

The importer script can be configured to automatically link the imported account to the CERN SSO identity in two ways:
1. using the nickname VOMS account generic attribute
2. resolving the CERN username from the CERN LDAP

Currently CMS and ATLAS both use the LDAP strategy. Below it is reported the `ldapsearch` command to resolve the CERN username:

```sh
ldapsearch -x -h xldap.cern.ch -b "DC=cern,DC=ch" "(&(employeeID=773231)(employeeType=Primary))" cn | grep "^cn:" | sed "s/cn: //“

hshort
```

### Unique email address for users in IAM

VOMS allowed different users to share the email address. Instead IAM requires unique email address for users. 

The import script implements an email override mechanism (currently deployed for ATLAS) but the best strategy is to clean up the VOMS database in order to avoid multiple accounts sharing email addresses.
* Use dedicated service account email addresses for service accounts.

### VOMS importer log

The importer script produces a detailed log. Below it is reported a portion of VOMS importer log:

```sh
2021-12-14 00:17:19,203 INFO : Importing VOMS user: 3993 - JOHN DOE
2021-12-14 00:17:19,299 WARNING : IAM account found matching VOMS user 3993 - JOHN DOE email: john.doe@cern.ch. Will import information on that account
2021-12-14 00:17:19,299 INFO : Syncing group/role membership for user doe (2154da73-dc7f-4248-8805-be8a184b5dc2)
2021-12-14 00:17:19,299 INFO : Importing doe (2154da73-dc7f-4248-8805-be8a184b5dc2) membership in VOMS FQAN: /atlas
2021-12-14 00:17:19,422 INFO : Importing doe (2154da73-dc7f-4248-8805-be8a184b5dc2) membership in VOMS FQAN: /atlas/Role=production
2021-12-14 00:17:19,484 INFO : Importing doe (2154da73-dc7f-4248-8805-be8a184b5dc2) membership in VOMS FQAN: /atlas/alarm
2021-12-14 00:17:19,546 INFO : Importing doe (2154da73-dc7f-4248-8805-be8a184b5dc2) membership in VOMS FQAN: /atlas/cz
2021-12-14 00:17:19,605 INFO : Importing doe (2154da73-dc7f-4248-8805-be8a184b5dc2) membership in VOMS FQAN: /atlas/cz/Role=production
2021-12-14 00:17:19,667 INFO : Importing doe (2154da73-dc7f-4248-8805-be8a184b5dc2) membership in VOMS FQAN: /atlas/team
2021-12-14 00:17:19,732 INFO : Syncing generic attributes for user doe (2154da73-dc7f-4248-8805-be8a184b5dc2)
2021-12-14 00:17:19,788 INFO : Importing certificate {u'suspended': False, u'creationTime': u'
2015-11-27T11:31:18', u'subjectString': u'/DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=doe/CN=616161/CN=John Doe', u'issuerString': u'/DC=ch/DC=cern/CN=CERN Grid Certification Authority'} for user doe (2154da73-dc7f-4248-8805-be8a184b5dc2)
2021-12-14 00:17:19,800 INFO : Converted certificate info: 'CN=John Doe,CN=616161,CN=doe,OU=Users,OU=Organic Units,DC=cern,DC=ch', 'CN=CERN Grid Certification Authority,DC=cern,DC=ch'
2021-12-14 00:17:19,848 INFO : Importing certificate {u'suspended': False, u'creationTime': u'2016-08-13T08:16:45', u'subjectString': u'/DC=org/DC=terena/DC=tcs/C=CZ/O=Czech Technical University in Prague/CN=John Doe 252525', u'issuerString': u'/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience Personal CA 3'} for user doe (2154da73-dc7f-4248-8805-be8a184b5dc2)
2021-12-14 00:17:19,861 INFO : Converted certificate info: 'CN=John Doe 252525,O=Czech Technical University in Prague,C=CZ,DC=tcs,DC=terena,DC=org', 'CN=TERENA eScience Personal CA 3,O=TERENA,L=Amsterdam,ST=Noord-Holland,C=NL'
2021-12-14 00:17:19,909 INFO : Linking user doe (2154da73-dc7f-4248-8805-be8a184b5dc2) to CERN person id 616161
2021-12-14 00:17:19,966 INFO : CERN login resolved via LDAP: personId 616161 => doe
2021-12-14 00:17:19,966 INFO : Linking user vokac to CERN SSO account {'subject': 'doe', 'issuer': 'https://auth.cern.ch/auth/realms/cern'}
```
