-- =============================================
-- SQL Drills · Chinook Database · Window Functions
-- Martin James Ng'ang'a · github.com/M20Jay
-- =============================================

SELECT invoice_id,
       customer_id,
       total,
       ROW_NUMBER() OVER (ORDER BY total DESC) AS overall_rank
FROM invoice;