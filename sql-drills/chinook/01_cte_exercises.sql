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

-- Exercise 4: Two CTEs Chained
-- Find high spending customers (total spent > 40)
-- Tables: customer, invoice/dt
WITH customer_totals AS (
    SELECT customer_id, SUM(total) AS total_spent
    FROM invoice
    GROUP BY customer_id
),
high_spenders AS (
    SELECT * FROM customer_totals
    WHERE total_spent > 40
)
SELECT first_name, last_name, total_spent
FROM customer AS c
JOIN high_spenders AS hs ON hs.customer_id = c.customer_id
ORDER BY total_spent DESC;

-- =============================================
-- Exercise 5: CTE + CASE WHEN Segmentation
-- Segment customers into VIP, Regular, Occasional
-- based on total spending
-- Tables: customer, invoice
-- =============================================
-- Exercise 5: CTE + CASE WHEN Segmentation
-- Segment customers by total spending
-- Tables: customer, invoice

WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total) AS total_spent
    FROM invoice
    GROUP BY customer_id
)
SELECT
    c.first_name,
    c.last_name,
    cs.total_spent,
    CASE
        WHEN cs.total_spent > 40 THEN 'VIP'
        WHEN cs.total_spent >= 20 AND cs.total_spent <= 40 THEN 'Regular'
        ELSE 'Occasional'
    END AS segment
FROM customer_spending cs
LEFT JOIN customer c ON cs.customer_id = c.customer_id
ORDER BY total_spent DESC;