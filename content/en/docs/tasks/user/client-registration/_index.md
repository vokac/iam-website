---
title: Registering a client
weight: 2
---

IAM exposes the OpenID Connect/OAuth dynamic client registration functionality
on its dashboard's main page (it has been migrated by dashboard).

In OAuth terminology, a client is an application or service that can interact
with an authorisation server for authentication/authorization purposes.

A new client can be registered in the IAM in two ways:

- using the [dynamic client registration API][reg-api];
- via the IAM dashboard (which simply acts as a client to the API mentioned
  above).

## Registering a client using the dashboard

Log into the service and click on the _My Clients_ link on the left
navigation bar:

![dashboard](../images/my_client-dashboard.png)

From the _My client_ link, select _New client_:

![client reg](../images/new-client-reg-0.png)

A form will open that enable you to configure your client:

![client reg](../images/new-client-reg-1.png)

The minimum information you have to provide is:

- *client name*: choose a name for your client
- *Redirect URI(s)*: one or more redirect URIs for your client; these are
  required if you choose to enable the authorization code flow;

![client reg](../images/new-client-reg-2.png)

Remember to select the `offline_access` scope from the __Scopes tab__ if you
want to request refresh tokens for the client being created:

![client reg](../images/new-client-reg-3.png)

You can then click the __Save__ button at the bottom of the page:

![client reg](../images/new-client-reg-4.png)

IAM will then generate client credentials for your client and other information
that will be displayed as follows:

![client reg](../images/new-client-reg-5.png)

The JSON will look like this:

![client reg](../images/new-client-reg-7.png)

![client reg](../images/new-client-reg-8.png)


It is reconmended to save this JSON in a local file for future reference

The client secret and the registration access token, can be used later to change the client configuration, to delete the client and also to redeem a client

[mitreid]: https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/wiki
[reg-api]: {{< ref "/docs/reference/api/oidc-client-registration/" >}}
