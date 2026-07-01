-- Clean, typed, deduplicated order records (1 row per order).
with source as (
    select * from {{ source('olist_raw', 'olist_orders_dataset') }}
),

renamed as (
    select
        order_id,
        customer_id,
        lower(order_status)                              as order_status,
        timestamp(order_purchase_timestamp)             as purchased_at,
        timestamp(order_approved_at)                    as approved_at,
        timestamp(order_delivered_carrier_date)         as shipped_at,
        timestamp(order_delivered_customer_date)        as delivered_at,
        timestamp(order_estimated_delivery_date)        as estimated_delivery_at
    from source
    where order_id is not null
)

select
    *,
    -- delivery lateness in days: positive = late
    date_diff(date(delivered_at), date(estimated_delivery_at), day) as delivery_delay_days,
    case
        when delivered_at is not null and delivered_at > estimated_delivery_at then true
        when delivered_at is not null then false
        else null
    end as is_late
from renamed
