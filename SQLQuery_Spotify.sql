select count(*)
from Portfolio_project_Spotify..cleaned_dataset

--Know the Number of Artist:
select count(distinct Artist)
from cleaned_dataset

--Know the Number of Album:
select count(distinct Album)
from cleaned_dataset

--know the different types of Albums:
select distinct Album_type 
from cleaned_dataset

--Know the Max Duration of any song

select max(Duration_min)
from cleaned_dataset


SELECT TOP 1 Title, Duration_min
FROM cleaned_dataset
ORDER BY Duration_min DESC;

--Know the MIN Duration of any song
select MIN(Duration_min)
from cleaned_dataset

select * from cleaned_dataset
where Duration_min=0

delete from cleaned_dataset
where Duration_min=0  --Deleted those songs with duration= 0

--Know the distinct Channel names
select distinct Channel
from cleaned_dataset

--know Most_Played_On 
select distinct most_playedon
from cleaned_dataset

-- --------------------
--Easy Catagory
-- --------------------
--Retrieve the names of all tracks that have more than 1 billion streams.
select Title, Stream
from cleaned_dataset
where Stream>1000000000
order by Stream

--List all albums along with their respective artists.
select distinct Album, Artist
from cleaned_dataset
order by 1

--Get the total number of comments for tracks where licensed = TRUE
select sum(Comments) as total_number_of_comments
from cleaned_dataset
where Licensed= 1

--Find all tracks that belong to the album type single.
select Track, Album_type 
from cleaned_dataset
where Album_type= 'single'

--Count the total number of tracks by each artist.
select Artist, Track
from cleaned_dataset

select Artist,Count(Artist) as Total_track
from cleaned_dataset
group by Artist

-- --------------------
--Medium Catagory
-- --------------------
--Calculate the average danceability of tracks in each album
select  Album , avg(Danceability) as Avg_dancability
from cleaned_dataset
group by Album
order by 2 desc

--Find the top 5 tracks with the highest energy values.
select top 5 Track, Energy
from cleaned_dataset
order by Energy desc

select  top 5 Track, max(Energy)
from cleaned_dataset
group by Track
order by 2 desc

--List all tracks along with their views and likes where official_video = TRUE
select Track, sum(Views), sum(Likes)
from cleaned_dataset
where official_video= 1
group by Track
order by 3 desc

--For each album, calculate the total views of all associated tracks.
select Album, Artist, sum(Views)
from cleaned_dataset
group by Album, Artist
order by 3 desc

--Retrieve the track names that have been streamed on Spotify more than YouTube.



-- --------------------
--Advance Catagory
-- --------------------
--Find the top 3 most-viewed tracks for each artist using window functions.

with ranking_artist
as
(SELECT 
    Artist, 
    Track, 
    SUM(Views) AS total_views,
    DENSE_RANK() OVER (PARTITION BY Artist ORDER BY SUM(Views) DESC) AS rank
FROM 
    cleaned_dataset
GROUP BY 
    Artist, Track)

select *
from ranking_artist
where rank <=3

--Write a query to find tracks where the liveness score is above the average.
select Track, Artist, Liveness
from cleaned_dataset
where Liveness> (select AVG(Liveness) from cleaned_dataset) 
order by 3 desc

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with cte
as
(select Album, max(Energy) as Max_Energy, Min(Energy) as Min_energy
from cleaned_dataset
group by Album)
 select Album, Max_Energy-Min_energy as Energy_Difference
 from cte 