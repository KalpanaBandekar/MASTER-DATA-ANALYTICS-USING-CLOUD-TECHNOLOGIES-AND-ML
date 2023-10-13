CREATE OR REPLACE TABLE spotify_data (
playlist_url VARCHAR(100),
year NUMBER(10),
track_id VARCHAR(100),
track_name VARCHAR(100),
track_popularity NUMBER(10),
album VARCHAR(100),
artist_id VARCHAR(100),
artist_name VARCHAR(100),
artist_genres VARCHAR(200),
artist_popularity NUMBER(10),
danceability FLOAT,
energy FLOAT,
key NUMBER(10),
loudness  FLOAT,
mode NUMBER(10),
speechiness FLOAT,
acousticness FLOAT,
instrumentalness FLOAT,
liveness FLOAT,
valence FLOAT,
tempo FLOAT,
duration_ms NUMBER(10),
time_signature NUMBER(10));


SELECT * FROM spotify_data;

--Number of songs on Spotify for each artist

SELECT artist_id, artist_name, COUNT(*) AS No_of_Songs
FROM spotify_data 
GROUP BY 1,2
order by No_of_Songs DESC;

----Top 10 songs based on popularity
SELECT TOP 10 track_name, artist_name,track_popularity as Most_Poular_Songs
FROM spotify_data 
order by 3 DESC;


---Total number of songs on spotify based on year

SELECT year, COUNT(DISTINCT track_id) AS Number_of_Songs 
FROM spotify_data
GROUP BY year 
ORDER BY year DESC;


--Top song for each year (2000-2022) based on popularity
SELECT year, max(track_name) as Top_song, max(track_popularity) as Popular_song
from spotify_data
where year between 2010 and 2022
group by 1
order by 1, 3 desc;


--with winodw function
SELECT track_name as Top_Song, year, album, artist_name, track_popularity AS popularity
FROM (
  SELECT track_name, year, album, artist_name, track_popularity,
    DENSE_RANK() OVER (PARTITION BY year ORDER BY track_popularity DESC) AS rank
  FROM SPOTIFY_DATA
)
WHERE rank = 1;

---Analysis based on Tempo :--
--tempo > 121.08 -> 'Above Average Tempo'--
--tempo = 121.08 -> 'Average Tempo'---
--tempo < 121.08 -> 'Below Average Tempo'---

SELECT track_name,tempo,
    (CASE
    WHEN tempo > 121.08 THEN 'Above Average Tempo'
    WHEN tempo = 121.08 THEN 'Average Tempo'
    WHEN tempo < 121.08 THEN 'Below Average Tempo'
    END) AS tempo_average
FROM spotify_data;

---Songs with Highest Tempo---
SELECT track_name,tempo
FROM spotify_data
ORDER BY 2 DESC
LIMIT 10;

/* Number of Songs for different Tempo Range : track_name, energy
Modern_Music -> tempo BETWEEN 60.00 AND 100.00
Classical_Music -> tempo BETWEEN 100.001 AND 120.00
Dance_Music -> tempo BETWEEN 120.001 AND 150.01
HighTempo_Music -> tempo > 150.01 */

SELECT track_name ,energy, tempo,
    (CASE
     WHEN tempo between 60.00 AND 100.00 THEN 'Modern_Music'
     WHEN tempo between 100.001 AND 120.00 THEN 'Classical_Music'
     WHEN tempo between 120.001 AND 150.01 THEN 'Dance_Music'
     WHEN tempo > 150.01 THEN 'HighTempo_Music'
     END) AS Types_of_Music
FROM SPOTIFY_DATA;


/*Energy Analysis : TOP 10 track_name, danceability, track_popularity
energy > 0.64 -> 'Above Average Energy
energy = 0.64 -> 'Average Energy’
energy < 0.64 -> 'Below Average Energy’
energy BETWEEN 0.1 AND 0.3 -> 'Calm Music' */

SELECT TOP 10 track_name, danceability, track_popularity,
    (CASE
     WHEN energy > 0.64 THEN 'Above Average Energy'
     WHEN energy = 0.64 THEN 'Average Energy'
     WHEN energy < 0.64 THEN 'Below Average Energy'
     WHEN (energy BETWEEN 0.1 AND 0.3) THEN 'Calm Music'
     WHEN (energy BETWEEN 0.3 AND 0.6) THEN 'Moderate Music'
     WHEN energy > 0.6 THEN 'Energetic Music'
     END ) AS SONG_ENERGY
FROM SPOTIFY_DATA;


/* Number of Songs for different energy ranges(above) */

SELECT 
    SUM(CASE
         WHEN energy > 0.64 THEN 1
         ELSE 0
         END ) AS Above_Average_Energy,

    SUM(CASE
            WHEN energy = 0.64 THEN 1
            ELSE 0
            END ) AS Average_Energy,
    SUM(CASE       
         WHEN energy < 0.64 THEN 1
         ELSE 0
         END ) AS Below_Average_Energy,
    SUM(CASE   
         WHEN (energy BETWEEN 0.1 AND 0.3) THEN 1
         ELSE 0
         END) AS Calm_Music,
    SUM(CASE
         WHEN (energy BETWEEN 0.3 AND 0.6) THEN 1
         ELSE 0
         END ) AS Moderate_Music,
    SUM(CASE
         WHEN energy > 0.6 THEN 1
         ELSE 0
         END ) AS Energetic_Music
FROM spotify_data;


/*Danceability Analysis : Top 20 track_name, danceability
danceability BETWEEN 0.69 AND 0.79 -> 'Low Danceability'
(danceability BETWEEN 0.49 AND 0.68) OR (danceability BETWEEN
0.79 AND 0.89) -> 'Moderate Danceability'
(danceability BETWEEN 0.39 AND 0.49) OR (danceability BETWEEN
0.89 AND 0.99) -> 'High Danceability'
danceability < 0.39 OR danceability > 0.99 -> 'Cant Dance on this
one'  */

SELECT Top 20 track_name, danceability,
    (CASE
     WHEN danceability between 0.69 AND 0.79 THEN 'Low Danceability'
     WHEN (danceability BETWEEN 0.49 AND 0.68) OR (danceability BETWEEN 0.79 AND 0.89) THEN 'Moderate Danceability'
     WHEN (danceability BETWEEN 0.39 AND 0.49) OR (danceability BETWEEN 0.89 AND 0.99) THEN 'High Danceability'
     WHEN danceability < 0.39 OR danceability > 0.99 THEN 'Cant Dance on this one'
     END) AS danceability_song
FROM SPOTIFY_DATA;

--Number of Songs for different danceability ranges

SELECT
      SUM(CASE
          WHEN danceability BETWEEN 0.59 AND 0.79 THEN 1
          ELSE 0
      END) AS LowDanceability,
      SUM(CASE
          WHEN (danceability BETWEEN 0.49 AND 0.59) OR (danceability BETWEEN 0.79 AND 0.89) THEN 1
          ELSE 0
      END) AS ModerateDanceability,
      SUM(CASE
          WHEN (danceability BETWEEN 0.39 AND 0.49) OR (danceability BETWEEN 0.89 AND 1.00) THEN 1
          ELSE 0
      END) AS HighDanceability,
      SUM(CASE
          WHEN (danceability < 0.39) OR (danceability > 0.99) THEN 1
          ELSE 0
      END) AS Cant_dance_on_this_one
FROM Spotify_data;

/* Loudness Analysis : Top 20 track_name, loudness
loudness Analysis : Top 20 track_name, loudness,
 loudness BETWEEN -23.00 AND -15.00 ->'Low Loudness'
 loudness BETWEEN -14.99 AND -6.00 -> 'Below Average Loudness'
 loudness BETWEEN -5.99 AND -2.90 -> 'Above Average Loudness'
 loudness BETWEEN -2.89 AND -1.00 -> 'Peak Loudness'*/

SELECT Top 20 track_name, loudness,
    (CASE
     WHEN loudness BETWEEN -23.00 AND -15.00 THEN 'Low Loudness'
     WHEN loudness BETWEEN -14.99 AND -6.00 THEN 'Below Average Loudness'
     WHEN loudness BETWEEN -5.99 AND -2.90 THEN 'Above Average Loudness'
     WHEN loudness BETWEEN -2.89 AND -1.00 THEN 'Peak Loudness'
     END) AS loudnessofsong
FROM SPOTIFY_DATA;



--Number of Songs for different loudness ranges

SELECT 
    SUM(CASE
            WHEN loudness BETWEEN -23.00 AND -15.00 THEN 1
            ELSE 0
         END ) as Low_Loudness,
         
    SUM(CASE
         WHEN loudness BETWEEN -14.99 AND -6.00 THEN 1
         ELSE 0
         END ) as Below_Average_Loudness,
         
    SUM(CASE
         WHEN loudness BETWEEN -5.99 AND -2.90 THEN 1
         ELSE 0
         END ) as Above_Average_Loudness,
    SUM(CASE
         WHEN loudness BETWEEN -2.89 AND -1.00 THEN 1
         ELSE 0
         END ) as Peak_Average
FROM SPOTIFY_DATA;


/* Valence Analysis : Top 20 track_name, valence, track_popularity,
valence > 0.535 -> Above Avg Valence
valence = 0.535 -> Avg Valence
valence < 0.535 -> Below Average'  */


SELECT Top 20 track_name, valence, track_popularity,
    (CASE
     WHEN valence > 0.535 THEN 'Above Avg Valence'
     WHEN valence = 0.535 THEN 'Avg Valence'
     WHEN valence = 0.535 THEN 'Avg Valence'
     ELSE 'No Valence'
     END) AS valence_range
FROM SPOTIFY_DATA;

--Number of Songs for different valence ranges(above)

SELECT 
    SUM(CASE
            WHEN valence > 0.535 THEN 1
            ELSE 0
         END ) AS Above_Avg_Valence,
         
    SUM(CASE
         WHEN valence = 0.535 THEN 1
         ELSE 0
         END ) AS Avg_Valence,
         
    SUM(CASE
         WHEN valence < 0.535  THEN 1
         ELSE 0
         END ) AS Below_Average
FROM SPOTIFY_DATA;


/*Speechiness Analsis : Top 20 track_name, speechiness, tempo,
speechiness > 0.081-> Above Avg Speechiness
speechiness = 0.081-> Avg Speechiness
 */

SELECT Top 20 track_name, speechiness, tempo,
    (CASE
     WHEN speechiness > 0.081 THEN 'Above Avg Speechiness'
     WHEN speechiness = 0.081 THEN 'Avg Speechiness'
     WHEN speechiness < 0.081 THEN 'Below Speechiness'
     ELSE 'No Speeciness'
     END) AS speechiness_range
FROM SPOTIFY_DATA;


/* Acoustic Analysis : DISTINCT TOP 25 track_name, album, artist_name,
acousticness
(acousticness BETWEEN 0 AND 0.40000 -> 'Not Acoustic'
(acousticness BETWEEN 0.40001 AND 0.80000) ->'Acoustic'
(acousticness BETWEEN 0.80001 AND 1) ->'Highly Acoustic'
*/

SELECT DISTINCT TOP 25 track_name, album, artist_name, acousticness,
    (CASE
     WHEN acousticness BETWEEN 0 AND 0.40000 THEN 'Not Acoustic'
     WHEN acousticness BETWEEN 0.40001 AND 0.80000 THEN 'Acoustic'
     WHEN acousticness BETWEEN 0.80001 AND 1 THEN 'Highly Acoustic'
     ELSE 'No Acousticness'
     END) AS acousticness_range
FROM SPOTIFY_DATA;
