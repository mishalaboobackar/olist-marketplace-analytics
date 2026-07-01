-- One row per item within an order. Grain: order_id + order_item_id.
with source as (
    select * from {{ source('olist_raw', 'olist_order_items_dataset') }}
)

select
    order_id,
    cast(order_item_id as int64)        as order_item_id,
    product_id,
    seller_id,
    timestamp(shipping_limit_date)      as shipping_limit_at,
    cast(price as numeric)              as item_price,
    cast(freight_value as numeric)      as freight_value
from source
where order_id is not null
