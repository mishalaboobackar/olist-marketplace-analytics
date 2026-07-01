-- Order-grain fact table: one row per order with revenue, delivery, and review attributes.
-- This is the table your dashboard and most analyses should hit.

with orders as (
    select * from {{ ref('stg_orders') }}
),

items as (
    select
        order_id,
        count(*)                    as item_count,
        count(distinct seller_id)   as seller_count,
        sum(item_price)             as items_revenue,
        sum(freight_value)          as freight_revenue,
        sum(item_price) + sum(freight_value) as order_revenue
    from {{ ref('stg_order_items') }}
    group by order_id
),

reviews as (
    select order_id, review_score
    from {{ ref('stg_reviews') }}
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.purchased_at,
    o.delivered_at,
    o.estimated_delivery_at,
    o.delivery_delay_days,
    o.is_late,
    i.item_count,
    i.seller_count,
    i.items_revenue,
    i.freight_revenue,
    i.order_revenue,
    r.review_score,
    case when r.review_score <= 2 then true else false end as is_low_review
from orders o
left join items i  on o.order_id = i.order_id
left join reviews r on o.order_id = r.order_id
