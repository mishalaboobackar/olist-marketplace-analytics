-- Seller revenue concentration: what share of GMV comes from the top sellers?
-- Business angle: high concentration = revenue risk if a few sellers churn.
-- Demonstrates: CTEs, NTILE window function, conditional aggregation.

with seller_rev as (
    select
        seller_id,
        sum(item_price + freight_value) as revenue
    from {{ ref('stg_order_items') }}
    group by seller_id
),

ranked as (
    select
        revenue,
        ntile(100) over (order by revenue desc) as pctile
    from seller_rev
)

select
    round(100.0 * sum(if(pctile <= 5,  revenue, 0)) / sum(revenue), 1) as pct_revenue_top_5pct_sellers,
    round(100.0 * sum(if(pctile <= 10, revenue, 0)) / sum(revenue), 1) as pct_revenue_top_10pct_sellers,
    round(100.0 * sum(if(pctile <= 20, revenue, 0)) / sum(revenue), 1) as pct_revenue_top_20pct_sellers
from ranked
