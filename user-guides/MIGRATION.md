# User Guides migration notes

## Goal

Move the current task-oriented guides into a GitBook `User Guides` space while keeping the current group structure.

## Current blockers

- `guides/getting-started/onboarding.mdx` uses `CardGroup` and `Card`
- `guides/liquidity/liquidity-faq.mdx` uses `AccordionGroup` and `Accordion`
- `guides/trading/trade-faq.mdx` uses `AccordionGroup` and `Accordion`
- `guides/supporting-tools/ecosystem-farms.mdx` uses `Card`
- `guides/supporting-tools/ecosystem-farms/farms-faq.mdx` uses `AccordionGroup` and `Accordion`
- `guides/launchlab/index.mdx` uses `Card`

## Conversion approach

1. Replace card grids with normal lists and section links.
2. Convert accordions into standard FAQ sections first.
3. Keep the current `guides/` information architecture.

