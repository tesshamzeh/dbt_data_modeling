select 
    try_cast(id as string) as plan_id, 
    try_cast(plan_name as string) as plan_name, 
    try_cast(monthly_price as decimal(10,2)) as plan_monthly_price,
    'raw_data/plans.csv' as data_source
from {{ source('raw_data', 'plans') }}