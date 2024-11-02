select *
from dbo.netflix

select
	count(*) as Total_content
from dbo.netflix

select 
	 DISTINCT type
from dbo.netflix

--1. Count the number of Movies and the number of TV shows.
select type,
 count(*) as Total_Content
 from dbo.netflix
 group by type

 --2. Find the Most Common Rating And TV shows
select type, rating,
count(*) as count_rating
from dbo.netflix
group by type, rating
order by type, count_rating desc


select type, rating,
count(*) as count_rating,
rank() over(partition by type
			order by count(*) desc) as ranking
from dbo.netflix
group by type, rating
--order by type, count_rating desc

select type, rating
from (select type, rating,
count(*) as count_rating,
rank() over(partition by type
			order by count(*) desc) as ranking
from dbo.netflix
group by type, rating) as t1
where ranking=1

--List of all Movies released in a specific year?[Eg. 2020]


select release_year,title, type 
from dbo.netflix
where release_year=2020 and type= 'Movie'

--Find the top 5 Countries with the most content on Netflix?

select top 5 country, count(country) as Country_count
from dbo.netflix
group by country
order by Country_count desc


SELECT TOP 5 
    LTRIM(RTRIM(value)) AS country, 
    COUNT(*) AS total_content
FROM 
    dbo.netflix
    CROSS APPLY (
        SELECT value 
        FROM STRING_SPLIT(dbo.netflix.country, ',')
    ) AS SplitCountries
GROUP BY LTRIM(RTRIM(value))
HAVING LTRIM(RTRIM(value)) IS NOT NULL
ORDER BY total_content DESC;


--Identify the longest Movie?

select type, duration
from dbo.netflix
where type= 'Movie' and duration=(select max(duration) from dbo.netflix)

--Content added in the last 5 years

SELECT *
FROM netflix
WHERE 
    TRY_CAST(date_added AS DATE) >= DATEADD(year, -5, GETDATE())


--Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select *
from netflix
where director like '%Rajiv Chilaka%'

--List all TV shows more than 5 years
SELECT *,
       LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS sessions
FROM netflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5
  order by title



--Count the number of content items in each genre

SELECT 
    LTRIM(RTRIM(split_genre.value)) AS genre,
    COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',') AS split_genre
GROUP BY LTRIM(RTRIM(split_genre.value))
ORDER BY total_content DESC;

--Find each year and the average numbers of content release in India on netflix.
--return top 5 year with highest avg content release!
SELECT TOP 5
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        CAST(COUNT(show_id) AS FLOAT) / 
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India') * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY avg_release DESC;


--List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries'
and type='Movie'

--Find All Content Without a Director
select *
from netflix
where director is NUll

--Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT *
FROM netflix
WHERE cast LIKE '%Salman Khan%'
AND release_year > YEAR(GETDATE()) - 10;
 
--Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
