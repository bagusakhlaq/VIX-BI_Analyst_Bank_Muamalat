"""
Create a new table named cohort inside the vix_rakamin dataset
"""

WITH
cust_cohort AS (
  SELECT 
    customer_id,
    MIN(date) AS first_transaction,
    CONCAT(CAST(EXTRACT(YEAR FROM MIN(date)) AS INT64), CAST(EXTRACT(MONTH FROM MIN(date)) AS INT64)) AS first_cohort
  FROM `ninth-territory-360214.vix_rakamin.transaction`
  GROUP BY 1
),

cohort_table AS (
  SELECT
    t.order_id,
    t.date,
    t.customer_id,
    cc.first_transaction,
    CONCAT(CAST(EXTRACT(YEAR FROM t.date) AS INT64), CAST(EXTRACT(MONTH FROM t.date) AS INT64)) AS cohort,
    cc.first_cohort,
    DATE_DIFF(t.date, cc.first_transaction, MONTH) AS cohort_distance
  FROM `ninth-territory-360214.vix_rakamin.transaction` AS t
  LEFT JOIN cust_cohort AS cc
  ON t.customer_id = cc.customer_id
)

SELECT * FROM cohort_table;

"""
Added new column called total_first_cust that contains total customers based on their first cohort 
"""

WITH
total_first_cust AS (
  SELECT
    first_cohort,
    cohort_distance,
    COUNT(DISTINCT customer_id) AS total_cust_first
  FROM `ninth-territory-360214.vix_rakamin.cohort`
  WHERE cohort_distance = 0
  GROUP BY 1,2
)

SELECT
  c.*,
  tfc.total_cust_first
FROM `ninth-territory-360214.vix_rakamin.cohort` AS c
LEFT JOIN total_first_cust AS tfc
ON c.first_cohort = tfc.first_cohort
AND c.cohort_distance = tfc.cohort_distance