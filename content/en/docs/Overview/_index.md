---
title: "Overview"
linkTitle: "Overview"
weight: 1
description: >
  A brief overview of the INDIGO IAM service
---

The INDIGO Identity and Access Management (IAM) Service provides a layer where
identities, enrollment, group membership and other attributes and authorization
policies on distributed resources can be managed in an homogeneous way,
supporting identity federations and other authentication mechanisms (X.509
certificates and social logins).

IAM implements the Virtual Organization (VO) concept, and is the developed by
the same team behind [VOMS][voms].

IAM is the AAI solution chosen to power the next generation [WLCG][wlcg]
Authentication and Authorization infrastructure.

## Functions

* **Flexible authentication**: The IAM supports user authentication via local
  username and password credentials as well as SAML Identity Federations,
  OpenID Connect providers and X.509.
* **Enrollment**: The IAM provides VO enrollment and registration functionalities,
  so that users can join groups/collaborations according to well-defined flows.
* **Attribute and identity management**: The IAM provides services to manage
  group membership, attributes assignment and account linking functionality.
* **User provisioning**: the IAM provides endpoints to provision information
  about users identities to other services, so that consistent local account
  provisioning, for example, can be implemented.

## Integrations

The IAM service has been succesfully integrated with many off-the-shelf
components like Openstack, Kubernetes, Atlassian JIRA and Confluence, Grafana
and with key Grid computing middleware services (e.g., [RUCIO][rucio],
[FTS][fts], [dCache][dcache], [StoRM][storm], [XRootD][xrootd],
[HTCondor][htcondor]).

## Service access options

### IAM as a service 

INFN provides IAM as a service to partner research communities. In this
scenario, a dedicated IAM instance is deployed on the INFN infrastructure and
configured according to the community needs. INFN takes care of keeping the
service operational and up-to-date, while administrative control on the IAM
instance is granted to the community. 

For more information on how to access IAM as a service, click
[here][iam-as-a-service].

### On-premise deployment 

IAM is an Apache-licensed identity solution, for which we provide a Docker
image on dockerhub and RPM and Debian packages.

IAM can be deployed on-premises following the advice in the [Deployment and
administration guide][deployment-guide].

[iam-as-a-service]: /docs/iam-aas/
[deployment-guide]: /docs/administrator-guide/
[rucio]: https://rucio.cern.ch/
[voms]: https://italiangrid.github.io/voms
[wlcg]: https://wlcg.web.cern.ch/
[fts]: https://fts.web.cern.ch/fts/
[xrootd]: https://xrootd.slac.stanford.edu/index.html
[htcondor]: https://research.cs.wisc.edu/htcondor/
[dcache]: https://www.dcache.org/
[storm]: https://italiangrid.github.io/storm
