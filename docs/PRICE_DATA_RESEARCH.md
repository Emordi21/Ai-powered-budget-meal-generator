# Price Data Research

*Researched 22 Nov 2026 using web search only. Results are summaries of what search returned. Licences, terms and availability must be checked at the source before we rely on anything here. Items marked "unconfirmed" were not verified.*

## Summary

- There is **no free, official, store-by-store UK grocery price feed** that we found.
- Free official data (ONS) is real but covers only a few hundred items, with no per-store prices.
- Commercial and scraped data exists, but it carries cost and legal risk.
- This supports the plan in `PRICE_TABLE_DESIGN.md`: our own small price table (a "reference basket"), updated weekly, with every price labelled by source and date.

## Options reviewed

| Option | What we found | Fit for us |
|---|---|---|
| **ONS shopping prices comparison tool** | Official. Tracks average prices of 450+ items (food and non-food), updated monthly. Historical food price data (Jan 2018 to Jan 2025) is downloadable. ONS plans to bring in grocery scanner data in 2026 and says it will no longer publish the price-quote microdata in its current form. | Good for **sanity-checking** our averages. Not store-specific, and the data format and future availability are changing. Licence unconfirmed. |
| **Open Prices (Open Food Facts)** | Crowd-sourced, ODbL licence (credit required, shared-alike rules for modified datasets). Available via API and bulk download. | Free, but we found **no confirmation of useful UK supermarket coverage**. Worth a direct look at the dataset. |
| **Awin affiliate product feeds** | Awin feeds carry product name, price, images and links. | We found **no confirmation that Tesco, Sainsbury's, Asda, Aldi or Ocado publish grocery feeds there.** Needs checking per retailer and per programme terms. |
| **Trolley.co.uk** | Popular price comparison site. No public API found. Its terms restrict automated access, and its business depends on licensing its data (it was in a licensing dispute in 2022). | Not a free source. Would need a licensing conversation. |
| **Paid scraping vendors** (e.g. data actors on Apify, Actowiz) | Sell UK supermarket price data. | Costs money, and scraping retailer sites usually conflicts with their terms. Vendor claims are unverified. Not suitable for the free MVP. |
| **Oxford foodDB** | A research platform tracking UK food and drink products. | Interesting for research contacts. Licence not found. |

## Things that affect accuracy

- **Loyalty prices:** one vendor claims Tesco Clubcard and Sainsbury's Nectar prices can differ from standard prices by 20-40% on promoted items (unverified). The price table should store standard, promotional and loyalty prices separately.
- **Aldi:** one source notes Aldi UK has no online grocery shop, so its prices come from in-store information shown online.
- **Which? basket (a published comparison):** one search result reported Aldi cheapest on a 95-item basket (about £171 against about £198 at Tesco with Clubcard). We couldn't confirm the date or method, so treat it only as a hint that store price gaps are real and large.

## UK competitors found (this changes an earlier assumption)

The earlier claim that there is "no such competitor in the UK" is **not supported**. Search results showed:

| Product | What it appears to do (from listings, not tested) |
|---|---|
| **Mealia** | Meal planning with a weekly budget; works with Tesco, Asda, Sainsbury's and Morrisons |
| **Meal2Shop** | Free planner with paid recipe packs, with a personal price tracker and store comparison |
| **Misu** | Budget meal planner, iPhone, many supermarkets across countries |
| **Tesco** | Has an AI meal planning assistant in its app |
| **Sainsbury's SmartLists** | Planning and budgeting using Nectar prices |
| **Aldi** | Meal planner hub on its website |
| **Trolley** | Price comparison app covering several UK supermarkets |

We haven't tried any of these. The next step should be to test the closest ones (Mealia, Meal2Shop, Tesco's assistant) to see what they actually do.

**What this means for positioning:** "budget plan at a UK store" is not unique. Our stronger angle is generating recipes from what the user already has, with hard allergy and diet rules and clear estimate labelling.

## Recommendation

1. Build our own reference basket and price table (see `PRICE_TABLE_DESIGN.md`).
2. Use ONS averages and spot-checks to validate it.
3. Check Open Prices and affiliate feeds directly before assuming they're unusable.
4. Don't scrape retailer sites. Revisit licensed data once there are users.

## Still to check
- ONS dataset licence and current download format.
- Open Prices: how many UK supermarket prices exist.
- Which UK grocers, if any, publish product feeds through affiliate networks.
- Retailer terms of use about price data.
- Hands-on testing of Mealia, Meal2Shop and Tesco's meal assistant.
