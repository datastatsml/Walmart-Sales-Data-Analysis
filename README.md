REVENUE CALCULATIONS

COGS = unit price * quantity
VAT = 5% * COGS
VAT is added to COGS and this is what is billed to the customers
total(gross sales) = VAT + COGS
gross profit (gross income) = total(gross sales) - COGS
gross margin = gross profit / gross sales  

PROBLEMS FACED:
-- 1. imported the dataset directly. So need to manually change the data types of each column
-- 2. need to change the names of the columns since there is space in some of the columns
-- 3. How to check if null values are present in the entire dataset? (without checking individual columns)


LEARNINGS:
-- 1. COALESCE()
-- 2. LEFT()
-- 3. IS NULL
-- 4. IFNULL()


QUESTIONS ANSWERED:
1.  Find out which branches are present in respective cities
2.  how many unique product lines does the dataset have?
3.  what is the most selling product line?
4.  what is the most common payment method
5.  what is the total revenue by month
6.  Fetch each product line and add a column to those product line showing "Good" or "Bad". Good if its greater than avg sales.
7.  which branch sold more products than the average product sold?
8.  Number of sales made in each time of the day per weekday
9.  which of the customer types brings the most revenue?
10.  Which city has the largest tax percent/VAT?
11.  How many unique customer types are present?
12.  which customer type buys the most?
13.  what is the gender distribution per branch?
14.  Which time of the day customers give the most ratings
15.  which day of the week has the best average rating?
16.  which day of the week has the best avg rating per branch
17.  
