-- revenue_by_state.sql
-- Revenue, order volume, and average order value by customer state.

SELECT
  c.customer_state,
  ROUND(SUM(p.payment_value), 2) AS total_revenue,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(
    SUM(p.payment_value) / COUNT(DISTINCT o.order_id),
    2
  ) AS avg_order_value
FROM `ecommerce_raw.orders` AS o
JOIN `ecommerce_raw.customers` AS c
  ON o.customer_id = c.customer_id
JOIN `ecommerce_raw.order_payments` AS p
  ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
