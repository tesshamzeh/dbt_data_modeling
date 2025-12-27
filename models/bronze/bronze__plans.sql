select 
    try_cast(id as string) as plan_id, 
    try_cast(plan_name as string) as plan_name, 
    try_cast(monthly_price as integer) as plan_monthly_price
from {{ source('raw_data', 'plans') }}