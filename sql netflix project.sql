drop table if exists netflix;
create table netflix
(
show_id				varchar(7),
type				varchar(10),
title				varchar(150),
director			varchar(210),
casts				varchar(1000),
country				varchar(150),
date_added			varchar(50),
release_year		int,
rating				varchar(10),
duration			varchar(15),
listed_in			varchar(100),
description			varchar(300)
);


select * from netflix;

1.Count the number of Movies vs TV Shows

select type, count(*)
from netflix
group by type;

2.Find the most common rating for movies and TV shows

with cte as (
			select type,rating,count(rating) as rating_count
			from Netflix
			group by type,rating
			),
	cte2 as (
			select *
			,rank() over(partition by type order by rating_count desc) as rnk
			from cte
			)
select type,rating
from cte2
where rnk = 1


3. List all movies released in a specific year (e.g., 2020)

select title
from netflix
where type = 'Movie'
and release_year = 2020



4. Find the top 5 countries with the most content on Netflix

select 
    unnest(string_to_array(country,',')) as new_country,
	count(show_id) as content_per_country
from netflix
group by 1
order by 2 desc
limit 5;



5. Identify the longest movie

select *
from netflix
where type = 'Movie'
and duration = (select MAX(duration)
					from netflix);


6. Find content added in the last 5 years

select *
from netflix
where to_date(date_added , 'Month DD, YYYY') >= (current_date - INTERVAL '5 year')


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select *
from netflix
where director ilike '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons

select *
from netflix
where type = 'TV Show'
and split_part(duration,' ',1):: numeric > 5



9. Count the number of content items in each genre

select 
    unnest(string_to_array(listed_in,',')) as genre,
	count(show_id) as content_per_genre
from netflix
group by 1


10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;



11. List all movies that are documentaries


select *
from netflix
where type = 'Movie'
and listed_in ILIKE '%Documentaries%'





12. Find all content without a director

select *
from netflix
where director is null


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!


select *
from netflix
where casts ilike '%Salman Khan%'
and release_year > extract(year from current_date) - 10


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(casts,',')) as actors
,count(show_id) as movie_per_actor
from netflix
where type = 'Movie'
and country ilike '%India%'
group by 1
order by 2 desc
limit 10;




15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these 
keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

select category, count(*) as category_count
from (select *,
 			case when description ilike '%violence%'or description ilike '%kill%' then 'Bad'
 					else 'Good'
				end as category
			from netflix) as categorized_content
group by category



select * from netflix;