use olist_store_analysis;
-- #KPI 1
-- 1).Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT day_type,total_payment,CONCAT(ROUND((total_payment / (SELECT SUM(payment_value) 
FROM olist_order_payments_dataset) * 100), 0), '%') AS percentage_total_payment
FROM (SELECT CASE WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
ELSE 'Weekday'
END AS day_type,
ROUND(SUM(p.payment_value),0) AS total_payment
FROM olist_orders_dataset o JOIN olist_order_payments_dataset p 
ON o.order_id = p.order_id
GROUP BY day_type) AS day_type_totals;

--  --------------------------------------------------------------------------------------------------------------------------------
-- #KPI 2
-- 2).Number of Orders with review score 5 and payment type as credit card
SELECT payment_type,`olist_order_reviews_dataset.review_score` AS Review_score,
count(*) AS number_of_orders
 FROM data_2  WHERE 
`olist_order_reviews_dataset.review_score`=5
AND payment_type = "credit_card" ;

-- --------------------------------------------------------------------------------------------------------------------------------
-- #KPI 3
-- 3) Average number of days taken for order_delivered_customer_date for pet_shop
SELECT product_category_name,ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))) 
AS avg_days 
FROM olist_orders_dataset INNER JOIN olist_order_items_dataset
ON olist_orders_dataset.order_id=olist_order_items_dataset.order_id
INNER JOIN olist_products_dataset 
ON olist_order_items_dataset.product_id=olist_products_dataset.product_id 
WHERE product_category_name="pet_shop" ;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- #KPI 4
-- 4) Average price and payment values from customers of sao paulo city
SELECT customer_city, FORMAT(AVG(price),0) AS avg_price,FORMAT(AVG(payment_value),0) AS avg_payment_value 
FROM olist_order_payments_dataset INNER JOIN olist_order_items_dataset 
ON olist_order_payments_dataset.order_id = olist_order_items_dataset.order_id
INNER JOIN olist_orders_dataset 
ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
INNER JOIN olist_customers_dataset 
ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id 
WHERE customer_city="sao paulo";

-- -----------------------------------------------------------------------------------------------------------------------------------
-- #KPI 5
-- 5) Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
SELECT  `olist_order_reviews_dataset.review_score` AS Review_score,
ROUND(AVG(DATEDIFF(order_delivered_customer_date,order_purchase_timestamp))) AS Avg_Shipping_days 
FROM data_2 INNER JOIN olist_orders_dataset
ON olist_orders_dataset.order_id=data_2.order_id
GROUP BY Review_score
ORDER BY Review_score; 

















