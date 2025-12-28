
  
  create view "dev"."main"."gold__report_metrics_by_month__dbt_tmp" as (
    select
    subs.year_month,
    count(subs.*) as num_active_customers,
    sum(subs.plan_monthly_price) as monthly_recurring_revenue,
    churns.logo_churn_rate
from "dev"."main"."gold__subscriptions_by_month" as subs
left join "dev"."main"."gold__logo_churn_by_month" as churns
    on subs.year_month = churns.year_month
group by
    all
order by
    subs.year_month desc
  );
