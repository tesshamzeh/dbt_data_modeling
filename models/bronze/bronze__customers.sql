select 
    try_cast(id as string) as customer_id, 
    try_cast(signup_date as date) as customer_signup_date, 
    try_cast(status as string) as customer_status,
    try_cast(region as string) as customer_region,
    {{ source('raw_data', 'customers') }} as data_source
from {{ source('raw_data', 'customers') }}