
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select year_month
from "dev"."main"."gold__subscriptions_by_month"
where year_month is null



  
  
      
    ) dbt_internal_test