-- Create Table commands

CREATE TABLE stores(
store_id varchar(5) PRIMARY KEY,
store_name VARCHAR(30),
city VARCHAR(25),
country VARCHAR(25)
);


CREATE TABLE category
(category_id VARCHAR(10) PRIMARY KEY ,
category_name VARCHAR(20)
);

CREATE TABLE products
(
product_id      VARCHAR(10) PRIMARY KEY,
product_name    VARCHAR(40),
category_id     VARCHAR(20),
launch_date      date,
price           FLOAT ,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sales (
    sale_id VARCHAR(20) PRIMARY KEY,
    sale_date DATE,
    store_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INTEGER
);

SELECT COUNT(*) FROM category;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM stores;
SELECT COUNT(*) FROM warranty
SELECT COUNT(*) FROM sales;
                       --    Basic sql queries   --
-----------------------1
SELECT * 
FROM sales
-----------------------2
SELECT product_name
FROM products;
-----------------------3
SELECT *
FROM sales
LIMIT 10;
-----------------------5
SELECT *
FROM stores
WHERE country = 'Canada';

                 ----   FILTERING DATA   -----                  


-----------------------1
SELECT * FROM sales
WHERE sale_date > '2023-01-01'
-----------------------2
SELECT * 
FROM products
WHERE price > '500'
-----------------------3
SELECT * 
FROM warranty
WHERE claim_status LIKE 'Warranty Void%'

-----------------------4

SELECT MIN(lauch_date) ,MAX(lauch_date)
FROM products
--MIN = 2016-10-01
--MAX =2023-09-01 

--There is no product launch in the last 1 year

SELECT * 
FROM products
WHERE lauch_date >= CURRENT_DATE - INTERVAL '1 YEAR' 

--The actual recent products

SELECT *
FROM products
WHERE lauch_date >= '2023-09-01';-- only 3 gadgets

-----------------------5
SELECT * 
FROM stores
WHERE store_id = 'ST-70'

                   -- AGGREGATE FUNCTION --
				   
--------------------------1
SELECT SUM(quantity)
FROM sales

--------------------------2

SELECT SUM(price) / COUNT(*) as AVG_price
FROM products       ---------- MY querry 

SELECT AVG(price)   ---------- EASY querry 
FROM products

--------------------------3

SELECT SUM(quantity*price)
FROM sales s
INNER JOIN products p 
ON s.product_id = p.product_id

--------------------------4   -- SUBQUERY QUESTION IMP --
SELECT product_name , price
FROM products 
WHERE price = 
(
SELECT MAX(price)
FROM products
);

--------------------------5

SELECT COUNT(*)
FROM warranty

                                     --  GROUPING DATA --
----------------------------1
SELECT store_id, SUM(quantity)
FROM sales                            -- normal query for sales and qantity number
GROUP BY store_id


SELECT s.store_id,
       SUM(s.quantity * p.price) AS revenue
FROM sales s
INNER JOIN products p                 -- Querry for Total Revenue
ON s.product_id = p.product_id 
GROUP BY s.store_id;


------------------------------2

SELECT claim_status , COUNT(*)
FROM warranty 
GROUP BY claim_status 

------------------------------3

SELECT c.category_name,COUNT(p.category_id) 
FROM products p
INNER JOIN category c
ON c.category_id = p.category_id -------------- BY INNER JOIN 
GROUP BY category_name
SELECT category_id, COUNT(*)
FROM products                --------------- Normal 
GROUP BY category_id;

-------------------------------4
SELECT category_id , SUM(s.quantity)
FROM products p
INNER JOIN sales s
ON s.product_id = p.product_id
GROUP BY p.category_id

-------------------------------5
SELECT MAX(TO_DATE(sale_date, 'YYYY-MM-DD'))
FROM sales;


SELECT product_name , SUM(p.price*s.quantity) as Total_Revenue
FROM products p
INNER JOIN sales s
ON s.product_id = p.product_id
WHERE s.sale_date >= '2024-08-21'
GROUP BY p.product_nam


                             -- JOINING TABLES --


-------------------------------1

SELECT s.sale_id , p.product_id, p.product_name , s.quantity , p.price
FROM sales s
INNER JOIN products p
ON s.product_id = p.product_id

-------------------------------2

SELECT * 
FROM sales s
INNER JOIN warranty w    
ON s.sale_id = w.sale_id

--------------------------------3
SELECT product_name , category_name 
FROM products p
INNER JOIN category c
ON p.category_id = c.category_id

--------------------------------4
SELECT * FROM sales s
INNER JOIN stores st
ON s.store_id = st.store_id

--------------------------------5

SELECT p.product_name , w.claim_status
FROM products p
INNER JOIN sales s
ON s.product_id = p.product_id

INNER JOIN warranty w
ON s.sale_id = w.sale_id
ORDER BY p.product_name

                               -- SUBQUERIES --

----------------------------------1
SELECT product_id 
FROM products 
WHERE product_id NOT IN (SELECT product_id
FROM sales)

----------------------------------2
SELECT AVG(price)
FROM products
WHERE product_id IN (SELECT product_id ,
FROM sales)

----------------------------------3  Important for understanding Subqueries  

SELECT store_id ,SUM(quantity) as total_sales
FROM sales
GROUP BY store_id
HAVING SUM(quantity) > (SELECT AVG(total_sales)
FROM(
SELECT store_id ,SUM(quantity) as total_sales
FROM sales
GROUP BY store_id) t
)

-----------------------------------4
--Find warranty claims for products sold more than once.

SELECT * 
FROM warranty 
WHERE sale_id IN (
                 SELECT s.sale_id
				 FROM sales s
				 INNER JOIN products p
				 ON s.product_id = p.product_id
				 GROUP BY p.product_id
				 HAVING SUM(quantity) > 1
)

-----------------------------------5

SELECT SUM(quantity)
FROM sales
WHERE product_id = (
               SELECT product_id
			   FROM products
			   WHERE product_id='P-5'
			   GROUP BY product_id		  
)

                           -- DATE FUNCTIONS --

----------------------------------1

SELECT sale_date , sale_id
FROM sales
WHERE TO_DATE (sale_date , 'yyyy-mm-dd')>= CURRENT_DATE - INTERVAL ' 1 year'

----------------------------------2

SELECT EXTRACT(YEAR FROM TO_DATE(sale_date,'YYYY-MM-DD'))
FROM sales                                                  -- Using Extract Function For Extracting the Date 

----------------------------------3

SELECT claim_date
FROM warranty
WHERE EXTRACT(YEAR FROM claim_date) = 2020       -- EVERY QUESTION HAS EXTRACT FUNCTION 


----------------------------------4

SELECT sale_date ,CURRENT_DATE - TO_DATE(sale_date ,'yyyy-mm-dd') as Difference 
FROM sales 

----------------------------------5

SELECT EXTRACT(YEAR FROM TO_DATE(sale_date,'yyyy-mm-dd')) AS YEAR ,
       EXTRACT(MONTH FROM TO_DATE(sale_date ,'yyyy-mm-dd')) AS MONTH,
			 COUNT(*) 
FROM sales
GROUP BY EXTRACT(YEAR FROM TO_DATE(sale_date,'yyyy-mm-dd')),
         EXTRACT(MONTH FROM TO_DATE(sale_date ,'yyyy-mm-dd')) 

		                             -- STRING FUNCTION --
									 
-----------------------------------1
SELECT CONCAT(product_name,'  ', product_name)
FROM products                                                -- as there is the quetion to write first_str and last_str of customer name but there is no customer name in the tables
                                                             -- so I decided to make a gap btw products_name for practice

-----------------------------------2

SELECT product_name
FROM products
WHERE POSITION('iPhone' IN product_name) > 0 

-----------------------------------3

SELECT LENGTH(product_name), product_name
FROM products

-----------------------------------4

SELECT UPPER(product_name)
FROM products

-----------------------------------5
SELECT SUBSTRING(product_name,1,6)
FROM products				

                              -- CASE STATEMENTS --
							  
------------------------------------1
SELECT product_name,
                    CASE 
					    WHEN price >=1000 THEN 'premium'
						WHEN price <500 THEN 'budget'
						ELSE 'Mid-Range'
					END AS category
FROM products

------------------------------------2
ALTER TABLE warranty
ADD COLUMN status VARCHAR(20)

SELECT *,
                CASE 
				    WHEN claim_status = 'Free Replaced'    -- THIS IS FOR CASE STATEMENT 
					THEN 'Approved'
					WHEN claim_status = 'Paid Repaired'
					THEN 'Approved'
					ELSE 
					'Declined'
					END as status
FROM warranty

UPDATE warranty
SET status =                                                -- THIS IS FOR UPDATING THE DATA IN TABLE 
    CASE
        WHEN claim_status = 'Free Replaced' THEN 'Approved'
        WHEN claim_status = 'Paid Repaired' THEN 'Approved'
        ELSE 'Declined'
    END;
------------------------------------3

SELECT * ,
       CASE 
	        WHEN quantity = 1
	           THEN 'category 1'
	        WHEN quantity = 2
			   THEN 'category 2'
			WHEN quantity = 3
			   THEN 'category 3'
			END AS CATEGORY
FROM sales

------------------------------------4

SELECT *,
         CASE 
		     WHEN sale_date >= '01-01-2023' 
			  THEN 'Recent sale'
			 WHEN sale_date <= '01-01-2023' 
			  THEN 'Old sale'
			 END AS SALE_TYPE
FROM sales


------------------------------------5
SELECT store_id , SUM(quantity),

                CASE WHEN SUM(quantity) >= '20000'
				 THEN 'TYPE 1'
			         WHEN SUM(quantity) <= '10000'
				 THEN 'TYPE 2'
				     ELSE
				      'TYPE 3'
				END AS TYPE
FROM sales
group BY store_id

                                  -- WINDOW FUNCTIONS --


