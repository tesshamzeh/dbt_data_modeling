
  
  create view "dev"."main"."gold__subscriptions_by_month__dbt_tmp" as (
    with subs_trunc_date as (
    select
        subscription_id,
        customer_id,
        plan_id,
        plan_monthly_price,
         -- start reporting month at earliest subscription date's month:
        date_trunc('month', subscription_start_date) as subscription_start_month,
        -- end reporting at most recent completed month
        -- using specific date (see vars in dbt_project.yml) rather than current_date for consistent reproducibility:
        date_trunc('month', coalesce(subscription_end_date, cast('2025-12-27' as date))) as subscription_end_month
    from "dev"."main"."silver__fact_subscriptions"
)

-- expand each subscription into one row per active month
-- using a cross join on a date spine for each subscription's active months 
-- (assumes there will always be at least one active subscription in order
-- to have monthly reporting)
select
    cast(spine.month as date) as year_month,
    subs.subscription_id,
    subs.customer_id,
    subs.plan_id,
    subs.plan_monthly_price
from subs_trunc_date as subs
cross join generate_series(
    subs.subscription_start_month,
    subs.subscription_end_month,
    interval '1 month'
) as spine(month)
order by 
    month desc,
    customer_id
  );
