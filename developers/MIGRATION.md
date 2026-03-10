# Developers migration notes

## Goal

Move the current `developer-guides/` content into a GitBook `Developers` space.

## Current blockers

- `developer-guides/index.mdx` uses `CardGroup` and `Card`
- `developer-guides/launchlab/overview.mdx` uses `Note`
- `developer-guides/launchlab/monitoring-token-migration.mdx` uses `Note`
- `developer-guides/launchlab/collecting-fees.mdx` uses `Warning`

## Conversion approach

1. Replace card-based landing pages with standard Markdown links.
2. Convert hints into GitBook hints after import, or use blockquotes during the first pass.
3. Keep all code samples and technical detail intact.

