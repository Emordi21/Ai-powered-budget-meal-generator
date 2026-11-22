# AI-Powered Budget Meal Generator

An app that helps UK households **budget their groceries and plan their meals**.

The core idea: the AI understands **what you have** (ingredients in your kitchen) **and what you need** (diet, allergies, time, budget), then creates recipes and weekly meal plans that respect both.

> **Status:** planning stage. No application code yet. The repo was restarted as a fresh project on 22 Nov 2026, and earlier planning is treated as background only.

## Planned features

- Generate a new recipe from the ingredients you have (including partial amounts like "half an onion")
- Dietary rules and allergy rules (allergies are hard rules, never overridden)
- Easy meals: 20-45 minutes, 1 hour maximum
- Weekly meal planning
- Weekly budget and supermarket choice, with a shopping list
- A guide section with tips on grocery budgeting and meal prep

See [docs/PRD.md](docs/PRD.md) for the full list and build phases.

## Documentation

| File | What it is |
|---|---|
| [docs/PRD.md](docs/PRD.md) | Product Requirements Document: what we are building and why |
| [docs/DECISIONS.md](docs/DECISIONS.md) | A log of choices made, with the reasons |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Build phases and a progress checklist |

## Proposed tech stack

Next.js (website), Supabase (database and user accounts), Claude API (the AI). This is **proposed**, not final. See the decision log for the reasoning.

## How to run it

Not applicable yet. This section will be filled in when the first code is added.
