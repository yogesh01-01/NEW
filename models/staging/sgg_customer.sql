{{
    config(
        materialized='view'
    )
}}

select * from {{ source('aarvi', 'customer') }}