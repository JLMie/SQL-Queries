-- JOIN ALL SAKILA ACTIVITIES.

USE sakila;
SELECT*FROM actor, film, customer; 
SELECT title FROM film;
SELECT name FROM language;
SELECT name AS language FROM language; 

-- Find out how many stores does the company have? 
SELECT COUNT( DISTINCT store_id) as number_of_stores
FROM store;
 
-- Find out how many employees staff does the company have?
SELECT count(*) FROM staff; 

-- Return a list of employee first names only?
SELECT first_name FROM staff;

- - - - -  - - - -  - - - - - -  - -
 -- LAB SQL 2.5
 USE sakila;
 
-- SELECT DISTINCT FROM 
-- 1. Select all the actors with the first name ‘Scarlett’.

SELECT first_name
FROM sakila.actor
WHERE first_Name LIKE '%carlett';

-- 2. How many physical copies of movies are available for rent in the store's inventory? 
--  checked rental date and return_date to know if they are not at the store today. But all dates are old. So,

SELECT COUNT(inventory_id) AS Total_movies_available
FROM sakila.inventory;

-- How many unique movie titles are available?
SELECT COUNT(DISTINCT inventory_id) AS total_unique_inventory
FROM sakila.inventory;

-- 3. What are the shortest and longest movie duration? 
-- Name the values max_duration and min_duration.

SELECT MIN(length) AS shortest_duration, MAX(length) AS longest_duration
FROM sakila.film;

-- 4. What's the average movie duration expressed in format (hours, minutes)?
SELECT (AVG(length)/60), 'Hours' AS Average_duration
FROM sakila.film;

-- 5. How many distinct (different) actors' last names are there?
SELECT COUNT(distinct last_name) AS Amount_of_different_last_name_actors
FROM sakila.actor;

-- 6. How many days was the company operating? 
-- Assume the last rental date was their closing date. (check DATEDIFF() function)
SELECT rental_date
FROM sakila.rental
ORDER BY rental_date DESC;

-- 2006-02-2014 at 15:16:03  was the last rental date. 
-- Replacing "DESC" to "ASC" we will obtein in the first line 
-- the first rental date. 2005-05-24 at 22:53:30

 -- There is not mandatory type the hour. 
SELECT DATEDIFF('2006-02-20 15:16:03', '2005-05-24 15:16:03') AS day_difference
FROM sakila.rental;

-- 7. Show rental info with additional columns month and weekday. Get 20 results.

SELECT *, date_format(last_update,'%m') AS 'month', date_format(last_update,'%d') AS 'day' FROM sakila.rental LIMIT 20;

-- 8. Add an additional column day_type with values 'weekend' and 'workday' 
-- depending on the rental day of the week.

SELECT *,
CASE
WHEN (date_format(rental_date,'%W') = 'Saturday') or (date_format(rental_date,'%W') = 'Sunday')
THEN 'Weekend' 
ELSE 'Weekday' 
END AS day_type 
FROM sakila.rental;

-- 9. Get release years.
SELECT DISTINCT release_year AS all_release_years
FROM sakila.film;

-- 10. Get all films with ARMAGEDDON in the title.
SELECT title AS All_films_with_ARMAGEDDON_in_the_title
FROM  sakila.film
WHERE title LIKE '%ARMAGEDDON%';

-- 11. Get all films which title ends with APOLLO.
SELECT title AS All_films_which_title_ends_with_APOLLO
FROM  sakila.film
WHERE title LIKE '%APOLLO';

-- 12. Get 10 the longest films.
-- the longest top 10 has 185 minutes. I displayed until that value change to provide value to the answer. 
-- Maybe would be great having 10 different values to create the top 10.

SELECT length, title
FROM film
ORDER BY length DESC
LIMIT 11;

-- 13. How many films include Behind the Scenes content?
SELECT COUNT(DISTINCT special_features) AS Number_of_films_include_Behind_the_scenes
FROM  sakila.film
WHERE special_features LIKE '%Behind_the_Scenes';

-- THANKS! :)

- - - - - - - - - - - - - - - - - - - - - - 

-- LAB 2.6
-- 1. In the table actor, which are the actors whose last names are not repeated? For example if you would sort the data in the table actor by last_name, 
-- you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name. 
-- So we do not want to include this last name in our output. 
-- Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.

SELECT last_name, COUNT(*) AS last_name_count
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;


-- 2. Which last names appear more than once? 
-- We would use the same logic as in the previous question but this time we want to include 
-- the last names of the actors where the last name was present more than once.

SELECT last_name, COUNT(*) AS name_count
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 3. Using the rental table, find out how many rentals were processed by each employee.
SELECT staff_id, COUNT(rental_id) As all_rentals
FROM sakila.rental
GROUP BY staff_id;

-- 4. Using the film table, find out how many films were released each year.
SELECT release_year, COUNT(title) AS counting_titles
FROM sakila.film
GROUP BY release_year;

-- 5.Using the film table, find out for each rating how many films were there.
SELECT rating, COUNT(*) AS film_countING
FROM film
GROUP BY rating;


-- 6.What is the mean length of the film for each rating type. Round off the average lengths to two decimal places.

SELECT rating, ROUND(AVG(length), 2) AS average_length
FROM film
GROUP BY rating;


-- 7. Which kind of movies (rating) have a mean duration of more than two hours?

SELECT rating
FROM film
GROUP BY rating
HAVING AVG(length) > 120;

-- 8. Rank films by length (filter out the rows that have nulls or 0s in length column). 
-- In your output, only select the columns title, length, and the rank.

SELECT title, length
FROM film
WHERE length IS NOT NULL AND length > 0;

- - - - - - - - - - - - - - - - - -

-- Lab | SQL Join (Part I)

USE sakila;

-- 1. How many films are there for each of the categories in the category table. Use appropriate join to write this query.
SELECT c.name as category_name, COUNT(fc.film_id) as number_of_films
FROM category c
JOIN film_category fc
USING (category_id)
GROUP BY category_name;

-- 2. Display the total amount rung up by each staff member in August of 2005.
SELECT stf.first_name, SUM(py.amount) as total_amount
FROM staff stf
JOIN payment py
USING (staff_id)
WHERE date(py.payment_date) LIKE '2005-08-%'
GROUP BY stf.first_name;

-- 3. Which actor has appeared in the most films?
SELECT ac.first_name, ac.last_name, COUNT(fi.film_id) AS number_of_films
FROM actor ac
JOIN film_actor fa ON ac.actor_id = fa.actor_id
JOIN film fi ON fa.film_id = fi.film_id
GROUP BY ac.actor_id, ac.first_name, ac.last_name
ORDER BY number_of_films DESC
LIMIT 1;

-- 4. Most active customer (the customer that has rented the most number of films)
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals DESC
LIMIT 1;

-- 5. Display the first and last names, as well as the address, of each staff member.
SELECT first_name, last_name, address_id
FROM staff;

-- 6. List each film and the number of actors who are listed for that film.
SELECT f.title, COUNT(a.actor_id) AS number_of_actors
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.title;

-- 7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

SELECT cu.first_name, cu.last_name, SUM(py.amount) AS total_paid
FROM customer cu
JOIN payment py ON cu.customer_id = py.customer_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name
ORDER BY cu.last_name;

-- 8. List number of films per category.
-- See Exercise 1.

- - - - - - - - - - - - - - - - - - - - - -

-- Lab | SQL Join (Part II)

USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
-- I use "USING" cluase. Otherwise I need to use ON and type all the path to connect the tables. 
SELECT st.store_id, ci.city, co.country
FROM store st
JOIN address ad
USING (address_id)
JOIN city ci
USING (city_id)
JOIN country co 
USING (country_id);

-- 2. Write a query to display how much business, in dollars, each store brought in.
-- PATH WAY: STORE -> INVENTORY -> RENTAL -> PAYMENT. 

SELECT st.store_id, CONCAT('$', SUM(py.amount)) AS total_dollars
FROM payment py
JOIN rental r ON py.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store st ON i.store_id = st.store_id
GROUP BY st.store_id;

-- 3. Which film categories are longest?

SELECT ca.name, SUM(fi.length) AS top_longest_categories
FROM category ca 
JOIN film_category fica ON ca.category_id = fica.category_id
JOIN film fi ON fica.film_id = fi.film_id
GROUP BY ca.name
ORDER BY top_longest_categories DESC;
-- WAY: CATEGORY -> FILM_CATEGORY -> FILM

-- Longest film. 
SELECT title, length AS longest_film
FROM film
ORDER BY length DESC
LIMIT 1;

-- 4. Display the most frequently rented movies in descending order.
-- Table Way:  rental_id -> RENTAL -> inventory_id -> INVENTORY -> film_id -> FILM 
SELECT COUNT(re.rental_id) as frequency_rented, fi.title
FROM rental re JOIN inventory USING (inventory_id)

JOIN film fi USING (film_id)

GROUP BY fi.title ORDER BY frequency_rented DESC;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
-- JOIN PATH: INVENTORY -> store_id -> STORE -> inventory_id -> RENTAL
SELECT fi.film_id, fi.title, st.store_id, inv.inventory_id
FROM film fi 
JOIN inventory inv
USING (film_id) 
JOIN  store st
USING (store_id)
WHERE fi.title = 'Academy Dinosaur' AND st.store_id = 1;

-- 7. Get all pairs of actors that worked together.
SELECT f.film_id, fa1.actor_id, fa2.actor_id,CONCAT(a1.first_name," ", a1.last_name), CONCAT(a2.first_name," ", a2.last_name)
FROM film f
JOIN film_actor fa1
ON f.film_id=fa1.film_id
JOIN actor a1
ON fa1.actor_id=a1.actor_id
JOIN film_actor fa2
ON f.film_id=fa2.film_id
JOIN actor a2
ON fa2.actor_id=a2.actor_id;
- - - - - - - - - - - - - - - - - - - -
-- Lab | SQL - Lab 3.01

USE sakila;
-- ACTIVITY 1.

-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

# These are the fileds: staff_id, first_name, last_name, address_id, email, store_id, active, username, password, last_update. 
# I assume the new employee is still a customer. 
SELECT * FROM staff;
INSERT INTO staff (staff_id, first_name, last_name, address_id, email, store_id, username)
VALUES ('3', 'Tammy', 'Sanders', 'abc', 'tammysanders@sakila.com', 2, 'Tammy');

#WHY IT DOES NOT RUN? 

-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. 
-- For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

 # First, I need to get the necessary information to complete the rental entry in the RENTAL table.
#HINT.  
select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
# Now we know the customer_id is 130. 

SELECT I.inventory_id
FROM INVENTORY AS I
JOIN FILM AS F ON I.film_id = F.film_id
WHERE F.title = 'Academy Dinosaur' AND I.store_id = 1;
# Now we know the inventory values are from 1 to 4. I will choose the 2.

# Rental_date = current date
# Staff_id = 3. IN this case I know is 3 because I remember they were just two employees.
# We don't have to fill the rest of the fields beacuse MySQL will return null values and that's all. 
INSERT INTO RENTAL (rental_date, inventory_id, customer_id, staff_id)
VALUES (CURRENT_DATE(), 2, 130 , 3);

#Cheking it is in the table.
SELECT*FROM rental
WHERE customer_id = 130;
#Rental_id = 16051.

-- ACTIVITY 2.
-- JOIN Tables. Instead 15, having 4.
-- 1. Address, city and country in the same table. Table name: Address
-- 2. Payment, rental and customer in the same table. Table name: Rentals
-- 3. Staff and store Table name: Store
-- 4. Film, film_category, category, film_actor, actor, languague, Inventory. Table name: Inventory

Set new primary key.
-- 1. Address --> address_id
-- 2. Rentals --> customer_id
-- 3. Store --> store_id
-- 4. Inventory --> Film_id

I will suggest remove some columns such as: city_id, country_id, staff_id(they are just 2 or 3), and category_id.

Business improvements. Collect reviews from movies, and review from store after 10 rentings. Ans ading in Rental table as experience colunm.

- - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Lab | SQL - Lab 3.02.03
USE Sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film_id
FROM FILM
WHERE title = 'Hunchback Impossible';
# Film_id=439

SELECT COUNT(*) AS copies_count
FROM INVENTORY
WHERE film_id = 439;
# We obtain 6 copies

#Here it is the with a substring. 
SELECT COUNT(*) AS copies_of_Hunchback_Impossible
FROM INVENTORY
WHERE film_id = (
  SELECT film_id
  FROM FILM
  WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.
SELECT *
FROM film
WHERE length > (
  SELECT AVG(length)
  FROM film
);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
# TABLE PATH = FILM film_id -> FILM_ACTOR actor_idS ->  ACTOR.

SELECT film_id
FROM film
WHERE title = 'Alone Trip';
#film_id (PK)= 17

SELECT actor_id
FROM film_actor 
WHERE film_id = 17;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (3, 12, 13,82,100,160,167,187);

-- SUBQUERY. 
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
   SELECT actor_id
   FROM film_actor 
WHERE film_id = (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip')
   );

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

# I need the categoy name, but the table is not related directly to the film table. 
# I need go trough film_category table because is the conexion table one between film and category table. 

SELECT * FROM film_category;
SELECT * FROM category;

SELECT category_id
FROM category
WHERE name = 'Family';

SELECT film_id
FROM film_category
WHERE category_id = 8;

SELECT film_id, title
FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id = 8);


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT *
FROM city;


SELECT country_id
FROM country
WHERE country = 'Canada';

SELECT address_id
FROM address
WHERE city_id IN ( 
 SELECT city_id
 FROM city 
 WHERE country_id = (
  SELECT country_id
  FROM country
  WHERE country = 'Canada'));

-- 5.WITH JOINS. 
# TABLE PATH COUNTRY -> CITY -> ADDRESS -> CUSTOMER ->
SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
JOIN address ad ON cu.address_id = ad.address_id
JOIN city ct ON ad.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
WHERE co.country_id = 20;

-- 6. Which are films started by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
#Finding the actor_id of the most prolific actor.

SELECT actor_id
FROM (
  SELECT actor_id, COUNT(*) AS film_count
  FROM film_actor
  GROUP BY actor_id
  ORDER BY film_count DESC
  LIMIT 1
) AS subquery;
#Actor_id: 107

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
      SELECT actor_id
      FROM(
         SELECT ACTOR_ID, COUNT(film_id)
         FROM film_actor
         GROUP BY actor_id
         ORDER BY COUNT(film_id) DESC
         LIMIT 1) sub1);
         
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.

SELECT customer_id
FROM (SELECT customer_id, SUM(amount)
	  FROM payment
      GROUP BY customer_id
      ORDER BY SUM(amount) DESC
      LIMIT 1) sub1;
-- customer id: 526 is the most profitable customer. 

-- 8. Customers who spent more than the average payments.
# I selected as well the email, in case we want to send them an email offering a bonus or a ofert. 

SELECT
  cu.customer_id,
  cu.first_name,
  cu.last_name,
  cu.email,
  SUM(py.amount) AS total_amount_spent
FROM
  customer cu
JOIN
  payment py ON cu.customer_id = py.customer_id
WHERE
  cu.customer_id IN (
    SELECT
      py.customer_id
    FROM
      payment py
    GROUP BY
      py.customer_id
    HAVING
      SUM(py.amount) > (
        SELECT
          AVG(amount)
        FROM
          payment
      )
  )
GROUP BY
  cu.customer_id, cu.first_name, cu.last_name, cu.email;
  