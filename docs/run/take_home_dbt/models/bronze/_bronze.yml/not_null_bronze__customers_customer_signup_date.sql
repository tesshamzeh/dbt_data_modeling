
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_signup_date
from "dev"."main"."bronze__customers"
where customer_signup_date is null



  
  
      
    ) dbt_internal_test