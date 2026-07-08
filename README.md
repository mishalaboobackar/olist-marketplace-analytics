# Olist Marketplace Operations & Revenue Analytics

End-to-end analytics on a Brazilian e-commerce marketplace: raw data → cloud warehouse → dbt pipeline → SQL analysis → causal analysis & ML → experiment design → interactive dashboard, ending in business recommendations.

> **Business question:** Olist, a Brazilian marketplace, is losing revenue to late deliveries and low review scores. What drives customer dissatisfaction, how much revenue is at risk, and what should the company do about it?

**Live dashboard (Tableau Public):** https://public.tableau.com/app/profile/mishal.aboobackar.manalody/viz/OlistDashboard_17834988830640/Dashboard1

## Architecture

```
Kaggle CSVs (9 tables, ~100k orders)
        │  load
        ▼
   BigQuery  (olist_raw)
        │  dbt: staging → star-schema marts + data-quality tests
        ▼
   BigQuery  (olist_marts)
        │  SQL analysis  ·  Python causal analysis + ML
        ▼
   Tableau dashboard  ·  business recommendations
```

## Stack
BigQuery · dbt Core · SQL · Python (pandas, statsmodels, scikit-learn) · Tableau · Git

## Key findings
1. **Revenue scaled fast, then plateaued.** Monthly delivered revenue grew from near zero in late 2016 to roughly R$1M per month through 2018.
2. **Late delivery is the biggest satisfaction killer.** Late orders are only ~8% of deliveries, but they average a **2.57** review score versus **4.29** for on-time orders, and **54%** of late orders receive a 1–2 star review versus **9%** on-time, roughly **6x** the bad-review rate.
3. **Revenue is highly concentrated among top sellers.** The top 5% of sellers generate **52.5%** of revenue, the top 10% **66.8%**, and the top 20% **82.1%** — a classic Pareto pattern.
4. **Almost every customer buys once.** **96.9%** of customers never place a second order. With a one-shot relationship, the first-order experience largely determines customer value.
5. **The late-delivery effect is causal, not just correlation.** In a logistic regression controlling for price, freight, item count, and estimated delivery time, a late order still has **~13x the odds** of a 1–2★ review (p < 0.001), and a Random Forest ranks late delivery the top driver by a wide margin. (See `notebooks/03_experiment_analysis.ipynb`.)

## Recommendations
1. **Under-promise delivery dates** (add a buffer at checkout) to cut late-vs-promise orders — validate with the A/B test in `EXPERIMENT_DESIGN.md`, watching checkout conversion as a guardrail.
2. **Send proactive delay alerts** to soften the review hit when an order will run late.
3. **Fix the worst routes and categories first** for the biggest logistics gain.
4. **Protect the top 20% of sellers** who drive 82% of revenue with reliable fulfillment.
5. **Win the second order** with a post-first-purchase retention nudge, since ~97% never return.

## Repo structure
```
olist-marketplace-analytics/
├── README.md
├── EXPERIMENT_DESIGN.md      # A/B test design
├── requirements.txt
├── dbt/                      # dbt project: staging + star-schema marts + tests
│   ├── dbt_project.yml
│   └── models/{staging,marts}/
├── analysis/                 # business-question SQL (revenue, delivery, sellers, retention)
└── notebooks/                # Python causal analysis + ML model
```

## Data
Brazilian E-Commerce Public Dataset by Olist — https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
(Real anonymized commercial data; raw CSVs are not committed — download from Kaggle to reproduce.)

## Author
Mishal Aboobackar Manalody (Abu) · Boston, MA · mishalaboobackar.github.io
