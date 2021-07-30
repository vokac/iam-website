---
title: "Group requests API"
linkTitle: "Group requests API"
---


IAM Login Service provides a RESTful API to create and manage group membership requests.

## POST /iam/group_requests

Create a new group membership request.
The body of the request must contain a JSON with the group name and a motivation
of the submitted request.

**Authentication required**: true

### Success response

**Conditions**:

- The user is authenticated;
- the user is not already member of the requested group;
- a request from the user for such group does not exist.

**Code**: `200 Ok`

**Content**: A JSON representation of the new request.

### Error response

**Condition**: The user is not authenticated.

**Code**: `401 Unauthorized`

**Content**: A JSON with the error description.

```json
{
    "error" : "unauthorized",
    "error_description" : "Full authentication is required to access this resource"
}
```

**Condition**: The request already exists.

**Code**: `400 Bad Request`

**Content**: A JSON with the error description.

```json
{
    "error": "Group membership request already exist for [test, Test-001]"
}
```

#### Example

Request:

```http
POST /iam/group_requests HTTP/1.1
Host: iam.local.io
Content-Type: application/json
Cache-Control: no-cache

{
    "groupName":"Test-001",
    "notes":"Test API"
}
```

Response:
```json
{
    "uuid": "d5b652b2-4bb5-401a-bfb9-a795353798b3",
    "username": "test",
    "status": "PENDING",
    "notes": "Test API",
    "groupName": "Test-001",
    "creationTime": 1524233011676
}
```

## GET /iam/group_requests

Returns a paginated list of group requests.
The list can be filtered by username, group name or request status.
Users with administrative privileges can list all requests;
other users only the requests they submitted.

**Authentication required**: true

### Success response

**Condition**: The user is authenticated.

**Code**: `200 Ok`

**Content**: A JSON representation of the request list.

### Error response

**Condition**: The user is not autheticated.

**Code**: `401 Unauthorized`

**Content**: A JSON with an error message representation.

```json
{
    "error": "unauthorized",
    "error_description": "Full authentication is required to access this resource"
}
```

#### Example

Request:

```http
GET /iam/group_requests/?groupName=Test-001&status=PENDING HTTP/1.1
Host: iam.local.io
Content-Type: application/json
Cache-Control: no-cache

```

Response:

```json
{
    "Resources": [
        {
            "uuid": "d5b652b2-4bb5-401a-bfb9-a795353798b3",
            "username": "test",
            "status": "PENDING",
            "notes": "Test API",
            "groupName": "Test-001",
            "creationTime": 1524233011000,
            "lastUpdateTime": 1524233012000
        },
        {
            "uuid": "b28790d4-90d4-471f-8b85-79d5fd761b8c",
            "username": "test_100",
            "status": "PENDING",
            "notes": "Test API",
            "groupName": "Test-001",
            "creationTime": 1524237532000,
            "lastUpdateTime": 1524237532000
        }
    ],
    "totalResults": 2,
    "startIndex": 1,
    "itemsPerPage": 2
}
```

## GET /iam/group_requests/{uuid}

Returns the details about a group request.

**Authentication required**: true

### Success response

**Condition**: The user is authenticated and can access the request
(privileged users can access all request, other users only the requests they submitted).

**Code**: `200 Ok`

**Content**: The JSON representation of the group membership request.

### Error response

**Condition**: The user is not authenticated.

**Code**: `401 Unauthorized`

**Content**: 
```json
{
    "error": "unauthorized",
    "error_description": "Full authentication is required to access this resource"
}
```

**Condition**: User is not authorized to access the group request.

**Code**: `403 Forbidden`

**Content**:
```http
Access is denied
```

**Condition**: A request linked to the given id does not exist.

**Code**: `400 Bad request`

**Content**: 
```json
{
    "error": "Group request with UUID [d5b652b2-4bb5-401a] does not exist"
}
```

#### Example

Request:
```http
GET /iam/group_requests/d5b652b2-4bb5-401a-bfb9-a795353798b3 HTTP/1.1
Host: iam.local.io
Content-Type: application/json
Cache-Control: no-cache
```

Response:
```json
{
    "uuid": "d5b652b2-4bb5-401a-bfb9-a795353798b3",
    "username": "test",
    "status": "PENDING",
    "notes": "Test API",
    "groupName": "Test-001",
    "creationTime": 1524233011000,
    "lastUpdateTime": 1524233012000
}
```

## DELETE /iam/group_requests/{uuid}

Deletes a group request.
Administrators can delete any request, users can only delete the `PENDING` requests
they previously submitted.

**Authentication required**: true

### Success response

**Condition**: A request linked to the given id exists.

**Code**: `204 No Content`

**Content**: Empty body

### Error response

**Condition**: A request linked to the given id does not exist.

**Code**: `400 Bad Request`

**Content**: A JSON with an error message representation.

```json
{
    "error": "Group request with UUID [b28790d4-90d4-471f-8b85-79d5fd761b8c] does not exist"
}
```

#### Example

Request:

```http
DELETE /iam/group_requests/b28790d4-90d4-471f-8b85-79d5fd761b8c HTTP/1.1
Host: iam.local.io
Content-Type: application/json
Cache-Control: no-cache
```

## POST /iam/group_requests/{uuid}/approve

Approves a group request.
Only administrators can approve requests.

**Authentication required**: true

### Success response

**Condition**:

- The user is authenticated and has administrative privileges;
- the request is in `PENDING` status.

**Code**: `200 Ok`

**Content**: The JSON representation of the updated group membership request.

### Error response

**Condition**: 

- The request doesn't exist;
- The request isn't in `PENDING` status.

**Code**: `400 Bad Request`

**Content**: A JSON with an error message representation.

```json
{
    "error": "Group request with UUID [b28790d4-90d4-471f-8b85-79d5fd761b8c] does not exist"
}
```
```json
{
    "error": "Invalid group request transition: APPROVED -> APPROVED"
}
```

#### Example

Request:
```http
POST /iam/group_requests/d5b652b2-4bb5-401a-bfb9-a795353798b3/approve HTTP/1.1
Host: iam.local.io
Content-Type: application/json
Cache-Control: no-cache
```

Response:
```json
{
    "uuid": "d5b652b2-4bb5-401a-bfb9-a795353798b3",
    "username": "test",
    "status": "APPROVED",
    "notes": "Test API",
    "groupName": "Test-001",
    "creationTime": 1524233011000,
    "lastUpdateTime": 1524238898590
}
```

## POST /iam/group_requests/{uuid}/reject

Rejects a group request.
A `motivation` parameter is required.
Only administrators can reject requests.

**Authentication required**: true

### Success response

**Condition**:

- The user is authenticated and has administrative privileges;
- the request is in `PENDING` status.

**Code**: `200 Ok`

**Content**: The JSON representation of the updated group membership request.

### Error response

**Condition**:

- The request doesn't exist;
- The request isn't in `PENDING` status;
- The motivation required request parameter is missing.

**Code**: `400 Bad Request`

**Content**: A JSON with an error message representation.

```json
{
    "error": "Invalid group request transition: APPROVED -> REJECTED"
}
```
```json
{
    "error": "Group request with UUID [d5b652b2-4bb5-401a-bfb9-a79535379b3] does not exist"
}
```

#### Example

Request:
```http
POST /iam/group_requests/b28790d4-90d4-471f-8b85-79d5fd761b8c/reject?motivation=Test API HTTP/1.1
Host: iam.local.io
Content-Type: application/json
Cache-Control: no-cache
```

Response:
```json
{
    "uuid": "b28790d4-90d4-471f-8b85-79d5fd761b8c",
    "username": "test_100",
    "status": "REJECTED",
    "notes": "Test API",
    "motivation": "Test API",
    "groupName": "Test-001",
    "creationTime": 1524237532000,
    "lastUpdateTime": 1524238811254
}
```
