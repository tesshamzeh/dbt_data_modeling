select 
    try_cast(id as string) as customer_id, 
    try_cast(signup_date as date) as customer_signup_date, 
    try_cast(status as string) as customer_status,
    try_cast(region as string) as customer_region
from {{ source('raw_data', 'customers') }}