WITH product_detail AS (
  SELECT 
    p.ProdNumber,
    p.ProdName,
    p.Category,
    pc.CategoryName,
    p.Price
  FROM `ninth-territory-360214.vix_rakamin.products` AS p
  INNER JOIN `ninth-territory-360214.vix_rakamin.product_category` AS pc
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
  INNER JOIN `ninth-territory-360214.vix_rakamin.customer` AS c
  ON o.CustomerID = c.CustomerID
  INNER JOIN product_detail AS pd
  ON o.ProdNumber = pd.ProdNumber
)