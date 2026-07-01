-- Customer reviews. Keep latest review per order (some orders have duplicates).
with source as (
    select * from {{ source('olist_raw', 'olist_order_reviews_dataset') }}
),

ranked as (
    select
        review_id,
        order_id,
        cast(review_score as int64)                 as review_score,
        timestamp(review_creation_date)             as review_created_at,
        timestamp(review_answer_timestamp)          as review_answered_at,
        row_number() over (
            partition by order_id
            order by timestamp(review_answer_timestamp) desc
        ) as rn
    from source
    where order_id is not null
)

select * except (rn)
from ranked
where rn = 1
