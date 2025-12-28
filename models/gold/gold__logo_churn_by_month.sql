-- monthly logo churn rate calculation: 
-- (# customers active last month but not this month [aka churned]) / (# customers active last month)

-- each month and each (distinct) customer
with monthly_customers as (
    select distinct
        year_month,
        customer_id
    from {{ ref('gold__subscriptions_by_month') }}
),

-- get maximum month for churn calculation logic
upper_month_bound as (
    select
        max(year_month) as max_month
    from monthly_customers
),

-- number of customers churned per month (present in month M but not in month M+1; numerator of churn rate)
churned as (
    select
        prev.year_month + interval '1 month' as year_month,
        count(distinct prev.customer_id) as churned_customers
    from monthly_customers prev
    left join monthly_customers curr
        on curr.customer_id = prev.customer_id
        and curr.year_month = prev.year_month + interval '1 month'
    where 
        curr.customer_id is null
        -- don't count churn for "future months"
        and (prev.year_month + interval '1 month') <= (select max_month from upper_month_bound)
    group by 
        all
),

-- get number of customers active last month (denominator of churn rate)
customers_active_last_month as (
    select
        year_month + interval '1 month' as year_month,
        count(distinct customer_id) as active_customers_last_month
    from monthly_customers
    group by 
        all
)

select
    cast(active.year_month as date) as year_month,
    coalesce(churned.churned_customers, 0) as churned_customers,
    active.active_customers_last_month,
    round(coalesce(churned.churned_customers, 0) * 1.0
    / nullif(active.active_customers_last_month, 0),2) as logo_churn_rate
from customers_active_last_month as active
left join churned
  on active.year_month = churned.year_month
order by 
    active.year_month