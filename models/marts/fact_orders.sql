with orders as (

    select * from {{ ref('int_customer_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

)

select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    o.amount as order_amount,
    p.payment_method,
    p.payment_status
from orders o
left join payments p
    on o.order_id = p.order_id
