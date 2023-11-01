WITH product_detail AS (
  SELECT 
    p.ProdNumber,
    p.ProdName,
    p.Category,
    pc.CategoryName,
    p.Price
  FROM `ninth-territory-360214.vix_rakamin.products` AS p
  LEFT JOIN `ninth-territory-360214.vix_rakamin.product_category` AS pc
  ON p.Category = pc.CategoryID
),

complete_table AS (
  SELECT
    o.OrderID AS order_id,
    o.Date AS date,
    o.CustomerID AS customer_id,
    REGEXP_SUBSTR(c.CustomerEmail,'^([^#]+)#') AS email,
    c.CustomerCity AS city,
    c.CustomerState AS state,
    o.ProdNumber AS prod_number,
    pd.ProdName AS prod_name,
    pd.CategoryName AS prod_category,
    pd.Price AS price,
    o.Quantity AS qty,
    (o.Quantity * pd.Price) AS total_sales
  FROM `ninth-territory-360214.vix_rakamin.orders` AS o
  LEFT JOIN `ninth-territory-360214.vix_rakamin.customer` AS c
  ON o.CustomerID = c.CustomerID
  LEFT JOIN product_detail AS pd
  ON o.ProdNumber = pd.ProdNumber
)

SELECT
  date AS order_date,
  prod_category AS category_name,
  prod_name AS product_name,
  price AS product_price,
  qty AS order_qty,
  total_sales,
  email AS cust_email,
  city AS cust_city
FROM complete_table
ORDER BY date ASC;
