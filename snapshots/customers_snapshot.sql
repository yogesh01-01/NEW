{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='created_at'
    )
}}

select *
from {{ source('yogesh', 'customers') }}

{% endsnapshot %}
