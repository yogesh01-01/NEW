{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id'
    )
}}

select 
  customer_id,
  initcap(nullif(trim(first_name), '')) as first_name,
  initcap(nullif(trim(last_name), ''))  as last_name,
  lower(nullif(trim(email), ''))         as email,
  cast(created_at as date)               as customer_created_at
from {{ source('yogesh', 'customers') }}

qualify row_number() over (
  partition by customer_id 
  order by created_at desc
) = 1


