{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id'
    )
}}

select
    customer_id,
    first_name,
    last_name,
    email,
    customer_created_at
from {{ ref('stg_customers') }}

{% if is_incremental() %}
where customer_created_at > (
    select max(customer_created_at)
    from {{ this }}
)
{% endif %}

qualify row_number() over (
    partition by customer_id
    order by customer_created_at desc
) = 1
