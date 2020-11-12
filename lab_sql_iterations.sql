# Lab | SQL Iterations
# In this lab, we will continue working on the Sakila database of movie rentals.
use sakila;

# Instructions
# Write queries to answer the following questions:

# Write a query to find what is the total business done by each store.

select staff_id as store, sum(amount) as total_business from sakila.payment group by store;

# Convert the previous query into a stored procedure.

drop procedure if exists total_business2;

delimiter //
create Procedure total_business2()
begin
select staff_id as store, sum(amount) as total_business from sakila.payment 
group by store;
end;
// delimiter ;

call total_business2();

# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists total_business3;

delimiter //
create Procedure total_business3 (in param int)
begin
select staff_id as store, sum(amount) as total_business from sakila.payment 
where staff_id COLLATE utf8mb4_general_ci = param
group by store;
end;
// delimiter ;

call total_business3(1);

call total_business3(2);

# Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result 
# (of the total sales amount for the store). Call the stored procedure and print the results.

drop procedure if exists total_business4;

delimiter //
create procedure total_business4 (in param2 tinyint)
begin
declare total_business float default 0.0;
select sum(p.amount) into total_business from sakila.payment as p
join sakila.staff as b on b.staff_id = p.staff_id
group by b.store_id
having b.store_id = param2;
select param2, total_business;
end
// delimiter ;
    
call total_business4 (1);

# In the previous query, add another variable flag. If the total sales value for the store is over 30.000, 
# then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input 
# as the store_id and returns total sales value for that store and flag value.

drop procedure if exists total_business5;

delimiter //
create procedure total_business5 (in param tinyint, out param2 varchar(20))
begin
declare total_business float default 0.0;
declare flag varchar(20) default "";
select sum(a.amount) into total_business from sakila.payment as a
join sakila.staff as b on b.staff_id = a.staff_id
group by b.store_id
having b.store_id = param;
if total_business > 30000 then
	set flag = 'green';
else
	set flag = 'red';
end if;
select flag into param2;
select param, total_business, flag;
end
// delimiter ;
    
call total_business5 (2, @x);








