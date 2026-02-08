with source as (

    select *
    from {{ source('yogesh', 'payments') }}

),

-- 1️⃣ Remove invalid records
filtered as (

    select *
    from source
    where payment_id is not null
      and order_id is not null

),

-- 2️⃣ Deduplicate payments
deduplicated as (

    select *
    from (
        select
            *,
            row_number() over (
                partition by payment_id
                order by order_id
            ) as rn
        from filtered
    )
    where rn = 1

),

-- 3️⃣ Clean & standardize columns
cleaned as (

    select
        payment_id,
        order_id,

        -- Normalize payment method
        case
            when payment_method is null then 'UNKNOWN'
            when lower(trim(payment_method)) in ('cc', 'credit card', 'card') then 'CREDIT_CARD'
            when lower(trim(payment_method)) in ('debit', 'debit card') then 'DEBIT_CARD'
            when lower(trim(payment_method)) in ('upi', 'gpay', 'phonepe') then 'UPI'
            when lower(trim(payment_method)) in ('cash') then 'CASH'
            else 'OTHER'
        end as payment_method,

        -- Normalize payment status
        case
            when payment_status is null then 'UNKNOWN'
            when lower(trim(payment_status)) in ('success', 'successful', 'completed') then 'SUCCESS'
            when lower(trim(payment_status)) in ('failed', 'failure') then 'FAILED'
            when lower(trim(payment_status)) in ('pending', 'in_progress') then 'PENDING'
            else 'UNKNOWN'
        end as payment_status

    from deduplicated

)

select * from cleaned
