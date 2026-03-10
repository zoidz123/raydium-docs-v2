# Raydium docs v2

This repository is the GitBook-ready export for the Raydium docs migration from Mintlify into a multi-space GitBook site.

## Target site sections

Use one GitBook section and one GitBook space for each of these project directories:

| GitBook section | Git Sync project directory |
| --- | --- |
| Overview | `overview` |
| Developers | `developers` |
| API Reference | `api-reference` |
| User Guides | `user-guides` |
| Protocol | `protocol` |
| Help Center | `help-center` |

## What is in here

Each space directory contains:

- `README.md` for the landing page
- `SUMMARY.md` for the initial GitBook navigation
- `MIGRATION.md` for the source-file map and conversion checklist

## Recommended setup sequence

1. Create a new GitBook site.
2. Add six sections:
   - Overview
   - Developers
   - API Reference
   - User Guides
   - Protocol
   - Help Center
3. Create one space for each section.
4. Connect each space to the matching project directory listed above.
5. Import the OpenAPI specs from `api-reference/specs/`.
6. Connect Git Sync for each space using the matching directory in this repo.

## Notes

- This repo is a deployable Markdown export, not the Mintlify source of truth.
- Regenerate future updates from the Mintlify source repo, then sync refreshed Markdown into this repo.
- The API Reference space should be driven by the existing OpenAPI specs, not by Mintlify `docs.json` navigation.
