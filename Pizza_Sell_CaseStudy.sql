
/*
SQL Case study project based on sale of pizza
*/
-- let's  import the csv files

-----------------------------------------------

show tables;

-----------------------------------------------

-- Now understand each table (all columns)

-----------------------------------------------

select * from order_details;  -- order_details_id	order_id	pizza_id	quantity

select * from pizzas; -- pizza_id, pizza_type_id, size, price

select * from orders;  -- order_id, date, time

select * from pizza_types;  -- pizza_type_id, name, category, ingredients

-----------------------------------------------

-- Retrieve the total number of orders placed.
select count(distinct order_id) as 'Total Orders' from orders;

-----------------------------------------------

-- Calculate the total revenue generated from pizza sales.

--  the details
select order_details.pizza_id, order_details.quantity, pizzas.price
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id;

-- to get the answer
select cast(sum(order_details.quantity * pizzas.price) as decimal(10,2)) as 'Total Revenue'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id;

-----------------------------------------------

-- Retrieving the highst price of pizzas using Limit function:

select 
    pizza_types.name as 'Pizza_Name', 
    CAST(pizzas.price as decimal(10,2)) as 'Price'
from pizzas 
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;


-- Alternative by using window function

with cte as (
select pizza_types.name as 'Pizza_Name', cast(pizzas.price as decimal(10,2)) as 'Price',
rank() over (order by price desc) as rnk
from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
)
select Pizza_Name, Price from cte where rnk = 1;

-----------------------------------------------

-- Identify the most common pizza size ordered.

select pizzas.size, count(distinct order_id) as 'No of Orders', sum(quantity) as 'Total Quantity Ordered' 
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
-- join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizzas.size
order by count(distinct order_id) desc;

-----------------------------------------------

-- List the top 5 most ordered pizza types along with their quantities.

select 
    pizza_types.name AS 'Pizza', 
    SUM(order_details.quantity) AS 'Total Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by SUM(order_details.quantity) desc
limit 5;

-----------------------------------------------

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select
	pizza_types.category, 
    sum(quantity) as 'Total Quantity Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category 
order by sum(quantity)  desc;

-----------------------------------------------

-- Determine the distribution of orders by hour of the day.

select 
    hour(time) as `Hour of the Day`, 
    COUNT(distinct order_id) as `No of Orders`
from orders
group by hour(time)
order by `No of Orders` desc;

-----------------------------------------------

-- find the category-wise distribution of pizzas

select category, 
	count(distinct pizza_type_id) as 'No of pizzas'
from pizza_types
group by category
order by 'No of pizzas';

-----------------------------------------------

-- Calculate the number of pizzas ordered per day.

select orders.date as 'Date', sum(order_details.quantity) as 'Total Pizza Ordered that day'
from order_details
join orders on order_details.order_id = orders.order_id
group by orders.date;

-----------------------------------------------

-- Determine the top 3 most ordered pizza types based on revenue.

select  pizza_types.name, sum(order_details.quantity*pizzas.price) as 'Revenue from pizza'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by sum(order_details.quantity*pizzas.price) desc limit 3;

-- try doing it using window functions also

with cte as (
	select 
		pizza_types.name, 
		sum(order_details.quantity*pizzas.price) as `Revenue`,
		rank() over(order by sum(order_details.quantity*pizzas.price) desc) as rnk
	from order_details 
	join pizzas on pizzas.pizza_id = order_details.pizza_id
	join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
	group by pizza_types.name
)
select Revenue, name from cte where rnk<4;

-----------------------------------------------
-----------------------------------------------
