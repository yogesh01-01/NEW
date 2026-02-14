{% snapshot customers_sanpshot %}
    {{
        config(
            target_schema='sanpshot',
            target_database='interview',
            unique_key='customer_id',
            strategy='timestamp',
            invalidate_hard_deletes=true,
            updated_at='updated_at_field'
        )
    }}

    select * from {{ ref('stg_customers') }}
 {% endsnapshot %}