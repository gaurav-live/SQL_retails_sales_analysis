create database SQL_project_p2;
use SQL_project_p2;
create table Retails_sales (
Transaction_id INT primary KEY, 
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age INT,
category varchar(15),
quantity INT,
price_per_unit FLOAT,
cogs float,
total_sale FLOAT);
select * from retails_sales
order by  Transaction_id asc limit 20;
select count(*) from retails_sales;
TRUNCATE TABLE retails_sales;
SELECT COUNT(*) FROM retails_sales;
SELECT * FROM retails_sales ORDER BY transaction_id LIMIT 20;
SELECT COUNT(*) FROM retails_sales
WHERE transaction_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
   OR customer_id IS NULL OR gender IS NULL OR age IS NULL
   OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL
   OR cogs IS NULL OR total_sale IS NULL;
create table Retails_sales (
Transaction_id INT primary KEY, 
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age INT,
category varchar(15),
quantity INT,
price_per_unit FLOAT,
cogs float,
total_sale FLOAT);
select * from retails_sales
order by  Transaction_id asc limit 20;
select count(*) from retails_sales;
delete from reatails_sales
where
 transaction_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retails_sales;

-- Quick checks
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retails_sales;

SELECT DISTINCT category
FROM retails_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q1 Retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retails_sales
WHERE sale_date = '2022-11-05';


-- Q2 Retrieve all transactions where the category is 'Clothing' and the
--     quantity sold is 4 or more in the month of Nov-2022
SELECT *
FROM retails_sales
WHERE category = 'Clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date <  '2022-12-01'
  AND quantity >= 4;


-- Q3 Total sales (total_sale) for each category
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retails_sales
GROUP BY category;


-- Q.4 Average age of customers who purchased from the 'Beauty' category
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retails_sales
WHERE category = 'Beauty';


-- Q5 All transactions where total_sale is greater than 1000
SELECT *
FROM retails_sales
WHERE total_sale > 1000;


-- Q6 Total number of transactions made by each gender in each category
SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM retails_sales
GROUP BY category, gender
ORDER BY category, gender;


-- Q7 Average sale for each month, and the best selling month in each year
SELECT
    sale_year,
    sale_month,
    avg_sale
FROM (
    SELECT
        YEAR(sale_date)  AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale)  AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retails_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rnk = 1;

-- To see the average sale for every month instead:
-- SELECT YEAR(sale_date) AS sale_year, MONTH(sale_date) AS sale_month,
--        ROUND(AVG(total_sale), 2) AS avg_sale
-- FROM retails_sales
-- GROUP BY 1, 2
-- ORDER BY 1, 2;


-- Q.8 Top 5 customers based on highest total sales
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retails_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q9 Number of unique customers who purchased from each category
SELECT
    category,
    COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retails_sales
GROUP BY category;


-- Q10 Each shift and number of orders
--      Morning < 12, Afternoon 12 to 17, Evening > 17
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retails_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;