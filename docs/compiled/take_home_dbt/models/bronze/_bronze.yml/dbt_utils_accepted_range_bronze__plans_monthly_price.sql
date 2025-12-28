

with meet_condition as(
  select *
  from "dev"."main"."bronze__plans"
),

validation_errors as (
  select *
  from meet_condition
  where
    -- never true, defaults to an empty result set. Exists to ensure any combo of the `or` clauses below succeeds
    1 = 2
)

select *
from validation_errors

