{{ config(
    materialized='incremental',
    unique_key='customer_id',
    incremental_strategy='merge'
) }}


select
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    country,
    signup_timestamp,
    updated_at
from {{ source('raw_data', 'customers') }}
