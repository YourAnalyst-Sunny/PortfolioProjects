select *
from Portfolio_project_pizzahut..pizzas

select *
from Portfolio_project_pizzahut..pizza_types

select *
from Portfolio_project_pizzahut..orders

select *
from Portfolio_project_pizzahut..order_details
order by order_id

--Retrieve the total number of orders placed.
select count(order_id) as total_order
from orders

--Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price),2) as Total_Revenue
from Portfolio_project_pizzahut..order_details join Portfolio_project_pizzahut..pizzas
on Portfolio_project_pizzahut..pizzas.pizza_id=Portfolio_project_pizzahut..order_details.pizza_id

--Identify the highest-priced pizza.
select top 1 pizza_type_id,max(price)
from Portfolio_project_pizzahut..pizzas
group by pizza_type_id
order by max(price) desc 

--Alternative Approach
select top 1 pizzas.price, pizza_types.name
from pizzas join pizza_types
on pizzas.pizza_type_id= pizza_types.pizza_type_id 
order by price desc

--Identify the most common pizza size ordered
drop table if exists #Temp_table
create table #Temp_table
(pizza_id varchar(50),
pizza_type_id varchar(50),
size varchar(50),
quantity int)

insert into #Temp_table
select pizzas.pizza_id, pizzas.pizza_type_id, pizzas.size, order_details.quantity
from Portfolio_project_pizzahut..pizzas join Portfolio_project_pizzahut..order_details
on Portfolio_project_pizzahut..pizzas.pizza_id=Portfolio_project_pizzahut..order_details.pizza_id

select top 1 size, count(size) as size_count
from #Temp_table
group by size
order by count(size) desc 

--List the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name, sum(order_details.quantity) as pizza_count
from Portfolio_project_pizzahut..pizza_types join Portfolio_project_pizzahut..pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join Portfolio_project_pizzahut.. order_details
on order_details.pizza_id= pizzas.pizza_id
group by pizza_types.name
order by pizza_count desc

--Join the necessary tables to find the total quantity of each pizza category ordered.
drop table if exists #Temp_table2
create table ##Temp_table2
(pizza_id varchar(100),
pizza_type_id varchar(100),
name varchar(100),
category varchar(50),
quantity int)

insert into ##Temp_table2
select pizzas.pizza_id, pizzas.pizza_type_id, pizza_types.name, pizza_types.category, order_details.quantity
from Portfolio_project_pizzahut..pizzas join Portfolio_project_pizzahut..pizza_types
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join Portfolio_project_pizzahut..order_details
on order_details.pizza_id=pizzas.pizza_id

select category,count(quantity)
from ##Temp_table2
group by category

--Determine the distribution of orders by hour of the day.
SELECT DATEPART(HOUR, time) as Day_Hour, COUNT(order_id) as Order_Count
FROM Portfolio_project_pizzahut..orders
group by DATEPART(HOUR, time)
order by DATEPART(HOUR, time)

--Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name)
from Portfolio_project_pizzahut..pizza_types
group by category

--Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) from 
(select orders.date,sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id= order_details.order_id
group by orders.date) order_quantity

--Determine the top 3 most ordered pizza types based on revenue.
drop table if exists #Temp_table3 
create table #Temp_table3
(name varchar(100),
quantity int,
price int,
revenue int)

insert into #Temp_table3
select name, quantity, price, (quantity*price)
from pizzas join pizza_types
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id=order_details.pizza_id

select top 5 name, sum(revenue) as Total_Revenue
from #Temp_table3
group by name
order by Total_Revenue desc

--Calculate the percentage contribution of each pizza type to total revenue.

select sum(percentage), name
from
(SELECT 
    name, 
    (revenue * 100.0 / (SELECT SUM(revenue) FROM #Temp_table3)) AS percentage, 
    revenue
FROM 
    #Temp_table3)
from #
group by name 


SELECT 
    name, 
    SUM(percentage) AS total_percentage
FROM
    (SELECT 
        name, 
        (revenue * 100.0 / (SELECT SUM(revenue) FROM #Temp_table3)) AS percentage, 
        revenue
     FROM 
        #Temp_table3) AS subquery
GROUP BY 
    name
ORDER BY 
    total_percentage DESC;

--Analyze the cumulative revenue generated over time.
select date, sum(revenue) over(order by date) as cum_rev
from
(select orders.date, sum(order_details.quantity*pizzas.price) as revenue
from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id
join orders
on order_details.order_id= orders.order_id
group by orders.date) as sales

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.