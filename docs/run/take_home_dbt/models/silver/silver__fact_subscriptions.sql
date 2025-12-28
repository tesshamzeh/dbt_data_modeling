
  
    
    

    create  table
      "dev"."main"."silver__fact_subscriptions__dbt_tmp"
  
    as (
      select
    subs.subscription_id, 
    subs.customer_id,
    subs.plan_id,
    subs.subscription_start_date,
    subs.subscription_end_date,
    plans.plan_monthly_price
from "dev"."main"."bronze__subscriptions" as subs
left join "dev"."main"."silver__dim_plans" as plans
    on subs.plan_id = plans.plan_id
    );
  
  