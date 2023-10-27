WITH 
rfm AS (
  SELECT
    customer_id,
    MAX(date) AS last_transaction,
    DATE_DIFF(CAST('2022-01-01' AS DATE), MAX(date), DAY) AS recency,
    COUNT(customer_id) AS frequency,
    SUM(total_sales) AS monetary
  FROM `ninth-territory-360214.vix_rakamin.transaction`
  GROUP BY 1
),

rfm_rank AS (
SELECT
  *,
  NTILE(5) OVER(ORDER BY recency DESC) AS r,
  NTILE(5) OVER(ORDER BY frequency ASC) AS f,
  NTILE(5) OVER(ORDER BY monetary ASC) AS m,
FROM rfm
),

rfm_cat AS (
  SELECT
    *,
    CONCAT(r, f, m) AS rfm_class
  FROM rfm_rank
),

rfm_seg AS (
  SELECT
    *,
    CASE
      WHEN REGEXP_CONTAINS(rfm_class, '[4-5][4-5][4-5]') THEN 'Champions'
      WHEN REGEXP_CONTAINS(rfm_class, '[3-5][3-5][1-5]') THEN 'Loyal Customers'
      WHEN REGEXP_CONTAINS(rfm_class, '21[1-2]') THEN 'About To Sleep'
      WHEN REGEXP_CONTAINS(rfm_class, '[3-5][2-3][1-3]') THEN 'Potential Loyalist'
      WHEN REGEXP_CONTAINS(rfm_class, '[2-4][4-5][1-3]') THEN 'Promising'
      WHEN REGEXP_CONTAINS(rfm_class, '[3-5][1-2][1-5]') THEN 'New Customers'
      WHEN REGEXP_CONTAINS(rfm_class, '[2-3][3][1-3]') THEN 'Need Attention'
      WHEN REGEXP_CONTAINS(rfm_class, '2[1-5][3-5]') THEN 'At Risk Customers'
      WHEN REGEXP_CONTAINS(rfm_class, '[1-2]2[1-2]') THEN 'Hibernating Customers'
      WHEN REGEXP_CONTAINS(rfm_class, '1[2-5][1-5]') THEN "Can't Lose Them"
      WHEN REGEXP_CONTAINS(rfm_class, '11[1-5]') THEN 'Lost Customers'
      ELSE null
    END AS rfm_segment
  FROM rfm_cat
)

SELECT * FROM rfm_seg ORDER BY rfm_class ASC;
