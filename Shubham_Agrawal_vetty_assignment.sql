1.)

 SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    COUNT(*) AS purchase_count
FROM transactions
WHERE refund_status != 'Refunded'
GROUP BY month
ORDER BY month;
------------------------------------------------------------------------------------------------------------------
2.)

SELECT 
    store_id,
    COUNT(*) AS order_count
FROM transactions
WHERE purchase_time BETWEEN '2020-10-01' AND '2020-10-31'
    AND refund_time IS NULL 
GROUP BY store_id
HAVING order_count >= 5;
-----------------------------------------------------------------------------------------------------------------
3.)


SELECT 
    store_id,
    MIN(TIMESTAMPDIFF(MINUTE, purchase_time, refund_time)) AS shortest_interval_min
FROM transactions
WHERE refund_time IS NOT NULL
GROUP BY store_id;
--------------------------------------------------------------------------------------------------------------------
4.)

WITH first_order AS (
    SELECT 
        store_id,
        gross_transaction_value,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY purchase_time) AS rn
    FROM transactions
    WHERE refund_time IS NULL  
)
SELECT 
    store_id,
    gross_transaction_value
FROM first_order
WHERE rn = 1;
----------------------------------------------------------------------------------------------------------------------

5.)

WITH first_purchase AS (
    SELECT 
        buyer_id,
        transaction_id,
        ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
    FROM transactions
    WHERE refund_time IS NULL
)
SELECT 
    i.item_name,
    COUNT(*) AS first_purchase_count
FROM first_purchase fp
JOIN items i ON fp.transaction_id = i.transaction_id
WHERE fp.rn = 1  -- First purchase
GROUP BY i.item_name
ORDER BY first_purchase_count DESC
LIMIT 1
-----------------------------------------------------------------------------------------------------------------------
6.)

SELECT *,
    CASE 
        WHEN refund_status = 'Refunded' AND TIMESTAMPDIFF(HOUR, transaction_date, refund_date) <= 72
        THEN 'Refund Processed'
        ELSE 'Refund Not Processed'
    END AS refund_flag
FROM transactions;
----------------------------------------------------------------------------------------------------------------------
7.) 
 
WITH ranked_purchases AS (
    SELECT 
        buyer_id,
        transaction_id,
        purchase_time,
        ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS purchase_rank
    FROM transactions
    WHERE refund_time IS NULL  
)
SELECT 
    buyer_id,
    transaction_id,
    purchase_time
FROM ranked_purchases
WHERE purchase_rank = 2;
-----------------------------------------------------------------------------------------------------------------------

8.)

WITH ranked_transactions AS (
    SELECT 
        buyer_id,
        purchase_time,
        ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS transaction_rank
    FROM transactions
)
SELECT 
    buyer_id,
    purchase_time AS second_transaction_time
FROM ranked_transactions
WHERE transaction_rank = 2;
--------------------------------------------------------------------------------------------------------------------------

Submitted by-----
Shubham Agrawal
Roll-BTECH/10665/21
sql Commands
