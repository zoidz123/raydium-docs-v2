# API Reference migration notes

## Goal

Use GitBook's OpenAPI support for the API Reference space while preserving the current endpoint coverage.

## Current Mintlify source

- `api-reference/introduction.mdx`
- `api-reference/openapi.json`
- `api-reference/trade-api-openapi.json`

## Conversion approach

1. Convert the API introduction into a plain Markdown page.
2. Import the two OpenAPI specs in GitBook.
3. Remove dependency on Mintlify `docs.json` `openapi` navigation.

