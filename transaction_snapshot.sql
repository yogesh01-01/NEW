{% snapshot transaction_snapshot %}

{{
    config(
        target_schema = 'dbt_s',
        target_database = 'interview',
        unique_key = 'user_id',
        strategy = 'timestamp',
        updated_at = 'transaction_timestamp'
    )
}}

select *
from {{ ref('stg_transaction') }}

{% endsnapshot %}
