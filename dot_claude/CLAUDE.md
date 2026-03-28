# Personal Claude Code Instructions

## gstack

All web browsing and browser automation must use the `/browse` skill from gstack.
Never use `mcp__Claude_in_Chrome__*` tools directly.

### Available skills

| Skill | Purpose |
|---|---|
| `/office-hours` | YC-style brainstorming and startup/builder ideation |
| `/autoplan` | Full automated plan review (CEO + design + eng in sequence) |
| `/plan-ceo-review` | CEO/founder-mode plan review — strategy, scope, 10-star product |
| `/plan-eng-review` | Eng manager-mode plan review — architecture, data flow, edge cases |
| `/plan-design-review` | Designer's eye plan review — rates and fixes design dimensions |
| `/design-consultation` | Full design system proposal — aesthetic, typography, color, layout |
| `/design-shotgun` | Generate multiple design variants and compare |
| `/design-review` | Visual QA audit on a live site — finds and fixes inconsistencies |
| `/review` | Pre-landing PR review — SQL safety, LLM trust, structural issues |
| `/ship` | Ship workflow: tests, changelog, version bump, PR creation |
| `/land-and-deploy` | Merge PR, wait for CI/deploy, verify production health |
| `/canary` | Post-deploy canary monitoring — watches live app for regressions |
| `/benchmark` | Performance regression detection — baselines, Core Web Vitals |
| `/browse` | Headless browser — navigate, interact, screenshot, assert state |
| `/connect-chrome` | Launch real visible Chrome with Side Panel extension |
| `/qa` | Systematic QA testing with iterative bug fixing |
| `/qa-only` | QA report only — no fixes, structured output with screenshots |
| `/setup-browser-cookies` | Import real browser cookies for authenticated QA sessions |
| `/setup-deploy` | Configure deployment settings for `/land-and-deploy` |
| `/retro` | Weekly engineering retrospective — commit analysis, trends |
| `/investigate` | Systematic debugging with root cause analysis |
| `/document-release` | Post-ship docs update — README, CHANGELOG, CLAUDE.md sync |
| `/codex` | OpenAI Codex second opinion — review, challenge, or consult |
| `/cso` | Security audit — secrets, supply chain, OWASP, STRIDE |
| `/careful` | Warn before destructive commands |
| `/freeze` | Restrict edits to a specific directory |
| `/guard` | Full safety mode: destructive warnings + scoped edits |
| `/unfreeze` | Clear the freeze boundary |
| `/gstack-upgrade` | Upgrade gstack to the latest version |
