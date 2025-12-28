
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select subscription_start_date
from "dev"."main"."silver__fact_subscriptions"
where subscription_start_date is null



  
  
      
    ) dbt_internal_test