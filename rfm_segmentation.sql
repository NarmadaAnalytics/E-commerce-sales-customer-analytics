-- rfm_segmentation.sql
-- Customer RFM-style segmentation using recency, frequency, and monetary value.

WITH rfm AS (
  SELECT
    c.customer_unique_id,
    DATE_DIFF(
      CURRENT_DATE(),
      MAX(DATE(o.order_purchase_timestamp)),
      DAY
    ) AS recency_days,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(p.payment_value), 2) AS monetary
  FROM `ecommerce_raw.orders` AS o
  JOIN `ecommerce_raw.customers` AS c
    ON o.customer_id = c.customer_id
  JOIN `ecommerce_raw.order_payments` AS p
    ON o.order_id = p.order_id
  GROUP BY c.customer_unique_id
),

segmented AS (
  SELECT
    *,
    CASE
      WHEN frequency >= 3 AND monetary >= 500 THEN 'Champion'
      WHEN frequency >= 2 THEN 'Loyal'
      WHEN monetary >= 500 THEN 'Big Spender'
      ELSE 'One-time Buyer'
    END AS segment
  FROM rfm
)

SELECT
  segment,
  COUNT(*) AS customer_count,
  ROUND(AVG(monetary), 2) AS avg_spend
FROM segmented
GROUP BY segment
ORDER BY customer_count DESC;
