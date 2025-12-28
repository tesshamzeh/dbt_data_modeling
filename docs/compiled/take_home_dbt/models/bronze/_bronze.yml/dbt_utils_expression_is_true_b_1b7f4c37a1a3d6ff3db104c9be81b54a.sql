



select
    1
from "dev"."main"."bronze__subscriptions"

where not(subscription_end_date is null or subscription_end_date >= subscription_start_date)

