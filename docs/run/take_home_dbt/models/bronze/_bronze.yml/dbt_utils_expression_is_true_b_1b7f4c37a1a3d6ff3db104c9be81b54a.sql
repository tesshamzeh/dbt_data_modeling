
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "dev"."main"."bronze__subscriptions"

where not(subscription_end_date is null or subscription_end_date >= subscription_start_date)


  
  
      
    ) dbt_internal_test