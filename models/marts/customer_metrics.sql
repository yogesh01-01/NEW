select
    customer_id,
    count(order_id) as total_orders,
    sum(order_amount) as total_spent
from {{ ref('fact_orders') }}
group by customer_id
