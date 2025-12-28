
  
    
    

    create  table
      "dev"."main"."silver__dim_plans__dbt_tmp"
  
    as (
      select 
    plan_id, 
    plan_name, 
    plan_monthly_price
from "dev"."main"."bronze__plans"
    );
  
  