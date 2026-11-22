# Price Table Design (draft)

*Status: the tables are created in the Supabase project `budget-meal-planner` (free plan, eu-west-1), empty. The real SQL is `supabase/migrations/20261122000000_price_tables.sql`, which adds Row Level Security on every table and a few safety improvements over the draft below. The design is still open to change before we load data.*

> **Database table:** like a spreadsheet tab. Each row is one record, each column is one detail about it.

## Goals

- **Free:** a small table fits easily in Supabase's free tier.
- **Fast:** prices are read from our own table, never fetched from a store while a user waits.
- **Honest:** every price shows where it came from and when it was recorded.
- **Replaceable:** we can swap the data source later without redesigning anything.

## The idea in one paragraph

We keep a short list of **basket items**: the 200-300 ingredients most meals use (such as "chicken thighs, 1 kg"). For each store we record a **price** for each item, with its date and source. Recipes are costed by matching their ingredients to basket items. A second store can start as a **multiplier** of the first (for example "Aldi is about 85% of Tesco"), until we have its real prices. Users can **override** any price with their own.

## Tables

| Table | What it holds |
|---|---|
| `stores` | The supermarkets (Aldi, Tesco and so on) and whether they use real prices or a multiplier |
| `basket_items` | The reference ingredients, with a standard unit and pack size |
| `ingredient_aliases` | Other names for the same item ("scallions" and "spring onions"), to help the AI match recipe ingredients |
| `prices` | One price per item, per store, per date, with its source and type |
| `store_multipliers` | "Store B is X% of Store A" per category, with the date and sample size |
| `user_price_overrides` | A user's own price for an item at a store, visible only to them |

## Rules the design enforces

1. **Money is stored in pence** as whole numbers (£1.25 is 125). This avoids rounding errors that come from decimals.
2. **Every price has a source:** `manual`, `user`, `receipt`, `feed` or `estimate`.
3. **Every price has a date.** Anything older than 14 days (a setting we can change) is shown as "may be out of date".
4. **Price types are separate:** `standard`, `promo`, `loyalty`. Plans use `standard` by default, so loyalty prices never quietly make a plan look cheaper.
5. **Prices are never overwritten.** We add a new row, so we keep a history and can measure accuracy over time.
6. **Estimates are labelled** in the app, with a range such as "about £48-£55".

## SQL draft

```sql
-- Supermarkets we support
create table stores (
  id            bigint generated always as identity primary key,
  name          text not null unique,          -- e.g. 'Aldi'
  slug          text not null unique,          -- e.g. 'aldi'
  price_mode    text not null default 'own'    -- 'own' = real prices, 'multiplier' = derived
                check (price_mode in ('own','multiplier')),
  active        boolean not null default true
);

-- The reference ingredients (the "basket")
create table basket_items (
  id            bigint generated always as identity primary key,
  name          text not null unique,          -- e.g. 'Chicken thighs, skin-on'
  category      text not null,                 -- e.g. 'meat', 'dairy', 'veg', 'tinned'
  base_unit     text not null                  -- unit we cost in
                check (base_unit in ('g','ml','each')),
  pack_size     numeric not null               -- typical pack, in base_unit
);

-- Other names for the same item, to help matching recipe ingredients
create table ingredient_aliases (
  alias         text primary key,
  basket_item_id bigint not null references basket_items(id)
);

-- Price observations: we add rows, we never overwrite them
create table prices (
  id             bigint generated always as identity primary key,
  basket_item_id bigint not null references basket_items(id),
  store_id       bigint not null references stores(id),
  price_pence    integer not null check (price_pence > 0),
  pack_size      numeric not null,             -- pack size this price is for
  price_type     text not null default 'standard'
                 check (price_type in ('standard','promo','loyalty')),
  source         text not null
                 check (source in ('manual','user','receipt','feed','estimate')),
  observed_on    date not null,                -- when the price was seen
  created_at     timestamptz not null default now()
);

-- Fast lookup of the latest price for an item at a store
create index prices_latest_idx
  on prices (basket_item_id, store_id, price_type, observed_on desc);

-- Store B as a percentage of a base store, per category
create table store_multipliers (
  store_id       bigint not null references stores(id),
  base_store_id  bigint not null references stores(id),
  category       text not null,
  multiplier     numeric not null check (multiplier > 0),  -- 0.85 = 15% cheaper
  sample_size    integer not null,             -- how many items it was measured on
  measured_on    date not null,
  primary key (store_id, base_store_id, category, measured_on)
);

-- A user's own price for an item (private to them)
create table user_price_overrides (
  user_id        uuid not null references auth.users(id),
  basket_item_id bigint not null references basket_items(id),
  store_id       bigint not null references stores(id),
  price_pence    integer not null check (price_pence > 0),
  pack_size      numeric not null,
  updated_at     timestamptz not null default now(),
  primary key (user_id, basket_item_id, store_id)
);

-- Row Level Security: users may only see and change their own overrides
alter table user_price_overrides enable row level security;
create policy "own overrides" on user_price_overrides
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- The latest standard price per item and store
create view current_prices as
select distinct on (basket_item_id, store_id)
  basket_item_id, store_id, price_pence, pack_size, source, observed_on
from prices
where price_type = 'standard'
order by basket_item_id, store_id, observed_on desc;
```

### What the SQL means, line by line
- `create table` makes a new table.
- `primary key` is the column that uniquely identifies each row.
- `references` links a row to a row in another table, so a price can't point to an item that doesn't exist.
- `check (...)` blocks bad data, for instance a price of zero.
- `index` is like a book's index: it makes lookups fast.
- **Row Level Security** is the database enforcing "users only see their own rows", so a bug in the app can't leak one user's data.
- `view` is a saved query. `current_prices` always gives the latest price without extra code.

## How a recipe gets costed (outline)

1. The AI returns ingredients with quantities for a recipe.
2. Each ingredient is matched to a basket item (via `ingredient_aliases`, with AI help for unmatched ones).
3. Cost = quantity / pack size x pack price, using the user's override if there is one, otherwise the store's latest standard price, otherwise the base store's price x the store multiplier.
4. The total is shown with its freshness and an estimate range. If an ingredient can't be matched, the app says so instead of guessing.

## Open questions
- Which store is the base store, Aldi or Tesco?
- How many basket items are enough? Start with about 150.
- How often do we refresh? Weekly is the suggested starting point.
- Should "per-meal" costs round up, so the budget stays safe?
