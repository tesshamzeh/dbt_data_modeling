select
subscription_id,
customer_id,
plan_id,
monthly_price,
date_trunc('month', month) as month
from "dev"."main"."silver__fact_subscriptions",
unnest(
generate_date_array(
    start_date,
    coalesce(end_date, current_date),
    interval 1 month
)
) as month