
  
  create view "dev"."main"."testing_ingress__dbt_tmp" as (
    select * from 'data/customers.csv'
  );
