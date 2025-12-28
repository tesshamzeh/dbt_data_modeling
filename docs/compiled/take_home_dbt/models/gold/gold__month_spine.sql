with month_bounds as (
    select 
        date_trunc('month', min(subscription_start_date)) as start_month, -- start reporting month at earliest subscription date's month
        date_trunc('month', current_localtimestamp() - interval 1 month) as end_month, -- end reporting at most recent completed month
    from "dev"."main"."silver__fact_subscriptions"
), 

monthly_spine as (
    select 
        cast(month_start as date) as month_start
    from 
        month_bounds, 
        generate_series(
            start_month, 
            end_month, 
            interval 1 month) as t(month_start)
)

select 
    month_start
from monthly_spine
order by 
    month_start desc