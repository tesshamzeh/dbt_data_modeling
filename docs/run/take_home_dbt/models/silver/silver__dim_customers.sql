
  
    
    

    create  table
      "dev"."main"."silver__dim_customers__dbt_tmp"
  
    as (
      select 
    customer_id, 
    customer_signup_date, 
    customer_status,
    customer_region
from "dev"."main"."bronze__customers"
    );
  
  