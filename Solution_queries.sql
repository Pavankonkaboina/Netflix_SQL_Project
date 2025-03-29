--NETFLIX PROJECT 
DROP TABLE IF EXISTS netflix_shows;
create table netflix_shows (
	show_id	VARCHAR(10),
	type_ VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),	
	casts VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),	
	listed_in VARCHAR(100),
	description VARCHAR(250)
)

--
select date_added from netflix_shows

--
select distinct(type_) from netflix_shows

--15 business problems
--1. Count the number of Movies vs TV Shows
select type_, count(type_)
from netflix_shows
group by type_

--2. Find the most common rating for movies and TV shows
select type_,rating 
from (
select type_,rating,count(*),rank()over(partition by type_ order by count(*)desc)
from netflix_shows
group by type_, rating
) 
where rank = 1


--3. List all movies released in a specific year (e.g., 2020)
select title from netflix_shows
where release_year = 2020


--4. Find the top 5 countries with the most content on Netflix
select unnest(string_to_array(country,','))as new_country, count(show_id) from netflix_shows
where country is not null
group by 1 
order by 2 desc
limit 5;


--5. Identify the longest movie
select title,duration from netflix_shows
where type_ = 'Movie'
		and duration = (select max(duration)from netflix_shows)


--6. Find content added in the last 5 years
SELECT show_id, title
FROM netflix_shows
WHERE TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select title ,director from netflix_shows
where director ilike '%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons
select * from netflix_shows
where type_ = 'TV Show'
and split_part(duration,' ',1)::numeric > 5


--9. Count the number of content items in each genre
select unnest(string_to_array(listed_in,',')), count(*) from netflix_shows
group by 1


--10.Find each year and the average numbers of content release in India on netflix return top 5 year with highest avg content release!
select 
extract(year from to_date(date_added,'Month DD,YYYY')) as year,
count(*),
round(count(*)::numeric / (select count(*) from netflix_shows where country ilike '%India%')::numeric , 2) as avg_content_per_year
from netflix_shows
where country ilike '%India%'
group by 1


--11. List all movies that are documentaries
select title from netflix_shows
where listed_in ilike '%Documentaries'


--12. Find all content without a director
select * from netflix_shows
where director is null


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select title from netflix_shows
where casts ilike '%Salman khan%'
and release_year > extract(year from current_date) - 10


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select unnest(string_to_array(casts,',')) , count(*) from netflix_shows
where country ilike '%india%'
group by 1 
order by 2 desc
limit 10


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
select count(*),
case
	when description ilike '%kill%' or description ilike '%violence%' then 'Bad'
	else 'good'
	end as g_or_b
from netflix_shows
group by 2

























