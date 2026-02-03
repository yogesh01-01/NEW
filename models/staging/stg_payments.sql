with source as (

    select *
    from {{ source('aarvi', 'payments') }}

),

-- 1️⃣ Filter invalid records
filtered as (

    select *
    from source
    where payment_id is not null
      and order_id is not null
      and amount > 0
      and payment_date is not null
      and payment_date <= current_date()

),

-- 2️⃣ Deterministic deduplication
deduplicated as (

    select *
    from (
        select
            *,
            row_number() over (
                partition by payment_id
                order by payment_date desc, amount desc
            ) as rn
        from filtered
    )
    where rn = 1

),

-- 3️⃣ Clean & standardize
cleaned as (

    select
        payment_id,
        order_id,
        cast(payment_date as date) as payment_date,

        case
            when payment_method is null then 'OTHER'
            when lower(trim(payment_method)) in ('cc', 'credit card', 'card') then 'CREDIT_CARD'
            when lower(trim(payment_method)) in ('debit card', 'debit') then 'DEBIT_CARD'
            when lower(trim(payment_method)) in ('upi', 'gpay', 'phonepe') then 'UPI'
            when lower(trim(payment_method)) in ('net banking', 'netbanking') then 'NET_BANKING'
            when lower(trim(payment_method)) = 'cash' then 'CASH'
            else 'OTHER'
        end as payment_method,

        round(amount, 2) as payment_amount
    from deduplicated

)

select * from cleaned
