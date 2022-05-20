---
title: "IAM Test Client application"
weight: 2
description: >
   OpenID Connect client application example
---

IAM Test Client is a simple web application that demonstrates the use of the OpenID Connect client code and configuration.

It lives at `https://your-IAM-instance/iam-test-client`.

![Test Client App](images/test-client.png)

Since Test Client uses OAuth Authorization Code Grant Type, after a successfull login you will be redirected to the consent page that the authorization server displays to confirm if the requested scopes can be shared with the client. 

![Consent Page](images/consent-page.png)

If you authorize, the following information will be shown:

![App info](images/test-client-info.png)

In order to run the Test Client application you need to setup a minimal [configuration]({{< ref "/docs/reference/configuration/#test-client-configuration" >}}).
