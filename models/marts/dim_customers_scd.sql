{{ config(materialized='table') }}

select
    customer_id,
    first_name,
    last_name,
    email,

    dbt_valid_from,
    dbt_valid_to,

    -- current record flag
    case
        when dbt_valid_to is null then true
        else false
    end as is_current

from {{ ref('customers_snapshot') }}
