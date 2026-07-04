-- Customer retention: what share of customers ever place a second order?
-- Note: in Olist, customer_id is per-order; customer_unique_id identifies the person.
-- Demonstrates: joins, aggregation, COUNTIF.

with per_customer as (
    select
        c.customer_unique_id,
        count(*) as orders
    from {{ ref('fct_orders') }} f
    join {{ source('olist_raw', 'olist_customers_dataset') }} c
        on f.customer_id = c.customer_id
    group by c.customer_unique_id
)

select
    count(*) as total_customers,
    round(100.0 * countif(orders = 1) / count(*), 1) as pct_one_time_buyers,
    round(100.0 * countif(orders > 1) / count(*), 1) as pct_repeat_buyers
from per_customer
