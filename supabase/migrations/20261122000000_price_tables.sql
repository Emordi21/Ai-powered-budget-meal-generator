-- Price tables for the budget meal planner (see docs/PRICE_TABLE_DESIGN.md)
-- Money is stored in pence as whole numbers. Prices are added, never overwritten.

create table public.stores (
  id          bigint generated always as identity primary key,
  name        text not null unique,
  slug        text not null unique,
  price_mode  text not null default 'own' check (price_mode in ('own','multiplier')),
  active      boolean not null default true
);

create table public.basket_items (
  id         bigint generated always as identity primary key,
  name       text not null unique,
  category   text not null,
  base_unit  text not null check (base_unit in ('g','ml','each')),
  pack_size  numeric not null check (pack_size > 0)
);

create table public.ingredient_aliases (
  alias          text primary key,
  basket_item_id bigint not null references public.basket_items(id) on delete cascade
);

create table public.prices (
  id             bigint generated always as identity primary key,
  basket_item_id bigint not null references public.basket_items(id),
  store_id       bigint not null references public.stores(id),
  price_pence    integer not null check (price_pence > 0),
  pack_size      numeric not null check (pack_size > 0),
  price_type     text not null default 'standard' check (price_type in ('standard','promo','loyalty')),
  source         text not null check (source in ('manual','user','receipt','feed','estimate')),
  observed_on    date not null,
  created_at     timestamptz not null default now()
);

create index prices_latest_idx
  on public.prices (basket_item_id, store_id, price_type, observed_on desc);

create table public.store_multipliers (
  store_id      bigint not null references public.stores(id),
  base_store_id bigint not null references public.stores(id),
  category      text not null,
  multiplier    numeric not null check (multiplier > 0),
  sample_size   integer not null check (sample_size > 0),
  measured_on   date not null,
  primary key (store_id, base_store_id, category, measured_on)
);

create table public.user_price_overrides (
  user_id        uuid not null references auth.users(id) on delete cascade,
  basket_item_id bigint not null references public.basket_items(id),
  store_id       bigint not null references public.stores(id),
  price_pence    integer not null check (price_pence > 0),
  pack_size      numeric not null check (pack_size > 0),
  updated_at     timestamptz not null default now(),
  primary key (user_id, basket_item_id, store_id)
);

-- Row Level Security: on for every table.
alter table public.stores               enable row level security;
alter table public.basket_items         enable row level security;
alter table public.ingredient_aliases   enable row level security;
alter table public.prices               enable row level security;
alter table public.store_multipliers    enable row level security;
alter table public.user_price_overrides enable row level security;

-- Shared reference data: anyone may read. No write policies, so only the
-- admin (service role, which bypasses RLS) can change these tables.
create policy "read stores"       on public.stores             for select using (true);
create policy "read basket items" on public.basket_items       for select using (true);
create policy "read aliases"      on public.ingredient_aliases for select using (true);
create policy "read prices"       on public.prices             for select using (true);
create policy "read multipliers"  on public.store_multipliers  for select using (true);

-- Overrides are private: each user sees and changes only their own rows.
create policy "own overrides" on public.user_price_overrides
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Latest standard price per item and store.
-- security_invoker makes the view obey the caller's RLS rules.
create view public.current_prices with (security_invoker = true) as
select distinct on (basket_item_id, store_id)
  basket_item_id, store_id, price_pence, pack_size, source, observed_on
from public.prices
where price_type = 'standard'
order by basket_item_id, store_id, observed_on desc;

-- Index for the foreign keys used by overrides lookups.
create index user_price_overrides_item_idx on public.user_price_overrides (basket_item_id, store_id);
create index ingredient_aliases_item_idx on public.ingredient_aliases (basket_item_id);
