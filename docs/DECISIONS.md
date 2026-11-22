# Decision Log

A short record of choices made, and why. Add a new entry at the top whenever something important is decided. This is how we avoid forgetting the reasoning later.

**Statuses:** Accepted (decided), Proposed (suggested, awaiting confirmation), Open (not decided).

---

## 2026-11-22: Where AI agents are used
**Status:** Proposed

**Decision:** The MVP uses single AI calls plus ordinary code checks, with no agents. The first real agent is the budget-fitting weekly planner in Phase 3, with a maximum number of attempts, a cost cap per plan and a final code check.

**Why:** Agents (AI that loops and uses tools) cost more and are harder to debug. Only the budget planner needs a loop: draft, look up prices, add up, swap meals, re-check. Allergy checks stay in plain code because they must be reliable.

---

## 2026-11-22: Proposed tech stack
**Status:** Proposed

**Decision:** Next.js (website), Supabase (database and accounts), Claude API (AI).

**Why:** The budget feature needs linked data (ingredients, prices per store, recipes, plans, shopping lists). Supabase is a SQL database, which suits this better than Firebase's document database. Next.js is React, so it is beginner-friendly, supports search-friendly pages for the guide section, and keeps the AI key safely on the server.

**Revisit:** after the first prototype.

---

## 2026-11-22: Product scope broadened to budget meal planning
**Status:** Accepted

**Decision:** Add budget and store selection, weekly meal planning and a guide section to the original recipe generator.

**Why:** A "plan a week for £X at Tesco" promise is concrete and gives users a reason to return weekly. Recipe generation alone is a one-off use.

---

## 2026-11-22: Build order
**Status:** Accepted

1. AI recipe generation with dietary rules (MVP)
2. Save recipes and the weekly plan
3. Budget with one or two stores, and a shopping list
4. More stores, then the guide section

Calorie and macro targets, photo recognition and share-sheet import are parked.

---

## 2026-11-22: Allergies are hard rules
**Status:** Accepted

**Decision:** Allergies are never treated as preferences and are checked by ordinary code, not left to the AI.

**Why:** A wrong answer here can cause real harm and destroys trust.

---

## 2026-11-22: Repository restarted as a fresh project
**Status:** Accepted

**Decision:** Earlier planning was not documented, so the repo is treated as new. The two PRD and scope-review documents from 22 Nov 2026 are the source of truth.

---

## Open
- Launch stores, estimated prices, auto-built vs user-picked plan, tier contents and image source. See the PRD, section 8.
