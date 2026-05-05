-- =============================================
-- SQL Drills · Chinook Database · CTEs
-- Martin James Ng'ang'a · github.com/M20Jay
-- =============================================

-- Exercise 1: Your First CTE
-- Find all customers with at least one invoice > 10
-- Tables: customer, invoice

WITH high_value_customers AS (
    SELECT DISTINCT c.*
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    WHERE i.total > 10
)
SELECT * FROM high_value_customers
ORDER BY last_name;

-- =============================================

-- Exercise 2: CTE with JOIN
-- Calculate total invoices and amount spent per customer
-- Tables: customer, invoice

WITH invoice_summary AS (
    SELECT
        customer_id,
        COUNT(*)   AS num_invoices,
        SUM(total) AS total_spent
    FROM invoice
    GROUP BY customer_id
)
SELECT
    c.first_name,
    c.last_name,
    s.num_invoices,
    ROUND(s.total_spent::NUMERIC, 2) AS total_spent
FROM customer c
JOIN invoice_summary s ON s.customer_id = c.customer_id
ORDER BY total_spent DESC;

-- =============================================

-- Exercise 3: CTE with GROUP BY + Filter
-- Calculate total revenue per country, show only countries above 35
-- Table: invoice

WITH country_revenue AS (
    SELECT
        billing_country,
        ROUND(SUM(total)::NUMERIC, 2) AS total_revenue
    FROM invoice
    GROUP BY billing_country
)
SELECT *
FROM country_revenue
WHERE total_revenue > 35
ORDER BY total_revenue DESC;

-- =============================================
-- Exercise 6: CTE Replacing a Subquery
-- =============================================
WITH track_sales AS (
    SELECT track_id, SUM(quantity) AS total_sold
    FROM invoice_line
    GROUP BY track_id
),
avg_sales AS (
    SELECT AVG(total_sold) AS avg_sold 
    FROM track_sales
)
SELECT ts.track_id, ts.total_sold
FROM track_sales ts, avg_sales a
WHERE ts.total_sold > a.avg_sold
ORDER BY ts.total_sold DESC;