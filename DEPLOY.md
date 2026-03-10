# GitBook deploy checklist

Use this checklist when you connect the new GitBook site.

## 1. Create the site sections

Create these six top navigation sections in GitBook:

1. Overview
2. Developers
3. API Reference
4. User Guides
5. Protocol
6. Help Center

## 2. Set the section slugs

Set the section slugs exactly to:

- `overview`
- `developers`
- `api-reference`
- `user-guides`
- `protocol`
- `help-center`

The exported Markdown in this repository uses these slugs for cross-space links.

## 3. Connect Git Sync project directories

Connect each GitBook space to the matching project directory:

| Section | Project directory |
| --- | --- |
| Overview | `overview` |
| Developers | `developers` |
| API Reference | `api-reference` |
| User Guides | `user-guides` |
| Protocol | `protocol` |
| Help Center | `help-center` |

## 4. Import the OpenAPI specs

Inside the `API Reference` space:

1. Import `api-reference/specs/trade-api-openapi.json`
2. Import `api-reference/specs/openapi.json`
3. Keep `api-reference/README.md` as the landing page

## 5. Refresh workflow

If the Mintlify source docs change, regenerate the export from the source repo and copy the refreshed Markdown into this repository before syncing GitBook.

## 6. Final pre-sync checks

Then confirm:

- `*/README.md` exists for every space
- `*/SUMMARY.md` exists for every space
- `api-reference/specs/` contains both OpenAPI specs
