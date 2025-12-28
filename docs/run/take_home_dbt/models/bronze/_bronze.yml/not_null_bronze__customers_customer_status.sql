
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_status
from "dev"."main"."bronze__customers"
where customer_status is null



  
  
      
    ) dbt_internal_test