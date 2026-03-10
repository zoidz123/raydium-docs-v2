# Protocol migration notes

## Goal

Move the current protocol reference into a GitBook `Protocol` space.

## Current blockers

- `protocol/index.mdx` uses `CardGroup` and `Card`
- `protocol/ray-token/overview.mdx` uses `CardGroup` and `Card`
- `protocol/bug-bounty-program/overview.mdx` uses `CardGroup` and `Card`

## Conversion approach

1. Replace card grids with standard Markdown page lists.
2. Keep the existing page tree for RAY token, protocol docs, and bug bounty docs.
3. Leave user-task content such as staking in the `User Guides` space.

