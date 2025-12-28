





with validation_errors as (

    select
        year_month, subscription_id
    from "dev"."main"."gold__subscriptions_by_month"
    group by year_month, subscription_id
    having count(*) > 1

)

select *
from validation_errors


