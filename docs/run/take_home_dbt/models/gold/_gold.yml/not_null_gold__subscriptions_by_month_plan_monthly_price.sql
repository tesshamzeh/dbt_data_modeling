
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select plan_monthly_price
from "dev"."main"."gold__subscriptions_by_month"
where plan_monthly_price is null



  
  
      
    ) dbt_internal_test