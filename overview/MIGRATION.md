# Overview migration notes

## Goal

Move the current Mintlify `overview/` section into a GitBook space without changing the information architecture.

## Current blockers

- `overview/about-raydium.mdx` uses `CardGroup` and `Card`
- `overview/core-products/overview.mdx` uses `CardGroup` and `Card`

## Conversion approach

1. Replace card grids with normal lists and short descriptions.
2. Keep the existing page split for CLMM, CPMM, AMM v4, LaunchLab, trading, and supporting products.
3. Rebuild the sidebar in GitBook from the existing Mintlify tab structure.

