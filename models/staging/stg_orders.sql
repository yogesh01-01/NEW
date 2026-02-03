with source as (

    select *
    from {{ source('aarvi', 'orders') }}

),

-- 1️⃣ Remove bad records
filtered as (

    select *
    from source
    where order_id is not null
      and customer_id is not null
      and amount > 0
      and order_date is not null
      and order_date <= current_date

),

-- 2️⃣ Deduplicate orders
deduplicated as (

    select *
    from (
        select
            *,
            row_number() over (
                partition by order_id
                order by order_date desc
            ) as rn
        from filtered
    )
    where rn = 1

),

-- 3️⃣ Standardize & clean columns
cleaned as (

    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,

        -- Normalize order status
        case
            when lower(status) in ('completed', 'complete', 'done') then 'COMPLETED'
            when lower(status) in ('pending', 'in_progress') then 'PENDING'
            when lower(status) in ('cancelled', 'canceled') then 'CANCELLED'
            else 'UNKNOWN'
        end as status,

        round(amount, 2) as amount
    from deduplicated

)

select * from cleaned
