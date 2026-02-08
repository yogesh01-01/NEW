with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

)

select
    o.order_id,
    o.order_date,
    o.status,
    o.amount,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
from orders o
left join customers c
    on o.customer_id = c.customer_id
