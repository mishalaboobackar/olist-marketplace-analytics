# Project Plan — Marketplace Operations & Revenue Analytics

**Owner:** Abu (Mishal Aboobackar Manalody)
**Goal:** Build one flagship, end-to-end analytics project that proves the exact skills Amazon / JPMorgan / State Street screen for: cloud data warehouse, dbt pipeline, advanced SQL, experimentation, BI dashboard, and a clear business recommendation.
**Dataset:** Olist Brazilian E-Commerce Public Dataset (~100k orders, 2016–2018, 9 relational tables). https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## The business framing (this is what gets you hired)

Don't present this as "I analyzed a dataset." Present it as solving a business problem:

> **"Olist is a Brazilian marketplace losing revenue to late deliveries and low review scores. As the analyst, I built the data pipeline, found what drives customer dissatisfaction and churn, quantified the revenue at risk, and recommended a prioritized experiment to fix it."**

Every recruiter conversation should map back to a decision a business leader could act on. That framing is the difference between a student project and a hire signal.

---

## Tech stack (all free, no credit card required)

| Layer | Tool | Why |
|-------|------|-----|
| Warehouse | **BigQuery sandbox** (free, no card) or Snowflake 30-day trial | Fills your "no cloud warehouse" gap. BigQuery sandbox is the lowest-friction. |
| Transformation | **dbt Core** (free, open source) | Fills your "no dbt / modern stack" gap. Star-schema modeling. |
| Querying | **SQL** (BigQuery Standard SQL) | Your strongest sellable skill, featured front and center. |
| Analysis / modeling | **Python** (pandas, scikit-learn, statsmodels) | Review-driver model + experiment design. |
| Dashboard | **Power BI** or **Tableau Public** | You already know both. Tableau Public is free and shareable via link. |
| Version control | **Git + GitHub** | Public repo, clean commits, strong README. |

---

## Phases & milestones

### Phase 0 — Setup (half a day)
- [ ] Create a GitHub repo: `olist-marketplace-analytics` (public).
- [ ] Download the Olist dataset from Kaggle (9 CSVs).
- [ ] Create a free BigQuery sandbox project (no credit card). Create a dataset `olist_raw`.
- [ ] Load the 9 CSVs into BigQuery as raw tables (UI upload or `bq load`).
- [ ] Install dbt Core + the BigQuery adapter: `pip install dbt-bigquery`.
- [ ] `dbt init`, point the profile at your BigQuery project, run `dbt debug` until green.

### Phase 1 — Data modeling with dbt (2–4 days)
Build a layered dbt project (staging → marts star schema). This is the centerpiece.
- [ ] **Staging models** (`stg_*`): one per raw table. Clean column names, cast types, parse timestamps, deduplicate. Light, 1:1 with sources.
- [ ] **Dimension models**: `dim_customers`, `dim_sellers`, `dim_products`, `dim_dates`.
- [ ] **Fact models**: `fct_orders` (order grain), `fct_order_items` (item grain).
- [ ] Add **dbt tests**: `unique` + `not_null` on keys, `relationships` between facts and dims, `accepted_values` on status fields. This shows data-quality discipline (your 25%-error-reduction story, demonstrated).
- [ ] Add `schema.yml` docs for every model. Run `dbt docs generate` and screenshot the lineage graph for your README.
- [ ] **Success criteria:** `dbt build` runs clean, all tests pass, lineage graph renders.

### Phase 2 — Core analysis in SQL (2–3 days)
Write a `/analysis` folder of well-commented SQL answering business questions:
- [ ] **Revenue & growth:** monthly GMV, order volume, average order value, month-over-month growth. (Mirrors your G-TEC revenue work.)
- [ ] **Delivery performance:** actual vs estimated delivery time, % late, late-rate by state and product category.
- [ ] **Customer satisfaction:** review-score distribution, and the correlation between delivery delay and review score.
- [ ] **Seller performance:** revenue concentration (is it a few sellers driving most GMV?), late-rate by seller.
- [ ] **Retention:** repeat-purchase rate and a simple cohort view (most customers are one-time — quantify it).
- [ ] Use **window functions, CTEs, and aggregations** deliberately. These are interview gold.

### Phase 3 — Experimentation & modeling (3–5 days)
This is the differentiator most portfolios lack.
- [ ] **Quantify the relationship:** does a late delivery *cause* a lower review score? Don't just correlate. Control for confounders (category, price, freight, distance) using a regression or matching approach in Python (statsmodels / scikit-learn). Be honest that it's observational.
- [ ] **Build a review-driver / dissatisfaction model:** predict low review scores (≤2) from order features. Report which features matter most and the business implication.
- [ ] **Design an A/B test:** propose a concrete experiment to reduce late deliveries (e.g., a delivery-buffer or proactive-notification change). Specify hypothesis, primary metric (review score / repeat rate), guardrail metrics, sample size, and how you'd compute significance. Designing a clean experiment signals seniority even without running it.
- [ ] **Success criteria:** a notebook with a defensible causal estimate, a model with interpretable drivers, and a one-page experiment design doc.

### Phase 4 — Dashboard (2–3 days)
- [ ] Connect Power BI / Tableau to your BigQuery marts (the `fct_*` and `dim_*` models, not raw).
- [ ] Build 3–4 pages: Executive KPI overview, Delivery performance, Customer satisfaction drivers, Seller/category breakdown.
- [ ] Add filters (date, state, category). One clear "so what" callout per page.
- [ ] Publish to Tableau Public (free link) or export Power BI screenshots.
- [ ] **Success criteria:** a recruiter can grasp the story in 30 seconds per page.

### Phase 5 — Writeup & polish (1–2 days)
- [ ] Fill in the `README.md` case study (template included in the repo).
- [ ] Add architecture diagram (CSV → BigQuery → dbt → BI), the dbt lineage screenshot, and 2–3 dashboard screenshots.
- [ ] Write the **executive summary**: 3 findings, the revenue at risk, and your recommended experiment.
- [ ] Clean commit history, clear repo structure, no secrets committed.
- [ ] Add the project to your portfolio site and LinkedIn Featured section.

---

## What each gap this closes (say this in interviews)

| Your gap | How this project closes it |
|----------|----------------------------|
| No cloud data warehouse | Built and queried tables in BigQuery |
| No dbt / modern data stack | Layered dbt project, tests, docs, lineage |
| SQL buried | Featured analysis folder of window-function-heavy SQL |
| Thin experimentation | Causal estimate + a designed A/B test |
| US/portfolio polish | Public GitHub + live dashboard + written case study |

---

## How to talk about it (resume bullet templates)

- "Built an end-to-end analytics pipeline on **BigQuery + dbt** modeling **100k+ marketplace orders** into a tested star schema, cutting ad-hoc query time and enforcing data quality with automated tests."
- "Quantified that **late deliveries drove a ~X-point drop in review scores**, isolating ~$Y in at-risk revenue, and **designed an A/B test** to validate a fix."
- "Shipped a **Power BI/Tableau dashboard** giving stakeholders status-at-a-glance on delivery SLAs, satisfaction, and seller performance." (Fill X/Y from your actual results.)

---

## Stretch goals (only if time allows)
- Schedule the dbt run with GitHub Actions (shows orchestration awareness).
- Add a `dbt snapshot` to track slowly-changing seller status.
- Geospatial delivery-distance analysis using the geolocation table.

---

## Optional: the only certification worth adding
You already hold the comprehensive cert (Google Data Analytics) and SQL (HackerRank). If you want one tool cert to pair per the "1 comprehensive + 1 tool-specific" rule, do a **Tableau or Power BI** certification *after* this project, not instead of it. The project is the priority.

## Sources
- Olist dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- Hiring signal (projects > certs): https://careery.pro/blog/data-analyst-careers/data-analyst-portfolio-projects
- In-demand skills 2026: https://www.coursera.org/articles/in-demand-data-analyst-skills-to-get-hired
