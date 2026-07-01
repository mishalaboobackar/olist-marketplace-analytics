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

*(Add your dbt lineage screenshot and architecture diagram here.)*

## Stack
BigQuery · dbt Core · SQL · Python (pandas, scikit-learn, statsmodels) · Power BI / Tableau · Git

## Key findings
*(Fill in after Phase 3–5. Example structure:)*
1. **Late deliveries drive dissatisfaction.** Orders delivered past estimate scored ~X points lower on reviews, controlling for category, price, and freight.
2. **Revenue concentration risk.** The top X% of sellers drive Y% of GMV; their late-rate is Z%.
3. **One-time buyers dominate.** ~X% of customers never repurchase, so first-order experience is the whole game.

## Recommendation
*(Your designed A/B test: hypothesis, metric, guardrails, sample size, expected lift.)*

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

## Author
Mishal Aboobackar Manalody (Abu) · Boston, MA · mishalaboobackar.github.io
