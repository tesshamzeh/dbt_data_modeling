
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "dev"."main"."bronze__customers"
    group by status

)

select *
from all_values
where value_field not in (
    
)


