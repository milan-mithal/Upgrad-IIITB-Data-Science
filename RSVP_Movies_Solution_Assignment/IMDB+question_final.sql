USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    table_name, table_rows
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_SCHEMA = 'imdb';

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            title IS NULL) AS Title_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            year IS NULL) AS Year_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            date_published IS NULL) AS DP_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            duration IS NULL) AS Duration_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            country IS NULL) AS Country_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            worlwide_gross_income IS NULL) AS WGI_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            languages IS NULL) AS Lang_NULL_VALUES,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            production_company IS NULL) AS Prod_Comp_NULL_VALUES;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- YEAR WISE --
SELECT 
    YEAR(date_published) AS Year, COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY Year;
-- MONTH WISE --
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY number_of_movies DESC;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    country, COUNT(*) AS Total_Movies
FROM
    movie
WHERE
    year = 2019
        AND country IN ('India' , 'USA')
GROUP BY country;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT
    (genre)
FROM
    genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    COUNT(*) AS Total_Movies, genre
FROM
    genre
GROUP BY genre
ORDER BY Total_Movies DESC;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT 
    COUNT(*) AS no_of_movies_with_one_genre
FROM
    (SELECT 
        movie_id
    FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(DISTINCT genre) = 1) t;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, ROUND(AVG(m.duration), 2) AS avg_durartion
FROM
    genre g,
    movie m
WHERE
    g.movie_id = m.id
GROUP BY g.genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

Select genre,
       count(movie_id) as movie_count,
       RANK() OVER (ORDER BY count(movie_id) DESC) as genre_rank
FROM genre
GROUP BY genre;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT  title,avg_rating,
		RANK() OVER (ORDER BY avg_rating DESC) as movie_rank
FROM  movie m, ratings r
Where m.id=r.movie_id
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  production_company, count(movie_id) as movie_count,
		DENSE_RANK() OVER (ORDER BY count(movie_id) DESC) as prod_company_rank
FROM movie m,ratings r
WHERE m.id=r.movie_id AND r.avg_rating > 8.0 AND m.production_company is not null
GROUP BY production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, COUNT(r.movie_id) AS movie_count
FROM
    movie m,
    genre g,
    ratings r
WHERE
    m.id = r.movie_id
        AND r.movie_id = g.movie_id
        AND MONTH(m.date_published) = 3
        AND YEAR(m.date_published) = 2017
        AND m.country = 'USA'
        AND r.total_votes > 1000
GROUP BY g.genre;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title AS title,
    r.avg_rating AS avg_rating,
    g.genre AS genre
FROM
    movie m,
    ratings r,
    genre g
WHERE
    m.id = r.movie_id
        AND r.movie_id = g.movie_id
        AND m.title LIKE 'The%'
        AND r.avg_rating > 8
GROUP BY g.genre;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    m.title, r.median_rating
FROM
    movie m,
    ratings r
WHERE
    m.id = r.movie_id
        AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    SUM(r.total_votes) AS Total_Votes,
    m.country AS Language_Type
FROM
    movie m,
    ratings r
WHERE
    m.id = r.movie_id
        AND (m.country = 'Germany'
        OR m.country = 'Italy')
GROUP BY m.country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    (SELECT 
            COUNT(*)
        FROM
            names
        WHERE
            name IS NULL) AS name_nulls,
    (SELECT 
            COUNT(*)
        FROM
            names
        WHERE
            height IS NULL) AS height_nulls,
    (SELECT 
            COUNT(*)
        FROM
            names
        WHERE
            date_of_birth IS NULL) AS date_of_birth_nulls,
    (SELECT 
            COUNT(*)
        FROM
            names
        WHERE
            known_for_movies IS NULL) AS known_for_movies_nulls;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_genre as
(
select genre,
		count(g.movie_id) as movie_count
from genre g inner join ratings r on
g.movie_id=r.movie_id
where avg_rating>8
group by genre
order by movie_count
limit 3
),

Top_3_director as
(
select nm.name as director_name,
		count(g.movie_id) as movie_count,
        dense_rank() over(order by count(g.movie_id) desc) as director_rank,
        row_number() over(order by count(g.movie_id) desc) as director_rank_row
from names nm inner join director_mapping dm on
nm.id=dm.name_id inner join genre g on
dm.movie_id=g.movie_id inner join ratings r on
r.movie_id= g.movie_id,
top_genre
where g.genre in (top_genre.genre) and avg_rating>8
group by director_name
order by movie_count desc
)
select *
from Top_3_director
where director_rank<=3
limit 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name, COUNT(r.movie_id) AS movie_count
FROM
    movie m,
    names n,
    ratings r,
    role_mapping rm
WHERE
    m.id = r.movie_id
        AND r.movie_id = rm.movie_id
        AND rm.name_id = n.id
        AND r.median_rating >= 8
        AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company as production_company,sum(r.total_votes) as vote_count,
	   DENSE_RANK() OVER (ORDER BY sum(r.total_votes) DESC) as prod_comp_rank
FROM movie m,ratings r
WHERE m.id=r.movie_id AND production_company is not null
GROUP BY production_company
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name as actor_name,r.total_votes as total_votes, count(m.id) as movie_count,
	   round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actor_avg_rating,
	   DENSE_RANK() OVER (ORDER BY total_votes DESC) as actor_rank
FROM movie m,names n,ratings r,role_mapping rm
WHERE m.country='India' AND rm.category='actor' AND m.id=r.movie_id AND m.id=rm.movie_id AND rm.name_id=n.id
GROUP BY actor_name
having count(m.id) >=5
LIMIT 1;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name as actress_name,r.total_votes as total_votes, count(m.id) as movie_count,
	   round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actress_avg_rating,
	   RANK()  OVER (ORDER BY avg_rating DESC) as actress_rank
FROM movie m,names n,ratings r,role_mapping rm
WHERE m.country='India' AND rm.category='actress' AND m.languages='Hindi' AND m.id=r.movie_id AND m.id=rm.movie_id AND rm.name_id=n.id
GROUP BY actress_name
having count(m.id) >=3
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    m.title,
    r.avg_rating,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS movie_category
FROM
    movie m,
    genre g,
    ratings r
WHERE
    g.genre = 'Thriller'
        AND g.movie_id = r.movie_id
        AND r.movie_id = m.id;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre as genre,round(avg(m.duration),2) as avg_duration ,
	   sum(avg(m.duration)) over(order by g.genre rows unbounded preceding) as running_total_duration,
	   avg(avg(m.duration)) over(order by g.genre rows 13 preceding) as moving_avg_duration
FROM genre g,movie m
WHERE g.movie_id=m.id
GROUP BY g.genre
ORDER BY g.genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
    genre, COUNT(movie_id) AS movie_count
FROM
    genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3;

-- DRAMA,Comedy,Thriller 

WITH TopMovie AS (
	SELECT g.genre,
		m.year,
		m.title AS movie_name,
		m.worlwide_gross_income,
		DENSE_RANK () OVER ( PARTITION BY year
							 ORDER BY worlwide_gross_income DESC) AS movie_rank
	FROM movie m , genre g
	WHERE m.id = g.movie_id AND g.genre IN ('Drama', 'Comedy', 'Thriller') AND m.worlwide_gross_income IS NOT NULL)

SELECT *
FROM TopMovie
WHERE movie_rank <= 5
GROUP BY (movie_name);

-- Top 3 Genres based on most number of movies

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Multilingual AS (
	SELECT m.production_company,
		COUNT(m.id) AS movie_count
	FROM movie m , ratings r
	WHERE m.id = r.movie_id AND r.median_rating >= 8 AND m.languages LIKE '%,%'
	GROUP BY production_company)

SELECT *,
	DENSE_RANK () OVER (ORDER BY movie_count DESC) AS prod_comp_rank
FROM Multilingual
WHERE production_company IS NOT NULL
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

With TopActress AS (
	SELECT n.name AS actress_name,
		SUM(total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		r.avg_rating AS avg_rating
	FROM names n, role_mapping rm,ratings r,movie m ,genre g
	WHERE n.id = rm.name_id AND rm.movie_id = r.movie_id AND m.id = r.movie_id AND m.id = g.movie_id
	AND category = 'Actress' AND  genre = 'Drama' AND avg_rating > 8
	GROUP BY actress_name)

SELECT *,
	DENSE_RANK () OVER ( ORDER BY movie_count DESC) AS actress_rank
FROM TopActress
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with date_in as
(
select d.name_id, name, d.movie_id,
	   m.date_published, 
       lead(date_published, 1) over (partition by d.name_id order by date_published, d.movie_id) as next_movie_date
from director_mapping d
	 join names n on d.name_id=n.id 
	 join movie m on d.movie_id=m.id
),
date_dif as
(
 select *, datediff(next_movie_date, date_published) as diff
 from date_in
 ),
 avg_inter_days as
 (
 select name_id, avg(diff) as avg_inter_movie_days
 from date_dif
 group by name_id
 ),
 final as
 (
 select d.name_id as director_id,
	 name as director_name,
	 count(d.movie_id) as number_of_movies,
	 round(avg_inter_movie_days) as inter_movie_days,
	 round(avg(avg_rating),2) as avg_rating,
	 sum(total_votes) as total_votes,
	 min(avg_rating) as min_rating,
	 max(avg_rating) as max_rating,
	 sum(duration) as total_duration,
	 row_number() over(order by count(d.movie_id) desc) as director_row_rank
 from
	 names n join director_mapping d on n.id=d.name_id
	 join ratings r on d.movie_id=r.movie_id
	 join movie m on m.id=r.movie_id
	 join avg_inter_days a on a.name_id=d.name_id
 group by director_id
 )
 select *	
 from final;