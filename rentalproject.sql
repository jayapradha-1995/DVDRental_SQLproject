use sakila;

-- ************ --
-- EXPLORE ALL THE TABLES --
-- ************ --
select * from sales_by_film_category;
select * from sales_by_store;
select * from film_list;
select * from actor_info;
select * from customer_list;
select * from staff_list;
select * from actor;
select * from category;
select * from payment;
select * from customer;
select * from rental;
select * from staff;
select * from address;
select * from store;
select * from film;
select * from country;
select * from city;
select * from film_actor;
select * from film_category;
select * from film_text;
select * from film_list;
select * from inventory;
select * from  language;
select * from nicer_but_slower_film_list;

--  **********************
-- Analyzing the data of rentals,inventory,customers --
--  **********************
-- 4.5k inventory items
select count(*) as inventory_items from inventory;

-- 16k rentals, orders
select count(*) as rental_orders from rental;

-- 599 Total customers
select count(*) as customers from customer;

-- 16k transactions
select count(*) as total_payments from payment;

-- 67K total revenue
select sum(amount) as revenue from payment;

-- **********************
-- Analysing the data of stores, country, city,staff --
-- **********************

-- 200 actors
select * from actor; 
select count(*) from actor; 

-- 1000 films
select * from film;
select count(*) from film;

-- Validating film_actor
select * from film_actor;
select count(distinct actor_id) from film_actor; -- 200 actors, CHECKED
select count(distinct film_id) from film_actor; -- 997 film, LESS

-- 16 categories
select * from category;
select count(*) from category;

select * from film_category;
select count(distinct film_id), count(distinct category_id) from film_category; -- 1000 films (CHECKED), 16 categories (CHECKED)

-- 6 languages
select* from language;
select COUNT(*) from language;

-- 2 Stores
select count(*) from store;

-- 603 address
select count(*) from address;

-- 600 cities
select count(*) from city;

-- 109 countries
select count(*) from country;

-- 2 staff
select count(*) from staff;

-- ************ --
-- Revenue and year wise Comparison --
-- ************ --

-- ************ --
 -- SLIDE 2: WHICH STORE'S REVENUE WAS HIGH --
-- ************ --
select   store.store_id,a.address,city.city,country.country,sum(p.amount) as revenue_of_store from payment as p 
inner join staff as s on p.staff_id=s.staff_id 
inner join store on s.store_id=store.store_id 
inner join address as a on store.address_id=a.address_id 
inner join city on city.city_id=a.city_id
inner join country on country.country_id=city.country_id
group by 1,2,3,4 order by 5 desc;

-- ************ --
-- SLIDE 3:WHICH YEAR THE REVENUE WAS HIGH --
-- ************ --
select  year(payment_date) as years ,sum(amount) as revenue 
from payment  group by 1 order by 2 desc;

-- ************ --
-- SLIDE 3.1:WHICH YEAR THE NUMBER OF RENTAL WAS HIGH --
-- ************ --
select  year(rental_date) as years ,count(rental_id) as number_of_rentals 
from rental  group by 1 order by 2 desc; 
 
 -- ************ --
 -- SLIDE 4:WHICH CUSTOMER MAKE MORE REVENUE TO THE STORE --
 -- ************ --
 select concat(c.first_name,'  ' ,c.last_name) as customer_name,sum(p.amount) as total_amount from rental 
 inner join payment as p on p.rental_id=rental.rental_id 
 inner join customer as c on p.customer_id=c.customer_id group by 1 order by 2 desc limit 10;
 
 -- ******************
-- SLIDE: 5  which Country contributes the most Revenue
-- ******************
select con.country, sum(amount) as rev from 
payment as p
inner join 
customer as cu on p.customer_id = cu.customer_id
inner join  
address as a on a.address_id = cu.address_id
inner join  
city as c on a.city_id = c.city_id
inner join 
country as con on con.country_id = c.country_id group by 1 order by 2;
 
-- **************************************
-- store rental wise comparison 
-- ************************************
 
-- ************ --
-- SLIDE 6:WHICH STORE's RENTAL WAS HIGH --
-- ************ --
select concat(city.city, ' , ',country.country) 
as store_address,count(r.rental_id) 
as number_of_rentals from staff as s 
inner join rental as r on s.staff_id=r.staff_id 
inner join store on store.store_id=r.staff_id 
inner join address as a on a.address_id=store.address_id
inner join city on city.city_id=a.city_id 
inner join country on country.country_id=city.country_id group by 1  order by 2 desc;


-- **************************************
-- Film and actor wise comparison 
-- ************************************

-- ************ --
-- SLIDE 7:which actor films are more --
-- ************ --
select concat(a.first_name, ' ',a.last_name) as actor_name,count(f.film_id) as number_of_film from film as f 
inner join film_actor as fc on f.film_id=fc.film_id
 inner join actor as a on a.actor_id=fc.actor_id
 group by 1 order by 2 desc limit 10 ;

  -- ************ --
 -- SLIDE 8:WHICH FILM WAS RENTED MORE --
 -- ************ --
  select film.title ,c.name,count(r.rental_id) as count_film_rented from rental as r 
 inner join inventory as i on i.inventory_id=r.inventory_id 
 inner join film on film.film_id=i.film_id inner join film_category as fc on fc.film_id=film.film_id
 inner join category  as c on fc.category_id=c.category_id
 group by 1,2 order by 3 desc limit 10; 
 
 -- ************ --
 -- SLIDE 9:WHICH CATEGORY FILM WAS RENTED MORE  --
 -- ************ --
 select ca.name,count(ca.name) as count_category  from rental as r 
 inner join inventory as i on i.inventory_id=r.inventory_id 
 inner join film on film.film_id=i.film_id 
 inner join film_category  as fc on film.film_id=fc.film_id 
 inner join category as ca on ca.category_id=fc.category_id group by 1 order by 2 desc; 

-- ******************
-- SLIDE 10: WHICH FILM IS THE HIGHEST CONTRIBUTOR OF REVENUE
-- ******************
SELECT f.title as film_name, sum(amount) as revenue FROM
film as f 
inner join
inventory as i on f.film_id = i.film_id
inner join rental as r on r.inventory_id = i.inventory_id
inner join payment as p on r.rental_id = p.rental_id group by 1 order by 2 desc limit 10;

 -- ******************
-- SLIDE 11  which rating film was contributes more to the revenue
-- ******************
 
select * from film;
select rating ,sum(amount) as revenue from
film as f 
inner join 
inventory as i on f.film_id = i.film_id
inner join  rental as r on r.inventory_id = i.inventory_id
inner join payment as p on r.rental_id = p.rental_id group by 1 order by 2;
 