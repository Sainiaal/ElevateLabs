use online_db

--alter table sales
--alter column transaction_time time

-- a. total quantity by month

select month(transaction_date) as months,
sum(transaction_qty) as total_qty
from transactions
group by month(transaction_date)
order by total_qty desc

-- b. monthly revenue grouped by year and month

select 
year(transaction_date) as year,
month(transaction_date) as month,
round(sum(transaction_qty * unit_price),2) as total_revenue
from transactions
group by year(transaction_date), month(transaction_date)
order by total_revenue desc

-- c. total revenue and qty sold by product category

select product_category,
round(sum(transaction_qty * unit_price),2) as total_revenue,
sum(transaction_qty) total_qty
from transactions
group by product_category
order by total_revenue desc

-- d. unique transactions per store location

select store_location,
count(distinct transaction_id) as unique_transactions
from transactions
group by store_location

-- e. product types sorted by revenue

select product_type,
round(sum(transaction_qty * unit_price),0) as revenue
from transactions
group by product_type
order by revenue desc

-- f. total quantity sold in january 2023

select sum(transaction_qty) as jan_total_qty
from transactions
where month(transaction_date) = 1 and year(transaction_date) = 2023




 


