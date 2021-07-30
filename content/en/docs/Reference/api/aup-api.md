---
title: "AUP management API"
linkTitle: "AUP management API"
weight: 1
---

IAM provides a RESTful API that can be used to manage the IAM
Acceptable Usage Policy (AUP) configuration.

### GET /iam/aup 

Returns a JSON representation of the Acceptable Usage Policy (AUP) for the
organization. 

**Authentication required**: no

#### Success response

**Condition**: The AUP is defined for the organization

**Code**: `200 OK`

**Content**: A JSON representation of the AUP

```json
{
  "url": "http://somehost.example.org/aup",
  "text": "This is my AUP text",
  "description": null,
  "signatureValidityInDays": 365,
  "creationTime": "2018-02-27T07:26:21.000+01:00",
  "lastUpdateTime": "2018-02-27T07:26:21.000+01:00"
}
```

Note: `text` is returned for backward compatible calls.

#### Error response

**Condition**: The AUP is not defined for the organization

**Code**: `404 NOT FOUND`

**Content**: 

```json
{
  "error":"AUP is not defined for this organization"
}
```

### POST /iam/aup

Creates the AUP for the organization

**Authentication required**: yes

**Authorization required**: ROLE\_ADMIN

**Data constraints**

Provide a representation of the AUP to be created

```json
{
  "url": [url, not blank],
  "description": [text, optional, at most 128 chars],
  "signatureValidityInDays": [integer, >= 0]
}
```

**Data example** 

```json
{
  "url": "http://somehost.example.org/aup",
  "signatureValidityInDays": 365
}
```

#### Success response

**Condition**: The AUP is created for the organization

**Code**: `201 CREATED`

#### Error responses

**Condition**: The AUP already exists

**Code**: `409 CONFLICT`

**Content**: 
```json
{
    "error": "AUP already exists"
}
```

**Or**

**Condition**: Missing or invalid fields in the AUP representation

**Code**: `400 BAD REQUEST`

**Or**

**Condition**: Unauthenticated access 

**Code**: `401 UNAUTHORIZED`

**Content**:

```json
{
    "error": "unauthorized",
    "error_description": "Full authentication is required to access this resource"
}
```

**Or**

**Condition**: Authorization error 

**Code**: `403 FORBIDDEN`

**Content**:

```json
{
    "error": "Access is denied"
}
```

### PATCH /iam/aup

Updates the AUP for the organization

**Authentication required**: yes

**Authorization required**: ROLE\_ADMIN

**Data constraints**

Provide a representation of the AUP to be patched 

```json
{
  "url": [url, not blank],
  "description": [text, optional, at most 128 chars],
  "signatureValidityInDays": [integer, >= 0]
}
```

**Data example** 

```json
{
  "url": "http://somehost.example.org/aup",
  "signatureValidityInDays": 365
}
```

#### Success response

**Condition**: The AUP is modified for the organization

**Code**: `200 OK`

**Content example**:

```json
{
    "creationTime": "2018-02-27T19:51:39.083+01:00",
    "description": null,
    "lastUpdateTime": "2018-02-27T19:53:49.557+01:00",
    "signatureValidityInDays": 0,
    "url": "http://somehost.example.org/aup"
}
```

#### Error responses

**Condition**: Missing or invalid fields in the AUP representation

**Code**: `400 BAD REQUEST`

**Or**

**Condition**: Unauthenticated access 

**Code**: `401 UNAUTHORIZED`

**Content**:

```json
{
    "error": "unauthorized",
    "error_description": "Full authentication is required to access this resource"
}
```

**Or**

**Condition**: Authorization error 

**Code**: `403 FORBIDDEN`

**Content**:

```json
{
    "error": "Access is denied"
}
```
### DELETE /iam/aup

Deletes the AUP for the organization.

**Authentication required**: yes

**Authorization required**: ROLE\_ADMIN


#### Success response

**Condition**: The AUP is defined for the organization

**Code**: `204 NO CONTENT`

#### Error responses


**Condition**: The AUP is not defined for the organization

**Code**: `404 NOT FOUND`

**Content**: 
```json
{
    "error": "AUP is not defined for this organization"
}
```

**Or**

**Condition**: Unauthenticated access 

**Code**: `401 UNAUTHORIZED`

**Content**:

```json
{
    "error": "unauthorized",
    "error_description": "Full authentication is required to access this resource"
}
```

**Or**

**Condition**: Authorization error 

**Code**: `403 FORBIDDEN`

**Content**:

```json
{
    "error": "Access is denied"
}
```
