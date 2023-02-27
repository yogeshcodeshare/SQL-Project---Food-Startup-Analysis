create database swiggy;
use swiggy;

-- Creating the Table with the colume name and its datatype. 
create table bangalore (
city char(50),
subcity	char(50),
restaurant_code	int,
restaurant text,
rating text,
rating_count text,
cost text,
cuisine	char(50),
licension_no text,
menu text,
item text,
price int,
veg_or_non_veg text,
address	text
);
-- Creating the another Table with the colume name and its datatype. 
create table monthly_order (
subcity	char(50),
restaurant_code	int,
restaurant	text,
cuisine	text,
menu text,	
item text,	
Avg_month_order int
);
show tables;
-- verify the table created with all column.
select * from bangalore;
select * from monthly_order;
-- import the data from CSV file into MySQL
/*
cd C:\Program Files\MySQL\MySQL Server 8.0\bin
mysql -u root -p
password: 

SET GLOBAL local_infile=1;
\quite

mysql --local-infile=1 -u root -p
password: 

use swiggy;

show tables;
// change the path and table name
load data local infile "D:\\SQL Project\\My SQL Project\\swiggy_banglore_monthly_order.csv"
into table monthly_order 
fields terminated by ',' 
optionally enclosed by '"'
enclosed by "" 
lines terminated by '\r\n' 
ignore 1 rows;
*/
SET SQL_SAFE_UPDATEs = 0; 
DELETE FROM bangalore;
DROP TABLE bangalore;

/* Data cleaning of Rating and cost Column */
select *
from bangalore
where rating like "--";   -- got 101064 records

SET SQL_SAFE_UPDATEs = 0; 
UPDATE bangalore
SET rating = REPLACE(rating, "--", "0")
WHERE rating LIKE "--";

-- change the datatype
ALTER TABLE bangalore
MODIFY COLUMN rating float;
-- verfication
select * from bangalore;

-- replace "₹" symbol
SET SQL_SAFE_UPDATEs = 0; 
UPDATE bangalore
SET cost = CAST(REPLACE(cost, '₹ ', '') AS UNSIGNED);

-- Bussiness Questio Analysis
-- Q.1) What is the competition in each city for a new food startup?
SELECT city, subcity, COUNT(*) AS num_restaurants
FROM bangalore
GROUP BY city, subcity
ORDER BY city, num_restaurants DESC;


-- Q.2) What is the average restaurant rating and cost in each sub-city?
SELECT subcity, AVG(rating) AS Avg_Rating, AVG(cost)  AS Avg_Cost
FROM bangalore
GROUP BY subcity;

-- Q.3) Which sub-city have the highest number of highly rated restaurants, and what are their ratings?
SELECT city, subcity, count(*) AS num_highly_rated, max(rating) AS max_rating
FROM bangalore
WHERE rating >= 4.5
GROUP BY city, subcity
ORDER BY num_highly_rated DESC, max_rating DESC;

-- Q.4) What are the top demanded cuisines in Jp Nagar, Geddalahalli, Mahadevpura and Yeshwanthpur sub-cities based on average monthly orders?
SELECT subcity, cuisine, Floor(avg(Avg_month_order)) as month_order
FROM monthly_order
where subcity in ("Jp Nagar","Geddalahalli", "Mahadevpura", "Yeshwanthpur")
GROUP BY  subcity, cuisine 
ORDER BY subcity, month_order DESC;


-- Q.5) What is the number of restaurants offor top demanded cuisine in the Jp Nagar, Geddalahalli, Mahadevpura and Yeshwanthpur sub-cities in Bangalore?
SELECT distinct subcity, cuisine, COUNT(*) AS num_restaurants
FROM bangalore
where subcity = "Jp Nagar"  and cuisine in ("Biryani Snacks","North Indian Ice Cream", 
"Punjabi Snacks","Pan-Asian Japanese", "Italian Pizzas")
GROUP BY subcity, cuisine
order by subcity, num_restaurants desc;

SELECT distinct subcity, cuisine, COUNT(*) AS num_restaurants
FROM bangalore
where subcity = "Geddalahalli"  and cuisine in ("Ice Cream Sweets","Ice Cream Beverages", "Snacks","Kebabs Chinese", "Ice Cream Bakery")
GROUP BY subcity, cuisine
order by subcity, num_restaurants desc;

SELECT distinct subcity, cuisine, COUNT(*) AS num_restaurants
FROM bangalore
where subcity = "Mahadevpura"  and cuisine in ("South Indian Desserts","Fast Food", "Fast Food Salads","Biryani Indian", "Healthy Food Pizzas")
GROUP BY subcity, cuisine
order by subcity, num_restaurants desc;

SELECT distinct subcity, cuisine, COUNT(*) AS num_restaurants
FROM bangalore
where subcity = "Yeshwanthpur" and cuisine in ("Burgers Pizzas","American Mexican", "Beverages Juices","South Indian Fast Food", "Biryani Andhra")
GROUP BY subcity, cuisine
order by subcity, num_restaurants desc;


-- Q.6) What is the average cost of eating at a restaurant in each sub-city?
SELECT subcity, floor(AVG(cost)) AS avg_cost
FROM bangalore
GROUP BY subcity
ORDER BY avg_cost DESC;

-- Q.7) What is the average cost of a particular cuisine in each city?
SELECT subcity, cuisine, floor(AVG(cost)) AS avg_cost
FROM bangalore
WHERE subcity = "Jp Nagar"  and cuisine in ("Biryani Snacks","North Indian Ice Cream", "Punjabi Snacks","Pan-Asian Japanese", "Italian Pizzas")
GROUP BY subcity, cuisine
ORDER BY subcity, avg_cost DESC;

SELECT subcity, cuisine, floor(AVG(cost)) AS avg_cost
FROM bangalore
where subcity = "Geddalahalli"  and cuisine in ("Ice Cream Sweets","Ice Cream Beverages", "Snacks","Kebabs Chinese", "Ice Cream Bakery")
GROUP BY subcity, cuisine
ORDER BY subcity, avg_cost DESC;

SELECT subcity, cuisine, floor(AVG(cost)) AS avg_cost
FROM bangalore
where subcity = "Mahadevpura"  and cuisine in ("South Indian Desserts","Fast Food", 
"Fast Food Salads","Biryani Indian", "Healthy Food Pizzas")
GROUP BY subcity, cuisine
ORDER BY subcity, avg_cost DESC;

SELECT subcity, cuisine, floor(AVG(cost)) AS avg_cost
FROM bangalore
where subcity = "Yeshwanthpur" and cuisine in ("Burgers Pizzas","American Mexican", "Beverages Juices","South Indian Fast Food", "Biryani Andhra")
GROUP BY subcity, cuisine
ORDER BY subcity, avg_cost DESC;




