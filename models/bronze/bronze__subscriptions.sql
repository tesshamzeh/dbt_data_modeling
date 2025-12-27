select 
    id as subscription_id, 
    customer_id,
    plan_id, 
    start_date,
    end_date
from {{ source('raw_data', 'subscriptions') }}