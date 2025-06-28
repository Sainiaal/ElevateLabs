use Ecom_elevate_task4

--CREATE NONCLUSTERED INDEX idx_ontime ON Ecommerce([Reached on Time_Y N]);


--What is the average cost of products across different shipment modes?

select Mode_of_Shipment,round(AVG(Cost_of_the_Product),2) Avg_cost from Ecommerce
group by Mode_of_Shipment

--Does product importance affect whether the product was delivered on time?
--
select Product_importance, round(cast(sum([Reached on Time_Y N]) as float) /(count(ID))*100,2) [On_time%] from Ecommerce
group by Product_importance


--Which warehouse block has the highest delay rate?

select Warehouse_block, 100-round(cast(sum([Reached on Time_Y N]) as float) /(count(ID))*100,2) [Delay_Rate%] from Ecommerce
group by Warehouse_block

--Is there any relationship between customer ratings and delivery time?
--

select  [Reached on Time_Y N], avg(Customer_rating) AS avg_rating, count(ID) AS total_orders FROM Ecommerce
GROUP BY [Reached on Time_Y N]

--Do customers who make more prior purchases tend to receive better discounts?
--

select Prior_purchases, round(AVG(Discount_offered),2) Avg_Discount from Ecommerce
group by Prior_purchases
order by Prior_purchases


--What is the average weight of products shipped from each warehouse block?
--

select Warehouse_block, round(avg(Weight_in_gms),2) Avg_weight from Ecommerce
group by Warehouse_block;


--Do male and female customers receive different levels of discounts or product importance?
--
with cte as (select 
  Gender, 
  Product_importance, 
  COUNT(*) AS Total_orders
FROM Ecommerce
GROUP BY Gender, Product_importance
),
cte2 as(SELECT 
  Gender,
  SUM(CASE WHEN Product_importance = 'high' THEN Total_orders ELSE 0 END) AS high,
  SUM(CASE WHEN Product_importance = 'medium' THEN Total_orders ELSE 0 END) AS medium,
  SUM(CASE WHEN Product_importance = 'low' THEN Total_orders ELSE 0 END) AS low
FROM cte
GROUP BY Gender),
cte3 as ( select Gender, round(avg(Discount_offered),2) Avg_discount from Ecommerce
group by Gender)

select cte2.gender,high,medium,low,avg_discount from cte2 join cte3 on cte2.Gender = cte3.Gender;


--How do the number of customer care calls relate to delivery delays?
--

select Customer_care_calls, 100 - cast(SUM([Reached on Time_Y N])as float)/count(ID)*100 Late_pct  from Ecommerce
group by Customer_care_calls
order by Customer_care_calls;

--Which shipment mode is most efficient in terms of on-time delivery?
--

select Mode_of_Shipment ,cast(SUM([Reached on Time_Y N])as float)/count(ID)*100 On_time_pct  from Ecommerce
group by mode_of_shipment
order by mode_of_shipment;

--Is there a trend between product cost and whether it was delivered late or on time?

with T1 as(
select Cost_of_the_Product ,cast(SUM([Reached on Time_Y N])as float) On_time, count(Id) Total_orders,
Case when Cost_of_the_Product < 150 then 'low'
when Cost_of_the_Product < 250 then 'med'
else 'high' end as Cost
from Ecommerce
group by Cost_of_the_Product
)

select Cost,round(sum(On_time)/sum(Total_orders)*100,2) On_time_pct,round(100-sum(On_time)/sum(Total_orders)*100,2) Late_pct from T1
group by Cost;


