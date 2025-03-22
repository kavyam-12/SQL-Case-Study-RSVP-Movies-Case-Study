USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*)
FROM
    movie;

-- Number of rows= 7997

SELECT 
    COUNT(*)
FROM
    names;

-- Number of rows= 25735

SELECT 
    COUNT(*)
FROM
    director_mapping;

-- Number of rows= 3867

SELECT 
    COUNT(*)
FROM
    ratings;

-- Number of rows= 7997

SELECT 
    COUNT(*)
FROM
    genre;

-- Number of rows= 15615
SELECT 
    COUNT(*)
FROM
    role_mapping;

-- Number of rows= 14662


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS ID_NULL_COUNT,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS TITLE_NULL_COUNT,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS YEAR_NULL_COUNT,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS DATE_PUBLISHED_NULL_COUNT,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS DURATION_NULL_COUNT,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS COUNTRY_NULL_COUNT,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS WORLDWIDE_GROSS_INCOME_NULL_COUNT,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS LANGUAGES_NULL_COUNT,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS PRODUCTION_COMPANY_NULL_COUNT
FROM
    movie; 

-- Country,worlwide_gross_income,languages and production_company are the columns in the movie table that have null values.


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

-- Movies released each year
SELECT 
    year, COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY YEAR;

-- Movies released each month
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;

-- Highest number of movies were released in 2017


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(DISTINCT id) AS number_of_movies, year
FROM
    movie
WHERE
    (country LIKE '%INDIA%'
        OR country LIKE '%USA%')
        AND year = 2019; 
       
-- 1059 movies were produced in the USA or India in the year 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Using DISTINCT keyword to find unique list of genres
SELECT DISTINCT
    (genre) AS Unique_genre
FROM
    genre;
-- 13 unique genres in the dataset

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    genre, COUNT(m.id) AS Number_of_movies
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY Number_of_movies DESC
LIMIT 5;

-- 4285 Drama movies were produced in total
-- Drama had the highest number of movies produced overall 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

 WITH movies_with_one_genre AS 
(SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
 SELECT Count(*) AS movies_with_one_genre
 FROM   movies_with_one_genre;
-- There are 3289 movies that belong to only one genre


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
    g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Action has the highest average duration of 112.8829 seconds followed by Romance and Crime.


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

WITH genre_of_movies AS
(select genre , count(movie_id) as Total_number_of_movies,
RANK () OVER (ORDER BY count(movie_id) desc) as genre_rank
from genre 
group by genre)
select * from genre_of_movies
where genre='Thriller';

-- The rank of the ‘thriller’ genre is 3


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
    MIN(avg_rating) AS 'Avg. Min. Rating',
    MAX(avg_rating) AS 'Avg. Max. Rating',
    MIN(total_votes) AS 'Min. Total. Votes',
    MAX(total_votes) AS 'Max. Total Votes',
    MIN(median_rating) AS 'Min. Median Rating',
    MAX(median_rating) AS 'Max. Median Rating'
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
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH RankedMovies AS (
    SELECT title, 
	avg_rating, 
        DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS 'Movie Rank' 
    FROM movie AS m 
    INNER JOIN ratings AS r ON r.movie_id = m.id
)
SELECT 
    title, avg_rating, 'Movie Rank'
FROM
    RankedMovies
WHERE
    'Movie Rank' <= 10;

/*-- The top 10 best rated movies are:
--> Rank 1-Kirket & Love in Kilnerry
-->Rank 2 - Gini Helida Kathe 
-->Rank 3 - Runam
-->Rank 4 - Fan & Android Kunjappan Version 5.25
-->Rank 5 - Yeh Suhaagraat Impossible, Safe & The Brighton Miracle
-->Rank 6 - Shibu, Zana, Ananthu V/S Nusrath,Family of Thakurganj
-->Rank 7 - Eghantham
-->Rank 8 - Ardaas Karaan, Dokyala Shot, Tõde ja õigus, Turnover, Digbhayam, AA BB KK & eranbu
-->Rank 9 - C/o Kancharapalem, Jelita Sejuba: Mencintai Kesatria Negara, Oththa Seruppu Size 7, Adutha Chodyam, Kuasha jakhon
-->Rank 10 - Shindisi, Officer Arjun Singh IPS & Abstruse */






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


SELECT production_company, 
COUNT(id) AS no_of_movies, 
DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) prod_company_rank 
FROM movie m 
INNER JOIN ratings r ON m.id = r.movie_id 
WHERE r.avg_rating > 8 AND m.production_company IS NOT NULL 
GROUP BY m.production_company;

-- Dream Warrior Pictures and National Theatre Live produced the most number of hit movies (average rating > 8) with movie_count=3 and rank=1

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
    genre, COUNT(id) AS movie_count
FROM
    genre g
        INNER JOIN
    movie m ON m.id = g.movie_id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    MONTH(date_published) = 3
        AND YEAR(date_published) = 2017
        AND total_votes > 1000
        AND country LIKE '%USA%'
GROUP BY genre
ORDER BY movie_count DESC;


-- 24 Drama movies released during March 2017 in the USA having more than 1,000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output faormat:
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
    m.title, r.avg_rating, g.genre
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON m.id = g.movie_id
WHERE
    m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;

/* -- The movies that start with "The" are as follows:
-->The Brighton Miracle
-->The Colour of Darkness
-->The Blue Elephant 2
-->The Irishman
-->The Mystery of Godliness: The Sequel
-->The Gambinos
-->Theeran Adhigaaram Ondru
-->The King and I*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(m.id) AS no_of_movies_released, r.median_rating
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8
GROUP BY r.median_rating;

-- 361 movies were given median rating of 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT 
    country, SUM(total_votes) AS total_votes
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    country = 'Germany' OR country = 'Italy'
GROUP BY country;

-- Yes German movies get more votes than Italian and they are total 106710 in number
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
    COUNT(CASE
        WHEN name IS NULL THEN 1
    END) AS name_nulls,
    COUNT(CASE
        WHEN height IS NULL THEN 1
    END) AS height_nulls,
    COUNT(CASE
        WHEN date_of_birth IS NULL THEN 1
    END) AS date_of_birth_nulls,
    COUNT(CASE
        WHEN known_for_movies IS NULL THEN 1
    END) AS known_for_movies_nulls
FROM
    names;

-- Height,Date of birth,Known for movies have null values


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

WITH top_3_genres_movie_director AS ( 
	SELECT genre, 
    Count(m.id) AS movie_count , 
    DENSE_Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank 
    FROM movie m 
    INNER JOIN genre g ON g.movie_id = m.id 
    INNER JOIN ratings AS r ON r.movie_id = m.id 
    WHERE avg_rating > 8 
    GROUP BY genre 
    limit 3 
) 
SELECT 
    n.name AS director_name, COUNT(d.movie_id) AS movie_count
FROM
    director_mapping AS d
        INNER JOIN
    genre g USING (movie_id)
        INNER JOIN
    names AS n ON n.id = d.name_id
        INNER JOIN
    top_3_genres_movie_director USING (genre)
        INNER JOIN
    ratings USING (movie_id)
WHERE
    avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC
LIMIT 3;

-- James Mangold, Joe Russo, Anthony Russo are the top three directors in the top three genres whose movies have an average rating > 8


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
    n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM
    role_mapping rm
        INNER JOIN
    names n ON n.id = rm.name_id
        INNER JOIN
    ratings r ON r.movie_id = rm.movie_id
WHERE
    category = 'actor'
        AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

-- The two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal


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


SELECT m.production_company, 
SUM(total_votes) AS total_vote_count, 
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS production_comp_rank
FROM movie m  
INNER JOIN ratings r ON m.id = r.movie_id 
GROUP BY m.production_company 
ORDER BY total_vote_count DESC 
LIMIT 3;

-- Marvel Studios,Twentieth Century Fox,Warner Bros. are top three production houses based on the number of votes received by their movies


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

WITH rank_actors AS ( SELECT NAME AS actor_name, 
Sum(total_votes) AS total_votes, 
Count(rm.movie_id) AS movie_count, 
Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating 
FROM role_mapping rm INNER JOIN names n ON rm.name_id = n.id 
INNER JOIN ratings r ON rm.movie_id = r.movie_id 
INNER JOIN movie m ON rm.movie_id = m.id 
WHERE category = 'actor' AND country LIKE '%India%' 
GROUP BY name_id, 
NAME HAVING Count(DISTINCT rm.movie_id) >= 5)

SELECT *, 
DENSE_Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank 
FROM rank_actors;

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
WITH rank_actress AS ( SELECT NAME AS actress_name, 
Sum(total_votes) AS total_votes, 
Count(rm.movie_id) AS movie_count, 
Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating 
FROM role_mapping rm INNER JOIN names n ON rm.name_id = n.id 
INNER JOIN ratings r ON rm.movie_id = r.movie_id 
INNER JOIN movie m ON rm.movie_id = m.id 
WHERE category = 'actress' AND m.languages LIKE "%Hindi%" AND m.country = "INDIA" 
GROUP BY name_id, 
NAME HAVING Count(DISTINCT rm.movie_id) >= 3)

SELECT *, 
DENSE_Rank() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank 
FROM rank_actress
LIMIT 5;


-- 
/* Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda are the top five actresses in Hindi movies released in India 
based on their average ratings and they have worked on at least 3 movies. */ 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:


SELECT 
    m.title AS movie_name, 
     
    CASE 
        WHEN r.avg_rating > 8 THEN "Superhit" 
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN "Hit" 
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN "One-time-watch" 
        ELSE "Flop" 
    END AS movie_category 
FROM 
    movie AS m 
INNER JOIN 
    genre AS g ON m.id = g.movie_id 
INNER JOIN 
    ratings AS r ON r.movie_id = m.id 
WHERE 
    g.genre = "thriller"
    AND r.total_votes >= 25000
ORDER BY 
    r.avg_rating DESC;


-- Joker, Andhadhun, Contratiempo, Ah-ga-ssi are superhit movies.
-- 
/* Mission: Impossible - Fallout, Forushande, Searching, Get Out. John Wick: Chapter 3 - Parabellum, Hotel Mumbai ,Miss Sloane, 
Den skyldige, John Wick: Chapter 2, Split, Shot Caller, Good Time, Brimstone, First Reformed, Elle, The Mule, The Foreigner, 
The Killing of a Sacred Deer are hit movies.
-- 
/*(Us, Widows, The Autopsy of Jane Doe, Venom, The Fate of the Furious, Glass, Atomic Blonde, Jungle, The Equalizer 2, 
Thoroughbreds, Red Sparrow, Life, Anna, Halloween, Hunter Killer, Peppermint, Annabelle: Creation, Happy Death Day, 
Roman J. Israel, Esq., Alien: Covenant, The Ritual, The Commuter, Revenge, Fractured, The Beguiled, Scary Stories to Tell in the Dark, 
American Assassin, Maze Runner: The Death Cure, The Perfection, Mile 22, The Belko Experiment, Captive State, Kidnap, Annabelle Comes Home, 
Pet Sematary, Skyscraper, Jigsaw, Would You Rather, Insidious: The Last Key, Velvet Buzzsaw, Sleepless, In the Tall Grass, The Curse of La Llorona, 
Mute, Robin Hood, Serenity, The Nun, Geostorm, The Circle, xXx: Return of Xander Cage, Rough Night, Truth or Dare are one time watch movies. */

-- Fifty Shades Freed, The Open House, Race 3 are flop movies.
 
 
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

SELECT 
    g.genre, 
    ROUND(AVG(m.duration), 2) AS avg_duration, 
    SUM(AVG(m.duration)) OVER(ORDER BY g.genre) AS running_total_duration, 
    AVG(AVG(m.duration)) OVER(ORDER BY g.genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM 
    movie m 
INNER JOIN 
    genre g ON m.id = g.movie_id
GROUP BY 
    g.genre
ORDER BY 
    g.genre;

-- Round is good to have and not a must have; Same thing applies to sorting

/* The genre-wise running total and moving average of the average movie duration is as follows:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	Action				112.88				112.8829			112.88290000
	Adventure			101.87				214.7543			107.37715000
	Crime				107.05				424.4287			106.10717500
	Drama				106.77				531.2033			106.24066000
	Family				100.97				632.1702			105.36170000
	Fantasy				105.14				737.3106			105.33008571
	Horror				92.72				830.0349			103.75436250
	Mystery				101.80				931.8349			103.53721111
	Others				100.16				1031.9949			103.19949000
	Romance				109.53				1141.5291			103.77537273
	Sci-Fi				97.94				1239.4704			103.28920000
	Thriller			101.58				1341.0465			103.15742308	

+---------------+-------------------+---------------------+----------------------+*/

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Drama		|			2017	|Shatamanam Bhavati	  |	   $103244842	     |		1	       |
|	Drama		|			2017	|	       .		  |	   .	    		 |		.	       |
|	Drama		|			2017	|	       .		  |	   .	    		 |		.	       |
|	Drama		|			2017	|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

    
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_3_genre AS (
    SELECT 
        g.genre, 
        COUNT(g.movie_id) AS movie_count
    FROM 
        genre g
    GROUP BY 
        g.genre
    ORDER BY 
        movie_count DESC
    LIMIT 3
),

find_top_movies AS (
    SELECT 
        m.year, 
        m.title AS movie_name, 
        m.worlwide_gross_income, 
        g.genre,
        RANK() OVER (PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM 
        movie m
    INNER JOIN 
        genre g ON m.id = g.movie_id
    WHERE 
        g.genre IN (SELECT genre FROM top_3_genre)
)

SELECT 
	genre,
    year, 
    movie_name, 
    worlwide_gross_income, 
    movie_rank
FROM 
    find_top_movies
WHERE 
    movie_rank <= 5
ORDER BY 
    year, movie_rank;




/* The five highest-grossing movies of each year that belong to the top three genres are :
--  +---------+-------+---------------------------+-----------------------+--------------+
--  |genre	  | year  |	movie_name	     		  |	worlwide_gross_income | movie_rank   |
--  +---------+-------+---------------------------+-----------------------+--------------+
	|Drama	  |	2017  |	Shatamanam Bhavati	 	  |	INR 530500000		  |		1        |
	|Drama	  |	2017  |	Winner					  |	INR 250000000		  |		2        |
	|Drama	  |	2017  |	Thank You for Your Service|	$ 9995692			  |		3        |
	|Comedy	  |	2017  |	The Healer				  |	$ 9979800			  |		4        |
	|Drama	  |	2017  |	The Healer				  |	$ 9979800			  |		4        |
	|Thriller |	2018  |	The Villain				  |	INR 1300000000		  |		1        |
	|Drama	  |	2018  |	Antony & Cleopatra		  |	$ 998079			  |		2        |
	|Comedy	  |	2018  |	La fuitina sbagliata	  |	$ 992070			  |		3        | 
	|Drama	  |	2018  |	Zaba					  |	$ 991				  |		4        |
	|Comedy	  |  2018 |	Gung-hab				  |	$ 9899017	          |     5        |
	|Thriller |	2019  |	Prescience				  |	$ 9956				  |		1        |
	|Thriller |	2019  |	Joker					  |	$ 995064593			  |		2        |
	|Drama	  |	2019  |	Joker					  |	$ 995064593			  |		2        |
	|Comedy	  |	2019  |	Eaten by Lions			  |	$ 99276				  |		4        |
	|Comedy	  |	2019  |	Friend Zone				  |	$ 9894885			  |		5        |
    +---------+-------+---------------------------+-----------------------+--------------+ */

/*From the above table we can concude:
-Top Genres: Drama, Comedy, and Thriller are the highest-grossing genres across multiple years.
-Highest-Grossing Movie: "The Villain" (2018) → INR 1.3B (Thriller) is the biggest earner in this dataset.
-Trends Over the Years
•	2017: Drama dominates, with "Shatamanam Bhavati" leading.
•	2018: Thriller takes over with "The Villain" earning the most.
•	2019: "Joker" (Thriller & Drama) is the highest-grossing movie.	
-Duplicate Entries: "The Healer" (2017) and "Joker" (2019) appear in two genres, suggesting misclassification or multiple genre tags.
-Revenue Differences
•	Some movies have huge earnings (hundreds of millions), while others have very low revenue ($991 - $9,956).
•	This suggests a mix of blockbusters and small indie films within the same genre rankings.*/




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

SELECT 
    m.production_company, 
    COUNT(m.id) AS movie_count, 
    ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank 
FROM 
    movie m 
INNER JOIN 
    ratings r ON m.id = r.movie_id 
WHERE 
    r.median_rating >= 8 
    AND m.production_company IS NOT NULL 
    AND POSITION(',' IN m.languages) > 0
GROUP BY 
    m.production_company 
ORDER BY 
    prod_comp_rank
LIMIT 2;


-- Star Cinema and Twentieth Centuary Fox are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:


SELECT
    name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    AVG(avg_rating) AS actress_avg_rating,
    ROW_NUMBER() OVER (ORDER BY count(m.id) DESC) AS actress_rank
FROM
    names n
INNER JOIN
    role_mapping rm ON n.id = rm.name_id
INNER JOIN
    movie m ON m.id = rm.movie_id
INNER JOIN
    ratings r ON r.movie_id = m.id
INNER JOIN
    genre g ON g.movie_id = m.id
WHERE
    avg_rating > 8
    AND category = "actress"
    AND genre = "drama"
GROUP BY
    actress_name
ORDER BY 
 movie_count desc
LIMIT 3;

-- Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are the top 3 actresses based on the number of Super Hit movies (Super hit movie: average rating of movie > 8) in 'Drama' genre

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

WITH DATE_PUBLISH AS
(
	SELECT     
		dm.name_id,
		n.NAME,
		dm.movie_id,
		m.duration,
		r.avg_rating,
		r.total_votes,
		m.date_published,
		Lead(date_published,1) OVER(partition BY dm.name_id ORDER BY m.date_published) AS next_date_published
   FROM 
	   director_mapping AS dm
	   INNER JOIN names AS n
	   ON n.id = dm.name_id
	   INNER JOIN movie AS m
	   ON m.id = dm.movie_id
	   INNER JOIN ratings AS r
	   ON r.movie_id = m.id
), 
TOP_DIRECTOR AS 
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM	DATE_PUBLISH
)
SELECT
	name_id AS "director_id",
	name AS "director_name",
	count(movie_id) AS "number_of_movies",
	ROUND(AVG(date_difference),0) AS "avg_inter_movie_days",
	ROUND((SUM((avg_rating)*(total_votes))/SUM(total_votes)),2) AS "avg_ratings",
	SUM(total_votes) AS "total_votes",
	MIN(avg_rating) AS "min_rating",
	MAX(avg_rating) AS "max_rating",
	SUM(duration) AS "total_movie_durations"
FROM
	TOP_DIRECTOR
	GROUP BY name_id
	ORDER BY count(movie_id) DESC
	LIMIT 9;

-- Details for top 9 directors (based on number of movies) :
/* ---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+------------------+
| director_id	|	director_name	 |	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes   | min_rating	| max_rating | total_duration |
+---------------+--------------------+--------------------+----------------------+--------------+--------------+----------------+------------+----------------+
|  nm2096009	|	Andrew Jones	 |			5		  |			191			 |		3.04	|	1989	    |	2.7			|     3.2	 |		432       |
|	nm1777967	|	A.L. Vijay		 |			5		  | 		177			 |		5.65	|	1754		|	3.7			|     6.9	 |		613       |   
|	nm0814469	|	Sion Sono		 |			4		  |			331	    	 |		6.31	|	2972		|	5.4			|     6.4	 |	    502       |   
|  	nm0831321	|	Chris Stokes	 |			4		  |			198			 |		4.32	|	3664		|	4.0			|     4.6	 |		352       |
|	nm0515005	|	Sam Liu			 |			4		  |			260			 |		6.32	|	28557		|	5.8			|     6.7	 |		312       |
|	nm0001752	|	Steven Soderbergh|			4		  |			254			 |		6.77	|	171684		|	6.2			|     7.0	 |		401       |
|	nm0425364	|	Jesse V. Johnson |			4		  |			299			 |		6.10	|	14778		|	4.2			|     6.5	 |		383       |
|	nm2691863	|	Justin Price	 |			4		  |			315			 |		4.93	|	5343		|	3.0			|     5.8	 |		346       |
|	nm6356309	|	Özgür Bakar		 |			4		  |			112			 |		3.96	|	1092		|	3.1			|     4.9	 |		374       |
+---------------+--------------------+--------------------+----------------------+--------------+---------------+---------------+------------+----------------+

From this table we can conclude:
•	Best Director - Steven Soderbergh → Highest ratings (6.77) and most popular (171684 votes).
•	Fastest Filmmaker - Özgür Bakar → Releases movies fastest (112 days per movie) but has low ratings (3.96).
•	Most Popular - Steven Soderbergh → Most watched director (171684  votes).
•	Well-Balanced Directors - Sion Sono & Sam Liu → Good ratings (6.3+) and steady output.


------------------------*/
