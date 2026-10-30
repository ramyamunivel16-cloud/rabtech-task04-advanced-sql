-- Run schema.sql and seed_data.sql first.
-- Revenue = quantity * unit_price. Cancelled orders excluded unless noted.

-- Q1 CTE: revenue for each non-cancelled order.
WITH order_totals AS (
 SELECT o.order_id,o.customer_id,o.order_date,
        SUM(i.quantity*i.unit_price) AS revenue
 FROM orders o JOIN order_items i USING(order_id)
 WHERE o.order_status <> 'CANCELLED'
 GROUP BY o.order_id,o.customer_id,o.order_date
)
SELECT * FROM order_totals ORDER BY order_id;

-- Q2 CTE: total revenue for every customer, including customers with no orders.
WITH customer_sales AS (
 SELECT c.customer_id,c.customer_name,
        COALESCE(SUM(i.quantity*i.unit_price),0) AS revenue
 FROM customers c
 LEFT JOIN orders o ON o.customer_id=c.customer_id AND o.order_status <> 'CANCELLED'
 LEFT JOIN order_items i ON i.order_id=o.order_id
 GROUP BY c.customer_id,c.customer_name
)
SELECT * FROM customer_sales ORDER BY revenue DESC;

-- Q3 Recursive CTE: generate month starts from January through May 2026.
WITH RECURSIVE months(month_start) AS (
 SELECT DATE '2026-01-01'
 UNION ALL
 SELECT (month_start + INTERVAL '1 month')::DATE
 FROM months WHERE month_start < DATE '2026-05-01'
)
SELECT month_start FROM months ORDER BY month_start;

-- Q4 ROW_NUMBER: number each customer's orders newest first.
SELECT customer_id,order_id,order_date,
 ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC,order_id DESC) AS order_number
FROM orders ORDER BY customer_id,order_number;

-- Q5 RANK: rank products by units sold; ties share rank.
WITH units AS (
 SELECT p.product_id,p.product_name,COALESCE(SUM(i.quantity),0) AS units_sold
 FROM products p LEFT JOIN order_items i USING(product_id)
 GROUP BY p.product_id,p.product_name
)
SELECT product_name,units_sold,RANK() OVER(ORDER BY units_sold DESC) AS sales_rank
FROM units ORDER BY sales_rank,product_name;

-- Q6 DENSE_RANK: rank customers by non-cancelled revenue without rank gaps.
WITH revenue AS (
 SELECT c.customer_id,c.customer_name,COALESCE(SUM(i.quantity*i.unit_price),0) AS total
 FROM customers c
 LEFT JOIN orders o ON o.customer_id=c.customer_id AND o.order_status <> 'CANCELLED'
 LEFT JOIN order_items i ON i.order_id=o.order_id
 GROUP BY c.customer_id,c.customer_name
)
SELECT customer_name,total,DENSE_RANK() OVER(ORDER BY total DESC) AS revenue_rank
FROM revenue ORDER BY revenue_rank,customer_name;

-- Q7 LAG: compare monthly revenue with previous month.
WITH monthly AS (
 SELECT DATE_TRUNC('month',o.order_date)::DATE AS sales_month,
        SUM(i.quantity*i.unit_price) AS revenue
 FROM orders o JOIN order_items i USING(order_id)
 WHERE o.order_status <> 'CANCELLED'
 GROUP BY DATE_TRUNC('month',o.order_date)
)
SELECT sales_month,revenue,LAG(revenue) OVER(ORDER BY sales_month) AS previous_revenue,
 revenue-LAG(revenue) OVER(ORDER BY sales_month) AS revenue_change
FROM monthly ORDER BY sales_month;

-- Q8 LEAD: show each customer's next order date.
SELECT customer_id,order_id,order_date,
 LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date,order_id) AS next_order_date
FROM orders ORDER BY customer_id,order_date;

-- Q9 Running total: cumulative revenue, restarting for each customer.
WITH per_order AS (
 SELECT o.customer_id,o.order_id,o.order_date,SUM(i.quantity*i.unit_price) AS revenue
 FROM orders o JOIN order_items i USING(order_id)
 WHERE o.order_status <> 'CANCELLED'
 GROUP BY o.customer_id,o.order_id,o.order_date
)
SELECT customer_id,order_id,order_date,revenue,
 SUM(revenue) OVER(PARTITION BY customer_id ORDER BY order_date,order_id
 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue
FROM per_order ORDER BY customer_id,order_date;

-- Q10 INNER JOIN: list purchased products with customer and order details.
SELECT o.order_id,c.customer_name,p.product_name,i.quantity,i.unit_price,
 i.quantity*i.unit_price AS line_total
FROM orders o
JOIN customers c USING(customer_id)
JOIN order_items i USING(order_id)
JOIN products p USING(product_id)
ORDER BY o.order_id,p.product_name;

-- Q11 LEFT JOIN: find products never ordered.
SELECT p.product_id,p.product_name
FROM products p LEFT JOIN order_items i USING(product_id)
WHERE i.item_id IS NULL ORDER BY p.product_id;

-- Q12 FULL OUTER JOIN: compare two city groups. Unique customer IDs mean
-- the groups do not overlap, so each city's customers appear as unmatched rows.
WITH cb AS (SELECT customer_id,customer_name FROM customers WHERE city='Coimbatore'),
     ch AS (SELECT customer_id,customer_name FROM customers WHERE city='Chennai')
SELECT COALESCE(cb.customer_id,ch.customer_id) AS customer_id,
       cb.customer_name AS coimbatore_customer,ch.customer_name AS chennai_customer
FROM cb FULL OUTER JOIN ch USING(customer_id)
ORDER BY customer_id;

-- Q13 Subquery: products priced above the average product price.
SELECT product_name,price FROM products
WHERE price > (SELECT AVG(price) FROM products) ORDER BY price DESC;

-- Q14 Subquery: customers whose revenue exceeds average customer revenue.
WITH revenue AS (
 SELECT c.customer_id,c.customer_name,COALESCE(SUM(i.quantity*i.unit_price),0) AS total
 FROM customers c
 LEFT JOIN orders o ON o.customer_id=c.customer_id AND o.order_status <> 'CANCELLED'
 LEFT JOIN order_items i ON i.order_id=o.order_id
 GROUP BY c.customer_id,c.customer_name
)
SELECT customer_name,total FROM revenue
WHERE total > (SELECT AVG(total) FROM revenue)
ORDER BY total DESC;
