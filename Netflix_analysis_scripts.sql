create database netflix;
use  netflix;
create table netflix
(    show_id varchar(5),	
     type	varchar(10),
     title	varchar(150),
     director varchar(208),
     casts	varchar(1000),
     country varchar(150),
     date_added	varchar(50),
     release_year	int,
     rating	varchar(10),
     duration	varchar(15),
     listed_in	varchar(100),
     descriptions varchar(250)
);
select * from netflix;
select count(*) from netflix;
select distinct type from netflix;
-- 1. Count the number of Movies vs TV Shows
 
 SELECT type,COUNT(type)
 FROM netflix
 GROUP BY type;

-- 2. Find the most common rating for movies and TV shows 
select type, rating
from (
SELECT type,
       rating,
	   count(*),
	   rank() over(partition by type order by  count(*) desc ) as ranking
FROM netflix 
group by 1,2) as t1
where ranking = 1;
-- 3. List all movies released in a specific year (e.g., 2020)
select *  
from netflix
where release_year = 2020 and type = 'Movie';
-- 4. Find the top 5 countries with the most content on Netflix
select 
      country,
      count(show_id) as num_content
from netflix
group by country
order by num_content desc
limit 5;
-- 5. Identify the longest movie
select *
from netflix
where type = 'Movie' and duration = (select max(duration) from netflix);
-- 6. Find content added in the last 5 years
select * 
from netflix
where to_date(date_added,'month DD,yyyy')>= current_date - interval '5 years;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka.
select 
      *
      from netflix
where director like '%Rajiv Chilaka%';
-- 8. List all TV shows with more than 5 seasons
SELECT * FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
-- 9. Count the number of content items in each genre
select 
    listed_in as  genre,
	  count(show_id) as total_content
from netflix
group by 1
order by total_content desc;
-- 10.Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release!
select 
      release_year as year,
	  count(*) as avg_content_release
from netflix
where country ='India'	
 group by 1
order by avg_content_release desc;
-- 11. List all movies that are documentaries
select * 
from netflix
where  listed_in like '%Documentaries%';
-- 12. Find all content without a director
select *
from netflix
where director is null;
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where casts like '%salman Khan%'
      and
	  release_year >= year(CURDATE()) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	  cast as actors,
	  count(show_id) as num_movie
from netflix
where type ='Movie' and country like '%india%'
group by 1
order by 2 desc
limit 10;
-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select 
       case 
	   when description like '%kill%' or description like '%violence%' then 'Bad' else 'good'
	   end as lebel,
	   count(show_id)
from netflix
group by 1;

