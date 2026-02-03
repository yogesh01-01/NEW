select
    o.order_id,
    o.order_date,
    o.order_amount,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
from {{ ref('fact_orders') }} o
left join {{ ref('dim_customers_scd') }} c
    on o.customer_id = c.customer_id
   and o.order_date >= c.dbt_valid_from
   and (o.order_date < c.dbt_valid_to or c.dbt_valid_to is null)
