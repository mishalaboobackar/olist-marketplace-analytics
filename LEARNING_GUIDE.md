# Learning Companion — Refresher for the Marketplace Analytics Project

You're rusty across the board, that's fine. This guide is your reference. Each module
is tied to the project phase where you'll actually use it, so you learn by building, not
in a vacuum. Read a module right before you start that phase. Don't try to read it all
at once.

How to use it: skim the module, do the tiny exercise, then go do the real project step.
We'll also work through it together in chat. When something doesn't click, ask me.

---

## Module 1 — The mental model (read first, 10 min)

You're moving raw data through a pipeline to a decision:

```
Raw CSVs  →  Warehouse (storage + SQL)  →  dbt (clean & model)  →  Analysis  →  Dashboard  →  Recommendation
```

Vocabulary you'll hear and what it actually means:
- **Data warehouse**: a database built for analytics (not for running an app). BigQuery is one. You put tables in it and run SQL.
- **Schema / dataset**: a folder of tables inside the warehouse.
- **ETL / ELT**: Extract, Load, Transform. We *load* raw data, then *transform* it with dbt. That's ELT, the modern way.
- **Staging vs marts**: staging = lightly cleaned copies of raw tables. Marts = the final, business-ready tables (facts and dimensions) you actually analyze.
- **Fact vs dimension**: a *fact* table is events/measurements (orders, with revenue). A *dimension* describes things (customers, products). This split is the "star schema."

That's the whole project in five sentences. Everything below is detail.

---

## Module 2 — SQL refresher (for Phases 1–2)

SQL is your most important skill and the thing interviews test most. Get comfortable here.

### The query skeleton
```sql
SELECT   column_a, SUM(column_b) AS total_b   -- what to return
FROM     my_table                              -- where it comes from
WHERE    column_a IS NOT NULL                  -- filter rows BEFORE grouping
GROUP BY column_a                              -- one row per unique column_a
HAVING   SUM(column_b) > 100                   -- filter AFTER grouping
ORDER BY total_b DESC                          -- sort
LIMIT    10;                                    -- cap rows
```
Order of writing is SELECT-first, but order of *execution* is FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY. Knowing this explains most beginner errors.

### Joins (combining tables)
```sql
SELECT o.order_id, c.customer_state
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
```
- **INNER JOIN**: only rows that match in both tables.
- **LEFT JOIN**: all rows from the left table, NULLs where the right has no match. Use this most, so you don't silently drop data.

### Aggregation
`COUNT(*)`, `SUM()`, `AVG()`, `MIN()`, `MAX()` collapse many rows into one per group. Anything in SELECT that isn't aggregated must be in GROUP BY.

### CTEs (the readable way to build queries)
A CTE is a named temporary result. Build complex queries in steps:
```sql
WITH monthly AS (
    SELECT DATE_TRUNC(purchased_at, MONTH) AS month, SUM(revenue) AS rev
    FROM orders GROUP BY 1
)
SELECT * FROM monthly ORDER BY month;
```
Your project's `analysis/01_revenue_trend.sql` is built exactly this way, go read it.

### Window functions (the interview differentiator)
These compute across rows *without* collapsing them. Month-over-month growth uses `LAG`:
```sql
SELECT month, rev,
       rev - LAG(rev) OVER (ORDER BY month) AS change_vs_last_month
FROM monthly;
```
Other common ones: `ROW_NUMBER()`, `RANK()`, `SUM() OVER (...)` for running totals.

**Exercise:** in plain English, what does `02_late_delivery_vs_reviews.sql` compute? (Answer: average review score and low-review rate, split by whether the order was late.)

---

## Module 3 — Warehouse + dbt (for Phases 0–1, this is newest for you)

### BigQuery in one paragraph
A free cloud warehouse. The "sandbox" needs no credit card. You create a *project*, then *datasets* (folders), then load tables. You run SQL in the browser console. That's it.

### What dbt actually does
dbt lets you write each transformation as a `SELECT` statement in a `.sql` file (a "model").
- You **never** write `CREATE TABLE`. dbt wraps your SELECT and builds the table for you.
- Models can reference each other with `{{ ref('other_model') }}`. dbt figures out the build order automatically (the "lineage graph").
- `{{ source(...) }}` points at your raw loaded tables.
- `dbt run` builds your models. `dbt test` runs data-quality checks. `dbt build` does both.

### Tests = your data-quality story
In `_marts.yml` you'll see tests like `unique` and `not_null` on `order_id`. These auto-check your data every run. This is literally the "reduced reporting errors 25%" skill from your resume, made visible. Talk about it in interviews.

**Exercise:** open `dbt/models/staging/stg_orders.sql`. Find where it computes `is_late`. Notice it's just a `CASE WHEN`. That's all a model is, a SELECT that produces a clean table.

---

## Module 4 — Python for analysis (for Phase 3)

You'll use Python only where SQL runs out of road: statistical modeling and the experiment.

### pandas basics
```python
import pandas as pd
df = pd.read_csv("orders.csv")     # or pull from BigQuery
df.head()                          # peek
df.info()                          # types + nulls
df["is_late"].value_counts()       # counts of each value
df.groupby("is_late")["review_score"].mean()   # like SQL GROUP BY
```
If you know SQL GROUP BY, you already understand `groupby`. Same idea, different syntax.

### scikit-learn (modeling) in three lines of concept
1. Pick features `X` (order traits) and a target `y` (e.g. low review = 1/0).
2. `model.fit(X, y)` learns the pattern.
3. Look at feature importances to say *which factors drive low reviews*.

The point isn't a fancy model. It's translating "feature X matters most" into a business sentence.

---

## Module 5 — Stats & experiments (for Phase 3, the seniority signal)

### Correlation vs causation (say this in interviews)
"Late orders have worse reviews" is a *correlation*. Maybe expensive/heavy items are both more likely to be late AND reviewed harshly. To argue *cause*, you control for those confounders (regression) or you run an experiment.

### A/B testing in plain terms
Split users into A (control) and B (treatment, gets the change). Compare a primary metric.
- **Hypothesis:** "Adding a delivery buffer reduces low-review rate."
- **Primary metric:** low-review rate (or repeat-purchase rate).
- **Guardrail metric:** something you don't want to harm (e.g., delivery cost).
- **Significance:** is the difference real or just noise? A p-value < 0.05 is the common bar.
- **Sample size:** estimated *before* running, so you know how long to run it.

You won't run a live test (no users), so you'll *design* one. Designing a clean experiment is itself a strong hire signal.

**Exercise:** write one sentence: what's the difference between your correlation finding and a causal claim? If you can say it cleanly, you're ahead of most candidates.

---

## Suggested rhythm
1. Read Module 1 + 3, do Phase 0 (setup) and Phase 1 (dbt).
2. Read Module 2, do Phase 2 (SQL analysis).
3. Read Module 4 + 5, do Phase 3 (modeling + experiment).
4. Build the dashboard (Phase 4), write it up (Phase 5).

Don't rush. Understanding one phase beats half-finishing three. I'm here at each step.

## Free resources (only if you want extra)
- SQL practice: Mode SQL Tutorial, or sqlbolt.com
- dbt: the official "dbt Fundamentals" free course (docs.getdbt.com)
- BigQuery: Google's "BigQuery sandbox" quickstart
- Stats: "Trustworthy Online Controlled Experiments" (book) is the gold standard if you go deep later
