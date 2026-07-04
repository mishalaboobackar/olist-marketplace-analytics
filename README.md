# Olist Marketplace Operations & Revenue Analytics

End-to-end analytics project: raw marketplace data → cloud warehouse → dbt pipeline → SQL analysis → experiment design → BI dashboard, ending in a business recommendation.

> **Business question:** Olist, a Brazilian marketplace, is losing revenue to late deliveries and low review scores. What drives customer dissatisfaction, how much revenue is at risk, and what experiment should the company run to fix it?

## Architecture

```
Kaggle CSVs (9 tables, ~100k orders)
        │  load
        ▼
   BigQuery  (olist_raw)
        │  dbt: staging → dims/facts (star schema) + tests + docs
        ▼
   BigQuery  (olist_marts)
        │  SQL analysis  +  Python modeling / experiment design
        ▼
   Power BI / Tableau dashboard  +  written case study
```

> Nine raw CSVs load into BigQuery, get modeled and tested with dbt into a star schema, then feed SQL analysis and a BI dashboard. Lineage diagram and dashboard screenshots are added as the project progresses.

## Stack
BigQuery · dbt Core · SQL · Python (pandas, scikit-learn, statsmodels) · Power BI / Tableau · Git

## Project status
- [x] Cloud warehouse set up (BigQuery), 100k+ orders loaded across 9 tables
- [x] dbt pipeline: staging views + star-schema marts, with passing data-quality tests
- [x] Revenue-trend analysis
- [ ] Delivery, satisfaction, and seller analysis (in progress)
- [ ] Experiment design (A/B test)
- [ ] BI dashboard
- [ ] Written case study

## Key findings
*Analysis in progress; findings are added as each is completed.*

1. **Revenue scaled fast, then plateaued.** Monthly delivered revenue grew from near zero in late 2016 to roughly R$1M per month through 2018.
2. **Late delivery is the biggest satisfaction killer.** Late orders are only ~8% of deliveries, but they average a **2.57** review score versus **4.29** for on-time orders, and **54%** of late orders receive a 1–2 star review versus **9%** of on-time orders, roughly **6x** the bad-review rate. (Correlation; a controlled estimate follows in the experiment phase.)
3. **Revenue is highly concentrated among top sellers.** The top 5% of sellers generate **52.5%** of revenue, the top 10% generate **66.8%**, and the top 20% generate **82.1%** — a classic Pareto pattern, so the marketplace depends heavily on a small group of sellers.
4. **Almost every customer buys once.** **96.9%** of customers never place a second order (only **3.1%** repeat). With a one-shot relationship, the first-order experience, especially delivery, largely determines customer value, which is exactly why late deliveries are so costly.

## Recommendation
To be added after the experimentation phase: a designed A/B test (hypothesis, primary and guardrail metrics, sample size, and expected lift) targeting the biggest driver found in the analysis.

## Repo structure
```
olist-marketplace-analytics/
├── README.md
├── PROJECT_PLAN.md
├── requirements.txt
├── .gitignore
├── dbt/                  # dbt project (staging + marts, tests, docs)
│   ├── dbt_project.yml
│   └── models/
│       ├── staging/
│       └── marts/
├── analysis/            # business-question SQL
├── notebooks/           # Python: causal estimate, driver model, experiment design
└── dashboard/           # screenshots + Tableau Public / PBIX link
```

## Data
Brazilian E-Commerce Public Dataset by Olist — https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
(Real anonymized commercial data; review text anonymized with Game of Thrones house names.)

## Progress log
- Session 1: Set up BigQuery warehouse and loaded 9 raw tables (100k+ orders). Built the dbt project (staging views + `fct_orders` star-schema mart) with passing data-quality tests. Ran the first revenue-trend analysis.

## Author
Mishal Aboobackar Manalody (Abu) · Boston, MA · mishalaboobackar.github.io
