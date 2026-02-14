{{ 
    config(
        materialized='incremental',
        unique_key='transaction_id'
    ) 
}}

SELECT
    txn_id            AS transaction_id,
    usr_id            AS user_id,
    mrc_id            AS merchant_id,
    amount,
    txn_dt            AS transaction_timestamp,
    txn_type          As tnx_type,
    TO_DATE(txn_dt)   AS transaction_date

FROM {{ source('my_raw', 'transactions') }}

WHERE
    txn_id IS NOT NULL
    AND usr_id IS NOT NULL
    AND mrc_id IS NOT NULL
    AND amount > 0
    AND txn_dt IS NOT NULL

{% if is_incremental() %}
    AND txn_dt > (
        SELECT MAX(transaction_timestamp)
        FROM {{ this }}
    )
{% endif %}
