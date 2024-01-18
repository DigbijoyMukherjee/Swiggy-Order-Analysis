-- 1. What is the average number of customers per day?
SELECT 
    COUNT(order_id) / COUNT(DISTINCT date) AS average_customers_per_day
FROM
    orders;
-- 2. How many pizzas are typically in an order?
SELECT 
    COUNT(order_details_id) / COUNT(DISTINCT order_id) AS avg_no_of_pizzas_per_order
FROM
    order_details;
-- 3. Do we have any bestsellers?
SELECT 
    pt.name AS pizza_name,
    ROUND(SUM(p.price * od.quantity), 2) AS revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC; 
-- ****** 4. How many pizzas are we making during peak hour?
SELECT 
    time,
    COUNT(DISTINCT (o.order_id)) AS total_orders,
    COUNT(quantity) AS total_quantity
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY time
ORDER BY total_orders DESC;

-- 5. Are there any peak hour?
SELECT 
    COUNT(order_id) AS orders, HOUR(time) AS Hour
FROM
    orders
GROUP BY Hour
ORDER BY orders DESC;
-- 3. Are there any crest hours?
SELECT 
    COUNT(order_id) AS orders, HOUR(time) AS Hour
FROM
    orders
GROUP BY Hour
ORDER BY orders ASC;

-- 6. Are there any peak Days?
SELECT 
    date, COUNT(order_id) AS orders
FROM
    orders
GROUP BY date
ORDER BY orders DESC;

-- 5. Are there any crest Days?
SELECT 
    date, COUNT(order_id) AS orders
FROM
    orders
GROUP BY date
ORDER BY orders ASC;

-- 7. Which month experienced the highest number of orders?
SELECT count(order_id) as orders, month(date)
FROM orders
GROUP BY month(date) 
ORDER BY orders DESC;

-- 8. What is the total revenue from 2015?
SELECT ROUND(SUM(p.price * od.quantity),2) AS Revenue
FROM  pizzas p
JOIN order_details od
ON p.pizza_id = od.pizza_id;

-- 9. Which month had the highest revenue?
SELECT monthname((date)) as month, ROUND(SUM(p.price),2) AS total_price
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY month
ORDER BY total_price DESC;

-- 10. What are top-selling pizza sizes?
SELECT p.size as size, SUM(od.quantity) AS quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY quantity DESC;

-- 11. What pizza categories are ordered?
SELECT pt.category, SUM(od.quantity) AS quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

-- 12. What is the average order value?
SELECT ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id),2) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 13. What is the average price per pizza?
SELECT ROUND(AVG(price),2) AS average_price_per_pizza
FROM pizzas;
-- 14. How many orders are in total?
SELECT count(order_id) AS no_of_orders
FROM orders;
-- 15. What is the quantity of pizzas sold?
SELECT count(quantity) as quantity
FROM order_details;
-- 16. How many different pizza varieties are on the menu?
SELECT count(*) AS pizza_varieties 
FROM pizza_types;
-- 17. Which ingredients are the most popularly ordered?
SELECT DISTINCT(TRIM(value)) AS ingredient, COUNT(TRIM(value)) AS count
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
CROSS APPLY STRING_SPLIT(pt.ingredients, ',') AS ingredients_split
GROUP BY TRIM(value)
ORDER BY count DESC;

-- 18. What is the distribution of order quantities by time of day?
SELECT
    CASE
        WHEN o.time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN o.time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN o.time BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
   	    ELSE 'Night'
    END AS time_of_day,
    SUM(od.quantity) AS total_quantity
FROM
    orders o
JOIN
    order_details od
ON o.order_id = od.order_id
GROUP BY
    CASE
        WHEN o.time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN o.time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN o.time BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
   	    ELSE 'Night'
    END
ORDER BY
    time_of_day;