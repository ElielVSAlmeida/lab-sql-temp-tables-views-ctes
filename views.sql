USE sakila;

#1

CREATE VIEW rental_count AS
(SELECT DISTINCT r.customer_id, 
		c.first_name, 
        c.last_name, 
        c.email, 
        a.address,
        COUNT(r.rental_id) OVER(PARTITION BY r.customer_id) AS rent_quant
FROM address a 
INNER JOIN customer c
ON c.address_id = a.address_id
INNER JOIN rental r
ON c.customer_id = r.customer_id);

SELECT * FROM rental_count;

CREATE TEMPORARY TABLE calculate_rent AS
(SELECT DISTINCT p.customer_id, 
        r.last_name, 
        SUM(p.amount) OVER( PARTITION BY p.customer_id) AS total_paid
FROM payment p 
INNER JOIN rental_count r
ON p.customer_id = r.customer_id);

SELECT * FROM calculate_rent;

WITH rental_mean AS
(SELECT rc.email,
		CONCAT(rc.first_name, ' ', cr.last_name) AS full_name,
        rent_quant,
        total_paid
FROM calculate_rent cr
INNER JOIN rental_count rc
ON cr.customer_id = rc.customer_id)

 SELECT *, total_paid / rent_quant
 
 AS mean 
 FROM rental_mean;
 