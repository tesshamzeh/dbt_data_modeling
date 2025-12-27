select 
    plan_id, 
    plan_name, 
    plan_monthly_price
from {{ ref('bronze__plans') }}