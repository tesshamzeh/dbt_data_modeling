# dbt Take-Home Assessment

This repo contains a dbt project that transforms raw `customers`, `plans`, and `subscriptions` data into clean models, including a report called [gold__report_metrics_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__report_metrics_by_month.sql) that provides `Active Customers`, `Monthly Recurring Revenue`, and `Logo Churn Rate` at a monthly grain. 

For a static copy of the docs website for this project (generated via `dbt docs generate`), see [here](https://tesshamzeh.github.io/dbt_data_modeling/#!/overview). 

To run this code yourself, see [requirements](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/requirements.txt).

## Rationale

### Assumptions

- Given the nature of a take-home assessment and the short timeframe, I assumed the three data sources `id` columns were their primary keys, thus assuming that each `id` was unique and not null and represented a single customer, plan, or subscription (thus I did not have to create more complex surrogate primary keys since I lacked the context). 
- For the `customers` data, I assumed / it seemed that it was the **current** status for a customer reflected in the table, as evidenced by the fact that there is not another line for C3 for when they had been active.
- For the `plans` data, I assumed that the `monthly_price` values are the **only** prices these plans have ever had, and that this list of plans is exhaustive. 
- For the `subscriptions` data, I assumed a null `end_date` meant the subscription was still active. 
- For calculating **all** reporting metrics, if a customer's subscription was active at least one day in a month, they counted as an active customer for that month. This is something I would alter to be more reflective of real-world conditions if I had more time (see [Proposed Next Steps](#proposed-next-steps) section). 
- I assumed there would be at least one active subscription in the dataset to establish the reporting window. With more time, I would instead generate a fixed calendar spine through the current date.”

### Design Choices

#### Models 
- Given the relatively simple nature of the data and clear reporting requirements, I opted for a medallion architecture with the following logic for each layer to ensure easy usability of source data: 
    - [Bronze](https://github.com/tesshamzeh/dbt_data_modeling/tree/main/models/bronze): extremely minimal transformation of data; just renaming fields to be more descriptive and casting data types explicitly. 
    - [Silver](https://github.com/tesshamzeh/dbt_data_modeling/tree/main/models/silver): standardize bronze models into dimension tables (customers and plans) and a fact table (subscriptions, with monthly plan priced joined to subscription data since this is the numeric fact of interest).
        - Note: the silver dim tables were not used in gold, but are still good practice to include if a finer grain, like customer region, were needed.
    - [Gold](https://github.com/tesshamzeh/dbt_data_modeling/tree/main/models/gold): use silver fact model to implement business logic into pre-reporting models, which are then used to create the final reporting model. 
        - **Use a month-spine and monthly grain (since monthly metrics are required)** to create one row per active subscription month in [gold__subscriptions_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__subscriptions_by_month.sql). 
        - Use [gold__subscriptions_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__subscriptions_by_month.sql) to calculate `Active Customers` and `Monthly Recurring Revenue` in the final reporting model, [gold__report_metrics_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__report_metrics_by_month.sql). 
        - Since `Logo Churn Rate` is a complex calculation, it was calculated using [gold__subscriptions_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__subscriptions_by_month.sql) in a separate model, [gold__logo_churn_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__logo_churn_by_month.sql), then joined with [gold__subscriptions_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__subscriptions_by_month.sql) in [gold__report_metrics_by_month](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/gold__report_metrics_by_month.sql) for the final monthly report of `Active Customers`, `Monthly Recurring Revenue`, and `Logo Churn Rate` (see [docs](https://tesshamzeh.github.io/dbt_data_modeling/#!/overview) and gold models for more detail on metrics calculation).

#### Sources
- In order to demonstrate use of the `source()` function as required, I stored the raw CSVs in the [data](https://github.com/tesshamzeh/dbt_data_modeling/tree/main/data) folder then added them to [sources.yml](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/sources.yml). Obviously, these would usually be ingressed from a database connection and actual static CSVs would live in the seeds folder. 

#### Schemas 
- I created schema.yml files for each data layer (named for that layer) for easy reference rather than one schema.yml for the entire project. I prefix each file's name with an underscore to order it at the top of the folder for further easy reference (e.g., [_gold.yml](https://github.com/tesshamzeh/dbt_data_modeling/blob/main/models/gold/_gold.yml)). 
- I implemented basic tests like primary key integrity, foreign key integrity, and accepted numeric value ranges. 

### Tradeoffs

- I chose to expand the subscriptions data using a month spine to create a row of data per active subscription month. This led to easier and more straightforward reporting of required metrics, but could easily balloon into a large table for many long-held subscriptions. To combat this, I would materialize the model as an incremental table to reduce query costs. 
- I chose to materialize the gold models as views to ensure receiving the latest results quickly. However, if these calculations were more complex or as the dataset grows, these views could become slower or more expensive, and incremental tables might be preferred here as well. 

## Proposed Next Steps 
- I would create a physical model of the data layer progression for high level understanding, as well as a logical model (ERD) to easily illustrate the relationships and data flow. 
- I would ensure data is deduplicated and models are materialized accurately to their needs (e.g., an incremental materialization for a large table). 
- I would create a formal semantic layer in dbt or the data warehouse for easy reuse of business logic across multiple downstream platforms. 
- Given the simplicity of the provided data, the medalltion architeciture was sufficient for transforming the raw tables into monthly reporting metrics. However, for more complex, real-world data coming from many sources, rather than a medallion architecture, I would implement more layers for greater clarity in the transformation steps (a combination of `ingress`, `raw`, `stage`, `entity`, `pivot`, `reporting`, `export` data layers as needed). 
- To handle the likely changing data in `plans`, I would implement snapshots to capture these changes and track revenue accurately. A similar setup for `customers` would also be prudent to capture customers that may leave and come back. 
-  I noticed that `customers.id` = "C2" had `status` = "active" which contradicts its existing `end_date` in `subscriptions`. I ignored this since it didn't impact my reporting logic, but I would create a custom test that compares `customers.status` and `subscriptions.end_date` if I had more time. 
- As mentioned in the [Assumptions](#assumptions) section, I would alter the logic for counting a subscription as active if it is only active for part of a month, particularly for the calculation of monthly recurring revenue: I would prorate the first month's revenue based on the start date, then charge for a full month as long as the customer was active on the first day of the month for the following months. 

