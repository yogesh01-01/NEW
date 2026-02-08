{% snapshot payments_snapshot %}

{{
    config(
        target_schema='snapshots',
        target_database='banking_db',
        unique_key='PAYMENT_ID',
        strategy='timestamp',
        updated_at='UPDATED_AT',
        invalidate_hard_deletes=True
    )
}}

with source_data as (

    select
        PAYMENT_ID,
        ORDER_ID,

        -- clean payment method
        upper(trim(PAYMENT_METHOD)) as PAYMENT_METHOD,

        -- normalize status
        lower(trim(PAYMENT_STATUS)) as raw_status,

        UPDATED_AT
    from {{ source('yogesh', 'payments') }}
    where PAYMENT_ID is not null
)

select
    PAYMENT_ID,
    ORDER_ID,
    PAYMENT_METHOD,

    case
        when raw_status in ('completed', 'success') then 'SUCCESS'
        when raw_status in ('failed', 'declined') then 'FAILED'
        when raw_status in ('pending', 'processing') then 'PENDING'
        else 'UNKNOWN'
    end as PAYMENT_STATUS,

    UPDATED_AT

from source_data

{% endsnapshot %}
