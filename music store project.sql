

use music;


#Q.1 who is the senior most employee	based on job title?
SELECT * FROM music.employee
ORDER BY levels desc
limit 1;

#Q.2 which country has the most invoices
select count(*) as c, billing_country
from invoice
group by billing_country
order by c desc;

#q.3 what are top three values of total invoices?
select total from invoice
order by total desc
limit 3;

#4 which city has the best customers
select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc;

#5 who is the best customer?
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
order by total desc
limit 1;



#6 write query to return the email, first name,last name  and genre of all rock music listeners.alter
select distinct email, first_name, last_name
FROM customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
    where genre.name LIKE 'Rock'
)
order by email;

use music;

#7 Invite the artist who has written the most rock music in our dataset. Write a query that returns the artist name and total track count of the top 10 rock bands.alter
SELECT artist.artist_id,  artist.name, COUNT(artist.artist_id) as number_of_songs
FROM track
join album2 on album2.album_id = track.album_id
join artist on artist.artist_id = album2.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name LIKE 'Rock'
Group by artist.artist_id, artist.name
order by number_of_songs DESC
Limit 10;

#8 RETURN ALL THE TRACK NAMES THAT HAVE A SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH. RETURN THE NAME AND MILLISECONDS FOR EACH TRACK. ORDER BY THE SONG LENGTH WITH THE LONGEST SONG LISTED FIRST.
select name, milliseconds
from track
where milliseconds > (	
	SELECT AVG(milliseconds) As avg_tr_length 
    from track)
order by milliseconds DESC;
	
    
#FIND HOW MUCH TIME IS SPENT BY EACH CUSTOMER ON ARTIST? WRITE A QUERY TO RETURN CUSTOMER NAME, ARTIST NAME AND TOTAL SPENT.
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album2 ON album2.album_id = track.album_id
	JOIN artist ON artist.artist_id = album2.artist_id
	GROUP BY artist_id, artist_name
	ORDER BY total_sales DESC
	LIMIT 1
)

SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;



