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

-- =============================================
-- Exercise 7: Three CTEs — Fraud Detection Style
-- Find customers with unusual invoice spikes
-- Tables: invoice, customer
-- =============================================

WITH customer_stats AS (
    SELECT
        customer_id,
        COUNT(invoice_id)        AS total_invoices,q
        SUM(total)               AS total_spent,
        AVG(total)               AS avg_invoice,
        MAX(total)               AS max_invoice
    FROM invoice
    GROUP BY customer_id
),
flagged AS (
    SELECT *
    FROM customer_stats
    WHERE max_invoice > avg_invoice * 2
),
final_report AS (
    SELECT
        f.customer_id,
        f.total_invoices,
        ROUND(f.total_spent::NUMERIC, 2)  AS total_spent,
        ROUND(f.avg_invoice::NUMERIC, 2)  AS avg_invoice,
        ROUND(f.max_invoice::NUMERIC, 2)  AS max_invoice,
        c.first_name,
        c.last_name,
        c.country
    FROM flagged f
    JOIN customer c ON f.customer_id = c.customer_id
)
SELECT * FROM final_report
ORDER BY max_invoice DESC;

-- =============================================
-- Exercise 8: Recursive CTE — Employee Hierarchy
-- Build full org chart with levels
-- Table: employee
-- =============================================
WITH RECURSIVE org_chart AS (

    -- Part 1: Start at the top — employee with no manager
    SELECT 
        employee_id,
        first_name,
        last_name,
        title,
        reports_to,
        1 AS level
    FROM employee
    WHERE reports_to IS NULL

    UNION ALL

    -- Part 2: Find everyone reporting to previous results
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.title,
        e.reports_to,
        oc.level + 1
    FROM employee e
    JOIN org_chart oc ON e.reports_to = oc.employee_id

)
SELECT * FROM org_chart
ORDER BY level, employee_id;