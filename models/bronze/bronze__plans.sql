select 
    id as plan_id, 
    plan_name, 
    monthly_price
from {{ source('raw_data', 'plans') }}