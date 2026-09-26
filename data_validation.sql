-- data_validation.sql
-- Basic data quality and relationship checks for the Olist ecommerce dataset.

-- 1. Validate order-to-customer relationship
SELECT
  o.order_id,
  o.order_status,
  c.customer_city,
  c.customer_state
FROM `ecommerce_raw.orders` AS o
JOIN `ecommerce_raw.customers` AS c
  ON o.customer_id = c.customer_id
LIMIT 10;


-- 2. Check order distribution by state
SELECT
  c.customer_state,
  COUNT(*) AS total_orders
FROM `ecommerce_raw.orders` AS o
JOIN `ecommerce_raw.customers` AS c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;


-- 3. Review distinct customer cities
SELECT DISTINCT
  customer_city
FROM `ecommerce_raw.customers`
ORDER BY customer_city
LIMIT 20;


-- 4. Check for invalid prices
SELECT
  COUNT(*) AS bad_price_count
FROM `ecommerce_raw.order_items`
WHERE price <= 0;


-- 5. Check for duplicate order-item records
SELECT
  order_id,
  order_item_id,
  COUNT(*) AS row_count
FROM `ecommerce_raw.order_items`
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;
