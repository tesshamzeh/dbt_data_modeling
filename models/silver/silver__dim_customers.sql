select 
    customer_id, 
    customer_signup_date, 
    customer_status,
    customer_region
from {{ ref('bronze__customers') }}