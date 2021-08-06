---
title: Token exchange policy API
---

The Token exchange policy API allows to define fine-grained policies to
control:

- which clients can be involved in a token exchange, and
- which scopes can be exchanged.

## Token exchange policies

By default IAM comes with a permissive default token exchange policy:

```json
{
    "id": 2,
    "description": "Allow all exchanges",
    "creationTime": "2021-08-05T14:38:52.000+02:00",
    "lastUpdateTime": "2021-08-05T14:38:52.000+02:00",
    "rule": "PERMIT",
    "originClient": {
      "type": "ANY"
    },
    "destinationClient": {
      "type": "ANY"
    }
}
```

The policy above will allow exchanges among all clients that have the token
exchange grant type enabled.

As can be seen by the above example a token exchange policy specifies:

- a rule, which can be `PERMIT` or `DENY`, which determines the policy
  behaviour
- an origin client selector: this selector will match the client linked to the
  access token presented during the token exchange; in this case, the selector
  will match ANY client. 
- a destination client selector: this selector will match the destination
  client, i.e. the client requesting the token exchange; in this case, the
  selector will match ANY client.

The policy above does not specify any scope policy, which basically means that
all scopes allowed by the origin and destination client configurations could be
exchanged among the clients.


Let's see a policy which limits the scopes exchanged:

```json
{
    "id": 3,
    "description": "Allow exchanges for openid and offline_access scopes for client token-exchange-actor",
    "creationTime": "2021-08-05T14:46:58.000+02:00",
    "lastUpdateTime": "2021-08-05T14:46:58.000+02:00",
    "rule": "PERMIT",
    "originClient": {
      "type": "ANY"
    },
    "destinationClient": {
      "type": "BY_ID",
      "matchParam": "token-exchange-actor"
    },
    "scopePolicies": [
      {
        "rule": "PERMIT",
        "type": "EQ",
        "matchParam": "openid"
      },
      {
        "rule": "PERMIT",
        "type": "EQ",
        "matchParam": "offline_access"
      }
    ]
}
```

The policy above allows all exchanges for the scopes openid and offline_access
between any origin client and the `token-exchange-actor` client. We see a new
type of client selector, which is used to target the policy to a specific
client selected by clientId.

We see that the policy provides a list of scope policies, which allow exchange
only for the `openid` and `offline_access` scopes. 

### Client selectors

IAM currently supports three client selector types:

- `ANY`: which will match any client 
- `BY_SCOPE`: which will match any client that is authorized to request a scope
  passed as a parameter
- `BY_ID`: which will a client by clientId

```json
  ...
    "originClient": {
      "type": "BY_ID",
      "matchParam": "origin-client"
    },
    "destinationClient": {
      "type": "BY_SCOPE",
      "matchParam": "storage.write:/"
    },
  ...
```

For example, the policy fragment above would apply to any token exchange
started by a client allowed to request the `storage.write:/` scope when
exchanging a token issued to `origin-client`.

### Token exchange scope policies

Token exchange scope policies (not to be confused with [Scope
policies][scope-policies]) define which scopes are authorized or blocked in a
token exchange policy. When scope policies are not defined in an exchange
policy, the meaning is that all scopes allowed by the origin and destination
client configurations are allowed for an exchange.

A scope policy defines:
- a `rule`, which can be `PERMIT` or `DENY`
- a `type`, where allowed values are `EQ`, `REGEXP`, `PATH` which identifies the matching algorithm used to match the exchanged scope
- a `matchParam`, which specifies the scope to be matched

For example:

```json
    "scopePolicies": [
      {
        "rule": "PERMIT",
        "type": "REGEXP",
        "matchParam": "compute.*"
      },
      {
        "rule": "DENY",
        "type": "REGEXP",
        "matchParam": "storage.*"
      }
    ]
```

The two scope policies above combined will allow any exchange of scopes that
would match the regular expression `compute.*` and will block exchanges of
scopes matching regular expression `storage.*`.
Important scope policy evaulation rules:

- Token exchange scope policies are applied to all the scopes requested in a
  token exchange, i.e. a policy allowing each requested scope must be present
  for the token exchange to succeed.

- When multiple scope policies apply to a given scope, `DENY` policies win.

- When scope policies are defined, a `PERMIT` policy should always be included,
  otherwise any exchange would be blocked. If that is the intended behaviour,
  simply use a `DENY` token exchange policy.

- When a requested scope is not authorized, either due to a `DENY` scope policy
  or a missing `PERMIT` policy, the exchange fails with an `invalid_scope`
  error. 

- Defining scope policies in a `DENY` token exchange policy is redundant (the
  evaluation would block at client level) and would not make sense.


## Token exchange policy ranking

The engine that evaluates token exchange policies implements a policy ranking
algorithm to determine which policy should be applied for an exchange. As with
[scope policies][scope-policies], the ranking algorithm is based on how
specific the policies are for the input origin and destination clients in a
token exchange.

As we have seen, origin and destination clients can be matched in three ways:
- using the `ANY` selector, i.e. matching any client
- using the `BY_SCOPE` selector, i.e., matching any client that can request a
  given scope
- using the `BY_ID` selector, i.e. matching clients by `clientId`

We link a *rank*, which is an integer value, to each of the selector to
represent the selector specificity. The rank of the selectors are given in the
following table:

|**Client selector**|**Rank**|
|-----------------|------|
| `ANY` | 0 |
| `BY_SCOPE` | 1|
| `BY_ID` | 2 |

The rank of a policy `P` is computed as the sum of rank of the origin and
destination client selectors:

```
rank(P) = rank(origin) + rank(destination)
```

At the same rank, DENY policies will win.
Let's assume we have two exchange policies defined:

```json
[
  {
      "id": 2,
      "description": "All all exchanges just for the openid scope",
      "creationTime": "2021-08-05T14:38:52.000+02:00",
      "lastUpdateTime": "2021-08-05T14:38:52.000+02:00",
      "rule": "PERMIT",
      "originClient": {
        "type": "ANY"
      },
      "destinationClient": {
        "type": "ANY"
      },
      "scopePolicies": [
        {
          "rule": "PERMIT",
          "type": "EQ",
          "matchParam": "openid"
        }
      ]
  },
  {
      "id": 3,
      "description": "Allow any exchange among clients A and B",
      "creationTime": "2021-08-05T14:38:52.000+02:00",
      "lastUpdateTime": "2021-08-05T14:38:52.000+02:00",
      "rule": "PERMIT",
      "originClient": {
        "type": "BY_ID",
        "matchParam": "A"
      },
      "destinationClient": {
        "type": "BY_ID",
        "matchParam": "B"
      }
  }
]
```

Also let's assume client `B` requests a token exchange for scopes `openid
storage.read:/` presenting an access token issued to client `A`.

IAM would cycle through the exchange policies and select the ones that would
apply to the exchange, in this case both policy `2` and `3`.

Then IAM would rank the policy according to the specificity of the client
selectors, which would be 

```
rank(p_2)=0
rank(p_3)=4
```

so policy `3` would be selected, which would allow the exchange.





[scope-policies]: /docs/reference/api/scope-policy-api/#scope-policies
