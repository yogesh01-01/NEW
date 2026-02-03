{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='CUSTOMER_ID',
        strategy='check',
        check_cols=['FIRST_NAME', 'LAST_NAME', 'EMAIL']
    )
}}

select
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    CREATED_AT
from banking_db.bank.customers

{% endsnapshot %}
