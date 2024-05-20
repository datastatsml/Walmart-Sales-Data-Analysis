-- WALMART SALES DATA ANALYSIS (https://www.youtube.com/watch?v=Qr1Go2gP8fo , https://www.youtube.com/watch?v=36fBGMT0tuE)


-- ProblemS faced
-- 1. imported the dataset directly. So need to manually change the data types of each column
-- 2. need to change the names of the columns since there is space in some of the columns
-- 3. How to check if null values are present in the entire dataset? (without checking individual columns)


-- LEARNINGS--------------------------------------------------------------------------------------------------------------------
-- 1. COALESCE()
-- 2. LEFT()
-- 3. IS NULL
-- 4. IFNULL()

-- REVENUE CALCULATIONS ---------------------------------------------------------------------------------------------------------
/*
COGS = unit price * quantity
VAT = 5% * COGS
VAT is added to COGS and this is what is billed to the customers
total(gross sales) = VAT + COGS
gross profit (gross income) = total(gross sales) - COGS
gross margin = gross profit / gross sales  
*/


-- DATA CLEANING and DATA WRANGLING
ALTER TABLE walmart_sales
CHANGE COLUMN `Invoice ID` invoice_id VARCHAR(30);

ALTER TABLE walmart_sales
CHANGE COLUMN Payment payment_type VARCHAR(30);

ALTER TABLE walmart_sales
CHANGE COLUMN `gross income` gross_income DECIMAL(10,2);

ALTER TABLE walmart_sales
CHANGE COLUMN Quantity quantity INT;

ALTER TABLE walmart_sales
CHANGE COLUMN Rating rating FLOAT(4,1);

ALTER TABLE walmart_sales
CHANGE COLUMN `Date` date DATE;

ALTER TABLE walmart_sales
CHANGE COLUMN `Time` time TIME;

ALTER TABLE walmart_sales
CHANGE COLUMN `gross margin percentage` gross_margin_percent FLOAT(11,9);


-- creating primary key constraint for invoice column
ALTER TABLE walmart_sales
MODIFY COLUMN invoice_id VARCHAR(30) PRIMARY KEY;


-- Find out if there are any NULL values present
SELECT *
FROM walmart_sales
where invoice_id IS NULL;


-- FEATURE ENGINEERING: Creating new columns (features) using existing columns

-- Create a new column "time_of_day" with values Morning, afternoon and evening.

SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM walmart_sales; 

-- creating the new column "time_of_day"
ALTER TABLE walmart_sales
ADD COLUMN time_of_day VARCHAR(30);

-- updatinig the values into the new column
UPDATE walmart_sales
SET time_of_day = (CASE
						WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
						WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
						ELSE "Evening"
					END);
SELECT * FROM walmart_sales;


-- Create a new column "day_name" (Mon, Tue etc.)
SELECT `date`, DAYNAME(`date`)
FROM walmart_sales;

ALTER TABLE walmart_sales
ADD COLUMN day_name VARCHAR(10);

UPDATE walmart_sales
SET day_name = DAYNAME(`date`);

-- Create a new column "Month_name"
SELECT `date`, MONTHNAME(`date`)
FROM walmart_sales;

ALTER TABLE walmart_sales
ADD COLUMN month_name VARCHAR(10);

UPDATE walmart_sales
SET month_name = MONTHNAME(`date`);





-------------------------------------------------------------------------------------------------------------------------------

-- EXPLORATORY DATA ANALYSIS

-- Generic questions --

-- How many unique cities are present?
SELECT COUNT(DISTINCT(city))
FROM walmart_sales;


-- Find out which branches are present in respective cities
SELECT 
	DISTINCT(city), 
    branch
FROM walmart_sales;

-- another way
SELECT 
	city, 
    branch
FROM walmart_sales
GROUP BY city, branch
ORDER BY city;

SELECT city, customer_type
FROM walmart_sales
GROUP BY city, customer_type
ORDER BY city;

-- how many unique product lines does the dataset have?
SELECT DISTINCT(product_line)
FROM walmart_sales;

-- what is the most selling product line?
SELECT product_line, COUNT(product_line) 
FROM walmart_sales
GROUP BY product_line
ORDER BY 2 DESC;

-- what is the most common payment method
SELECT payment_type, COUNT(payment_type)
FROM walmart_sales
GROUP BY payment_type
ORDER BY 2 DESC;

-- what is the total revenue by month
SELECT 
	month_name, 
    ROUND(SUM(total),2) AS total_revenue
FROM walmart_sales
GROUP BY month_name
ORDER BY 2 DESC;

-- Fetch each product line and add a column to those product line showing "Good" or "Bad". Good if its greater than avg sales.
SELECT 
	product_line,
    ROUND(SUM(total),2) AS total_sales,
    (CASE
		WHEN ROUND(SUM(total),2) > (SELECT AVG(total) FROM walmart_sales) THEN "Good"
        WHEN ROUND(SUM(total),2) < (SELECT AVG(total) FROM walmart_sales) THEN "Bad"
    END) AS status_of_sales
FROM walmart_sales
GROUP BY product_line;


-- which branch sold more products than the average product sold?
SELECT 
	branch,
    SUM(quantity) AS total_quantity,
    (CASE
		WHEN SUM(quantity) > (SELECT AVG(quantity) FROM walmart_sales) THEN "Greater than avg"
    END) AS sales_status
FROM walmart_sales
GROUP BY branch;


-- Number of sales made in each time of the day per weekday
SELECT 
	day_name,
	time_of_day,
    COUNT(invoice_id) AS total_sales
FROM walmart_sales
GROUP BY day_name, time_of_day
ORDER BY day_name;

-- which of the customer types brings the most revenue?
SELECT
	customer_type,
    SUM(total) AS sales
FROM walmart_sales
GROUP BY customer_type;

-- Which city has the largest tax percent/VAT?
SELECT
	city,
    AVG(VAT) AS avg_vat
FROM walmart_sales
GROUP BY city
ORDER BY avg_vat DESC;

-- How many unique customer types are present?
SELECT 
	customer_type,
    COUNT(*)
FROM walmart_sales
GROUP BY customer_type;

-- which customer type buys the most?
SELECT 
	customer_type,
    SUM(total) AS sales_by_customer_type
FROM walmart_sales
GROUP BY customer_type;

-- what is the gender distribution per branch?
SELECT 
	branch,
    gender,
    COUNT(invoice_id) AS distribution
FROM walmart_sales
GROUP BY branch, gender
ORDER BY branch;

-- Which time of the day customers give the most ratings
SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which day of the week has the best average rating?
SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- which day of the week has the best avg rating per branch
SELECT 
	branch,
	day_name,
    AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY branch, day_name
ORDER BY branch, avg_rating DESC;


