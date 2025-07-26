CREATE TABLE swiggy_funnel (
    user_id TEXT,
    city TEXT,
    visit_date DATE,
    restaurant_viewed TEXT,
    added_to_cart INT,
    order_placed INT,
    payment_done INT,
    is_cancelled INT,
    order_delivered INT
);


Select * from swiggy_funnel limit 5


--User Drop-Off at Each Funnel Stage
SELECT 
  COUNT(DISTINCT user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN restaurant_viewed IS NOT NULL THEN user_id END) AS viewed_restaurants,
  COUNT(DISTINCT CASE WHEN added_to_cart = 1 THEN user_id END) AS added_to_cart,
  COUNT(DISTINCT CASE WHEN order_placed = 1 THEN user_id END) AS orders_placed,
  COUNT(DISTINCT CASE WHEN payment_done = 1 THEN user_id END) AS payment_done,
  COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN user_id END) AS cancelled_orders,
  COUNT(DISTINCT CASE WHEN order_delivered = 1 THEN user_id END) AS delivered_orders
FROM swiggy_funnel;


--Cart to Order Conversion Rate
SELECT 
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN order_placed = 1 THEN user_id END) / 
    NULLIF(COUNT(DISTINCT CASE WHEN added_to_cart = 1 THEN user_id END), 0), 2
  ) AS cart_to_order_conversion
FROM swiggy_funnel;



--Order Cancellation Rate
SELECT 
  ROUND(
    100.0 * SUM(CASE WHEN is_cancelled = 1 THEN 1 ELSE 0 END) / 
    NULLIF(SUM(CASE WHEN order_placed = 1 THEN 1 ELSE 0 END), 0), 2
  ) AS cancel_rate_percent
FROM swiggy_funnel;


--Overall Order Delivery Rate
SELECT 
  ROUND(
    100.0 * COUNT(CASE WHEN order_delivered = 1 THEN 1 END) / 
    NULLIF(COUNT(CASE WHEN order_placed = 1 THEN 1 END), 0), 2
  ) AS delivery_success_rate
FROM swiggy_funnel;


--City-Wise Funnel Breakdown
SELECT 
  city,
  COUNT(*) AS total,
  COUNT(CASE WHEN order_placed = 1 THEN 1 END) AS placed,
  COUNT(CASE WHEN order_delivered = 1 THEN 1 END) AS delivered,
  ROUND(100.0 * COUNT(CASE WHEN order_delivered = 1 THEN 1 END) / NULLIF(COUNT(CASE WHEN order_placed = 1 THEN 1 END), 0), 2) AS city_delivery_rate
FROM swiggy_funnel
GROUP BY city
ORDER BY city_delivery_rate DESC;

