-- Monthly revenue, order volume, AOV, and month-over-month growth.
-- Demonstrates: date truncation, aggregation, window functions (LAG).

with monthly as (
    select
        date_trunc(date(purchased_at), month)   as order_month,
        count(*)                                as orders,
        sum(order_revenue)                      as revenue,
        safe_divide(sum(order_revenue), count(*)) as avg_order_value
    from {{ ref('fct_orders') }}
    where order_status = 'delivered'
    group by 1
)

select
    order_month,
    orders,
    revenue,
    avg_order_value,
    revenue - lag(revenue) over (order by order_month)            as revenue_change,
    safe_divide(
        revenue - lag(revenue) over (order by order_month),
        lag(revenue) over (order by order_month)
    ) as revenue_mom_growth
from monthly
order by order_month
