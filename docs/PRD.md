# Product Requirements Document (PRD)

*Last updated: 22 Nov 2026. Status: draft.*

> **What is a PRD?** A document that describes what a product should do and for whom, before anyone builds it. It keeps everyone (including future you) agreed on the goal.

## 1. Product overview

An AI app that understands **both what the user has and what they need**, then creates recipes and weekly plans that respect both. It focuses on budget, weekly planning and easy meals of 20-45 minutes (1 hour maximum).

**Market:** the UK (prices in GBP). Supermarkets under consideration: Tesco, Sainsbury's, Asda, Morrisons, Aldi, Lidl.

**Reference product:** NeatEat (a US competitor) is used for feature and layout inspiration only. We do not copy its branding or wording. The claim that there is no equivalent UK product is **unverified** and needs a competitor search.

**How we differ from a recipe library:** a library serves fixed recipes. This app generates new ones on demand, fitted to this week's budget and what is already in the kitchen.

## 2. Target users

- Busy parents
- College students
- Home cooks
- Health-conscious cooks and gym-goers
- Cooks who want to reduce food waste
- Beginners

## 3. Features and phases

*A "phase" is a stage of the build. Each phase should leave the app usable.*

| Feature | What it does | Phase | Status |
|---|---|---|---|
| Ingredient input | Type the ingredients on hand, including partial amounts | 1 (MVP) | Planned |
| AI recipe generation | Creates a new recipe from the ingredients and the user's needs | 1 (MVP) | Planned |
| Dietary and allergy rules | Applies diets; allergies are hard rules | 1 (MVP) | Planned |
| Cooking time filter | Quick (under 20 min), easy (20-45 min, default), standard (up to 60 min) | 1 (MVP) | Planned |
| Voice input | Speak the ingredients | 2 | Planned |
| Save and rate recipes | Save recipes; rate ease, taste and speed | 2 | Planned |
| Weekly meal planning | A week of meals from suggestions or the user's own entries | 2-3 | Planned |
| Store and budget | Weekly budget and chosen store; meals and shopping list to match | 3 | Planned, needs price data |
| Guide | Tips on grocery budgeting and meal prep | 4 | Planned |
| Free and paid tiers | Free: one recipe a day; paid: unlimited recipes and meal prep | 4 | To be decided |
| Paste-a-link recipe import | Import a recipe from a web link | Later | Idea |
| Photo ingredient recognition | Recognise items from a photo | Later | Parked |
| Calorie and macro targets | Plan around calorie and macro goals | Later | Parked |

## 4. How users will use it

- **Busy parents:** plan a week of dinners within a budget; quick meals that suit picky eaters.
- **Students:** cook from whatever is in the fridge on a tight budget.
- **Home cooks and waste-conscious cooks:** use up leftover and partial ingredients.
- **Health-conscious and gym-goers:** dietary-fit meals built around what they have.
- **Beginners:** easy recipes with clear steps and substitutions.

**Example of the core behaviour:** the user has chicken, pasta and tomatoes and is vegetarian. The AI skips the chicken, builds a vegetarian pasta, and explains the choice. If the constraints cannot all be met, it says what is missing instead of breaking a rule.

## 5. Non-functional requirements

*Non-functional means "how well it works", as opposed to "what it does".*

- **Privacy:** dietary and budget data is handled under UK GDPR.
- **Safety:** allergy rules are checked by ordinary code and are never overridden by the AI.
- **Price accuracy:** every cost shows its source and date, or is labelled as an estimate.
- **Cost control:** AI calls are limited per free-tier user and cached where possible.
- **Performance:** a recipe appears within about 10 seconds, with a loading state.

## 6. The price data risk

Budget features depend on accurate prices, and this is the biggest risk.

- UK supermarkets offer no open public price APIs.
- Scraping their sites may break their terms and breaks whenever the sites change.
- Prices vary by branch and change weekly; Aldi and Lidl have limited online catalogues.
- The AI cannot estimate costs reliably without real price data.

**Options:** start with one or two stores and a weekly price table; let users enter their own prices or use store-average bands, always labelled as estimates; keep prices in their own database table so the source can be swapped later.

## 7. AI approach (proposed)

- **Plain AI calls (one request, one answer)** for recipe generation, substitutions and partial ingredients.
- **Ordinary code, not AI,** for allergy and diet checks.
- **One real agent** (an AI that loops, uses tools and checks its work) for the budget-fitting weekly planner in Phase 3. It would have a maximum number of attempts, a cost cap per plan, and a final code check that the total is under budget.
- **Product-to-price matching** as a batch job. AI is good at matching messy product names, but it should not browse supermarket sites.
- **Guide articles** drafted by AI and reviewed by a human before publishing.

## 8. Open decisions

- [ ] Which stores launch first? (Suggestion: one or two)
- [ ] Are estimated prices acceptable at launch? (Suggestion: yes, clearly labelled)
- [ ] Is the weekly plan built automatically, or does the user pick meals and the AI fills the gaps?
- [ ] What exactly do the free and paid tiers include?
- [ ] Image source for recipes: stock photos, AI-generated images, or none at first?
- [ ] Is "Saisbusrys" in the original notes meant to be Sainsbury's? (Assumed yes.)

## 9. Not yet covered

Technical architecture, data model and a build timeline. These come next.
