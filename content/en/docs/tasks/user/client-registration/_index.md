---
title: Registering a client
weight: 2
---

IAM exposes the OpenID Connect/OAuth dynamic client registration functionality
offered by the [MitreID OpenID Connect][mitreid] server libraries.

In OAuth terminology, a client is an application or service that can interact
with an authorisation server for authentication/authorization purposes.

A new client can be registered in the IAM in two ways:

- using the [dynamic client registration API][reg-api];
- via the IAM dashboard (which simply acts as a client to the API mentioned
  above).

## Registering a client using the dashboard

Log into the service and click on the _MitreID dashboard_ link on the left
navigation bar:

![Mitre dashboard](../images/mitre-dashboard.png)

From the MitreID dashboard, select _Client registration_:

![Mitre client reg](../images/mitre-client-reg-0.png)

And then click on _New client_:

![Mitre client reg](../images/mitre-client-reg-1.png)

A form will open that enable you to configure your client:

![Mitre client reg](../images/mitre-client-reg-2.png)

The minimum information you have to provide is:

- *client name*: choose a name for your client
- *Redirect URI(s)*: one or more redirect URIs for your client; these are
  required if you choose to enable the authorization code flow;

![Mitre client reg](../images/mitre-client-reg-3.png)

Remember to select the `offline_access` scope from the __Access tab__ if you
want to request refresh tokens for the client being created:

![Mitre client reg](../images/mitre-client-reg-4.png)

You can then click the "Save" button at the bottom of the page:

![Mitre client reg](../images/mitre-client-reg-5.png)

IAM will then generate client credentials for your client and other information
that will be displayed as follows:

![Mitre client reg](../images/mitre-client-reg-6.png)

The JSON tab provides client information in JSON:

![Mitre client reg](../images/mitre-client-reg-8.png)

Select the content of the text area and paste it in a local file, for future
reference.

The JSON file contains the client secret and the registration access token,
which can be used later to change the client configuration or to delete the
client.

[mitreid]: https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/wiki
[reg-api]: {{< ref "/docs/reference/api/oidc-client-registration/" >}}
