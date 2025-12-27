select 
    try_cast(id as string) as subscription_id, 
    try_cast(customer_id as string) as customer_id,
    try_cast(plan_id as string) as plan_id, 
    try_cast(start_date as date) as subscription_start_date,
    try_cast(end_date as date) as subscription_end_date,
    'data/subscriptions.csv' as data_source
from {{ source('raw_data', 'subscriptions') }}