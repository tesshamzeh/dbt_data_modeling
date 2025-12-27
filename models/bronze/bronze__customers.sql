select 
    id as customer_id, 
    signup_date, 
    status,
    region
from {{ source('raw_data', 'customers') }}