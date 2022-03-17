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
* VOMS Admin v. 3.8.0, IAM $>$= v. 1.7.0
* VOMS proxy with admin privileges on the VOMS VO
* access token with admin privileges on the IAM VO

### VOMS Groups and roles migration

Groups imported in IAM
* /atlas/production -> atlas/production

Roles are imported as IAM optional groups
* /atlas/Role=VO-Admin -> atlas/VO-Admin

Groups and roles are imported only if not already present in IAM.

### Users migration

Only **active VOMS users** are migrated
* do not expect that a user suspended by a VO Admin in VOMS is suspended also in IAM
* since IAM is also integrated with the HR db, the HR check will ensure users are suspended/removed from the VO when experiment membership is no longer valid

The importer script generates a username for the IAM account (VOMS accounts didn’t have username)
* currently `user.<voms userid>`, plan to use CERN username instead

### CERN SSO automatic linking

The importer script can be configured to automatically link the imported account to the CERN SSO identity in two ways:
* using the nickname VOMS account generic attribute
* resolving the CERN username from the CERN LDAP

Currently CMS and ATLAS both use the LDAP strategy.

```sh
ldapsearch -x -h xldap.cern.ch -b "DC=cern,DC=ch" "(&(employeeID=773231)(employeeType=Primary))" cn | grep "^cn:" | sed "s/cn: //“

hshort
```

### IAM requires unique email address for users

While VOMS allowed different users to share the email address.

The import script implements an email override mechanism (currently deployed for ATLAS) but the best strategy is to clean up the VOMS database in order to avoid multiple accounts sharing email addresses
* Use dedicated service account email addresses for service accounts

### VOMS importer log

The importer script produces a detailed log:

```sh
2021-12-14 00:17:19,203 INFO : Importing VOMS user: 3093 - PETR VOKAC
2021-12-14 00:17:19,299 WARNING : IAM account found matching VOMS user 3093 - PETR VOKAC email: petr.vokac@cern.ch. Will import information on that account
2021-12-14 00:17:19,299 INFO : Syncing group/role membership for user vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8)
2021-12-14 00:17:19,299 INFO : Importing vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) membership in VOMS FQAN: /atlas
2021-12-14 00:17:19,422 INFO : Importing vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) membership in VOMS FQAN: /atlas/Role=production
2021-12-14 00:17:19,484 INFO : Importing vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) membership in VOMS FQAN: /atlas/alarm
2021-12-14 00:17:19,546 INFO : Importing vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) membership in VOMS FQAN: /atlas/cz
2021-12-14 00:17:19,605 INFO : Importing vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) membership in VOMS FQAN: /atlas/cz/Role=production
2021-12-14 00:17:19,667 INFO : Importing vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) membership in VOMS FQAN: /atlas/team
2021-12-14 00:17:19,732 INFO : Syncing generic attributes for user vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8)
2021-12-14 00:17:19,788 INFO : Importing certificate {u'suspended': False, u'creationTime': u'
2015-11-27T11:31:18', u'subjectString': u'/DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=vokac/CN=610071/CN=Petr Vokac', u'issuerString': u'/DC=ch/DC=cern/CN=CERN Grid Certification Authority'} for user vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8)
2021-12-14 00:17:19,800 INFO : Converted certificate info: 'CN=Petr Vokac,CN=610071,CN=vokac,OU=Users,OU=Organic Units,DC=cern,DC=ch', 'CN=CERN Grid Certification Authority,DC=cern,DC=ch'
2021-12-14 00:17:19,848 INFO : Importing certificate {u'suspended': False, u'creationTime': u'2016-08-13T08:16:45', u'subjectString': u'/DC=org/DC=terena/DC=tcs/C=CZ/O=Czech Technical University in Prague/CN=Petr Vokac 252509', u'issuerString': u'/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience Personal CA 3'} for user vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8)
2021-12-14 00:17:19,861 INFO : Converted certificate info: 'CN=Petr Vokac 252509,O=Czech Technical University in Prague,C=CZ,DC=tcs,DC=terena,DC=org', 'CN=TERENA eScience Personal CA 3,O=TERENA,L=Amsterdam,ST=Noord-Holland,C=NL'
2021-12-14 00:17:19,909 INFO : Linking user vokac (b0096aea-4eda-4d58-89bc-4c1880e78cb8) to CERN person id 610071
2021-12-14 00:17:19,966 INFO : CERN login resolved via LDAP: personId 610071 => vokac
2021-12-14 00:17:19,966 INFO : Linking user vokac to CERN SSO account {'subject': 'vokac', 'issuer': 'https://auth.cern.ch/auth/realms/cern'}
```
