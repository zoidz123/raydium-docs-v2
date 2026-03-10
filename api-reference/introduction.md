# Raydium API v3

Reference for the Raydium API v3 endpoints.

## Overview

This API reference is the source of truth for Raydium API v3.

In GitBook, import the OpenAPI specs from this space to generate the API reference groups and endpoint pages.

## Base URL

Use the Raydium API base URL:

```bash
https://api-v3.raydium.io
```

## Response wrapper

Raydium describes every response as being wrapped in a top-level status envelope:

```json
{
  "id": "string",
  "success": true,
  "data": {}
}
```

Failed responses use:

```json
{
  "id": "string",
  "success": false,
  "msg": "string"
}
```
