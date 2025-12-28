
  
  create view "dev"."main"."gold__monthly_subscriptions__dbt_tmp" as (
    select 
        date_trunc('month', min(subscription_start_date)) as start_month, 
        date_trunc('month', current_localtimestamp()) as end_month, 
    from "dev"."main"."silver__fact_subscriptions"
  );
