use ecom;
select count(customer_id) from customers;

select count(order_id) from orders;

select count(order_id) from order_lines;

-- #Q01: Calculate total recognized revenue from eligible orders.

select sum(recognized_revenue),order_status from order_lines
group by order_status
having order_status = 'Delivered';


-- #Q02: Calculate monthly recognized revenue in chronological order.

select round(sum(o.recognized_revenue),2) as total_revenue,
date_format(r.order_date,'%b') as order_month,
year(r.order_date) as order_year
from order_lines o 
join orders r on o.order_id=r.order_id
group by 
year(r.order_date),
month(r.order_date),
date_format(r.order_date,'%b')
order by 
order_year,
month(r.order_date);

-- #Q03: Find the top 10 products by recognized revenue and quantity sold.

select product_name, round(sum(recognized_revenue),2) as total_revenue,
sum(quantity) as total_quantity 
from order_lines
group by product_name
order by total_revenue desc,total_quantity desc
limit 10;


-- #Q04: Calculate revenue and percentage contribution by product category.

select product_category, round(sum(recognized_revenue),2) as total_revenue,
round(sum(recognized_revenue) *100 / sum(sum(recognized_revenue)) over(),2) as contribution_pct
from order_lines group by product_category
order by total_revenue desc;


-- #Q05: Calculate the average order value (AOV) for eligible orders.

select avg(order_revenue) as AOV
from (select order_id, sum(recognized_revenue) as order_revenue
from order_lines 
where order_status = "Delivered"
group by order_id) as order_totals;

-- #Q06: Find the top 10 customers by recognized revenue.

select customer_id, sum(recognized_revenue) as total
from order_lines
group by customer_id
order by total desc
limit 10;


-- #Q07: Compare revenue, purchasing customers, and AOV by customer segment.

select c.customer_segment,sum(o.order_revenue) as total_revenue,
count(distinct o.customer_id) as total_cust,
avg(o.order_revenue) as AOV
from (select order_id, 
customer_id, sum(recognized_revenue) as order_revenue
from order_lines 
where order_status = "Delivered"
group by order_id,customer_id) o join customers c on o.customer_id = c.customer_id
group by c.customer_segment;


-- #Q08: Find customers who placed at least 2 eligible orders.

select customer_id, count(distinct order_id) as total_orders
from order_lines
group by customer_id
having total_orders > 1
order by total_orders desc;

-- #Q09: Calculate the average number of eligible orders per purchasing customer.
with cal as (
select customer_id, count(distinct order_id) as total_orders
from order_lines
where order_status = "delivered"
group by customer_id
order by total_orders desc)

SELECT
    SUM(total_orders) AS total_orders,
    COUNT(*) AS purchasing_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM cal;


-- #Q10: Calculate the repeat purchase rate among purchasing customers.

with cal as (select customer_id, count(distinct order_id) as total_orders
from order_lines
where order_status = 'Delivered'
group by customer_id
order by total_orders desc)

select round(count(case when total_orders > 1 then 1 end)*100 / count(*),2) as avgs
from cal;


-- #Q11: Calculate order counts and percentages by order status.

select order_status,count(order_id) as total_orders,
round(count(order_id)/sum(count(order_id)) over()*100,2)
from order_lines
group by order_status
order by total_orders desc;


-- #Q12: Calculate the overall order cancellation rate.

select 
	round(
		sum(case when order_status = "Cancelled" then 1 else 0 end)
        *100/count(*),2)
from orders;


-- #Q13: Calculate the percentage of orders that were returned.

select 
	round(
		sum(case when order_status = "Returned" then 1 else 0 end)
        *100/count(*),2)
from orders;


-- #Q14: Calculate the average delivery time for successfully delivered orders.

select round(avg(delivery_days),2) from orders
where order_status = "Delivered";

-- #Q15: Find the top 10 orders by recognized revenue.

select order_id, round(sum(recognized_revenue),2) as total
from order_lines
where order_status = 'Delivered'
group by order_id
order by total desc
limit 10;


-- #Q16: Find the top 10 most profitable products and calculate their profit margins.

select product_name, round(sum(profit),2) as total,
round(sum(profit)/sum(recognized_revenue)*100,2) as profit_margin
from order_lines
group by product_name
order by total desc
limit 10;

-- #Q17: Compare revenue, profit, and quantity sold across discount bands.

select 
case when discount_pct = 0 then "0"
when discount_pct between 1 and 10 then "0-10"
when discount_pct between 11 and 20 then "11-20"
else "20+" end as discount_band, round(sum(recognized_revenue),2),
round(sum(profit),2),sum(quantity)
from order_lines group by discount_band
order by discount_band;

-- #Q18: Find products with positive revenue and profit margins below 10%.

select product_name,round(sum(profit)/sum(recognized_revenue)*100,2) as profit_margin_pct
from order_lines
group by product_name
having profit_margin_pct between 0 and 9
order by profit_margin_pct desc ;

-- #Q19: Calculate month-over-month revenue growth using LAG().

with cal as (select 
year(o.order_date) as order_year,
month(o.order_date) as order_month,
date_format(o.order_date,"%b") as month_name,
round(sum(r.recognized_revenue),2) as total_revenue
from orders o left join order_lines r on o.order_id = r.order_id
group by year(o.order_date),month(o.order_date),date_format(o.order_date,"%b")),

cal2 as (select *,
lag(total_revenue)over(order by order_year,order_month) as lag_revenue
from cal)

select *,round(total_revenue - lag_revenue,2) as revenue_growth,
 round((total_revenue - lag_revenue)/lag_revenue*100,2) as revenue_growth_pct from cal2;


-- #Q20: Summarize monthly revenue, profit, profit margin, eligible orders, and AOV, then identify the strongest and weakest months.


WITH monthly_data AS (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        DATE_FORMAT(o.order_date, '%b') AS month_name,

        SUM(r.recognized_revenue) AS monthly_revenue,
        SUM(r.profit) AS monthly_profit,

        COUNT(DISTINCT CASE
            WHEN o.order_status = 'Delivered'
            THEN o.order_id
        END) AS eligible_orders,

        SUM(CASE
            WHEN o.order_status = 'Delivered'
            THEN r.recognized_revenue
            ELSE 0
        END) AS delivered_revenue

    FROM orders o
    JOIN order_lines r
        ON o.order_id = r.order_id

    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date),
        DATE_FORMAT(o.order_date, '%b')
),

cal2 AS (
    SELECT
        order_year,
        order_month,
        month_name,
        ROUND(monthly_revenue, 2) AS monthly_revenue,
        ROUND(monthly_profit, 2) AS monthly_profit,

        ROUND(
            monthly_profit / NULLIF(monthly_revenue, 0) * 100,
            2
        ) AS profit_margin,

        eligible_orders,

        ROUND(
            delivered_revenue / NULLIF(eligible_orders, 0),
            2
        ) AS AOV

    FROM monthly_data
),

ranked AS (
    SELECT *,
        RANK() OVER (
            ORDER BY monthly_profit DESC
        ) AS profit_rank,

        RANK() OVER (
            ORDER BY monthly_profit ASC
        ) AS weakest_rank

    FROM cal2
)

SELECT *,
    CASE
        WHEN profit_rank = 1 THEN 'Strongest Month'
        WHEN weakest_rank = 1 THEN 'Weakest Month'
        ELSE 'Others'
    END AS month_performance

FROM ranked
ORDER BY order_year, order_month;
