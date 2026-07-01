-- Does late delivery track with worse reviews? (Correlation view; causal test is in /notebooks.)
-- Demonstrates: conditional aggregation, segmentation.

select
    is_late,
    count(*)                                          as orders,
    round(avg(review_score), 3)                       as avg_review_score,
    round(avg(case when is_low_review then 1 else 0 end), 4) as low_review_rate,
    round(avg(delivery_delay_days), 2)                as avg_delay_days
from {{ ref('fct_orders') }}
where delivered_at is not null
  and review_score is not null
group by is_late
order by is_late
