/*
First, I wanted to create 2 CTEs 
The first CTE is to get the tie record at home and the second CTE is to get the tie record away from home
I decided to SELECT the HomeTeam and create a CASE statement to get the win, tie, loss record
But for this query we are focusing on the tie record
Then using that query as a subquery to COUNT the number of time a team has tied
Create a CTE with the previous query and do the same when the team plays away from home
Join both tables
Since Man City tied twice away from home and didn't at home, we can't add a null value with an integer so we use the IFNULL function
And Maan City is the only team missing so I used the COALESCE function
Finally, we can save the query as view in BigQuery then join with the other views to create the final table
*/

WITH home_draw_record_CTE AS (
SELECT HomeTeam, COUNT(Record) AS home_draw_record
FROM (
  SELECT HomeTeam,
    CASE
        WHEN FTHG > FTAG THEN 'Win'
        WHEN FTHG = FTAG THEN 'Draw'
        ELSE 'Loss'
    END AS Record
  FROM `portfolio-360521.premier_league2019.season_2019` 
)
WHERE Record = 'Draw'
GROUP BY HomeTeam
),
away_draw_record_CTE AS (
SELECT AwayTeam, COUNT(Record) AS away_draw_record
FROM (
  SELECT AwayTeam,
    CASE
        WHEN FTAG > FTHG THEN 'Win'
        WHEN FTAG = FTHG THEN 'Draw'
        ELSE 'Loss'
    END AS Record
  FROM `portfolio-360521.premier_league2019.season_2019` 
)
WHERE Record = 'Draw'
GROUP BY AwayTeam
)

SELECT COALESCE(HomeTeam, 'Man City') Club, IFNULL(hdr.home_draw_record, 0) + IFNULL(adr.away_draw_record, 0) AS draw_record
FROM home_draw_record_CTE hdr
FULL JOIN away_draw_record_CTE adr
    ON hdr.HomeTeam = adr.Awayteam
ORDER BY draw_record DESC
