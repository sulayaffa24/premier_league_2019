/*
First, I wanted to create 2 CTEs 
The first CTE is to get the loss record at home and the second CTE is to get the loss record away from home
I decided to SELECT the HomeTeam and create a CASE statement to get the win, tie, loss record
But for this query we are focusing on the loss record
Then using that query as a subquery to COUNT the number of time a team has lost
Create a CTE with the previous query and do the same when the team plays away from home
Join both tables
Since Liverpool only lost once away from home, we can't add a null value with an integer so we use the IFNULL function
And Liverpool is the only team missing so I used the COALESCE function
*/

WITH home_loss_record_CTE AS (
  SELECT HomeTeam, COUNT(Record) AS home_loss_record
FROM (
  SELECT HomeTeam,
    CASE
        WHEN FTHG < FTAG THEN 'Loss'
        WHEN FTHG = FTAG THEN 'Draw'
        ELSE 'Win'
    END AS Record
  FROM `portfolio-360521.premier_league2019.season_2019` 
)
WHERE Record = 'Loss'
GROUP BY HomeTeam
),
away_loss_record_CTE AS (
SELECT AwayTeam, COUNT(Record) AS away_loss_record
FROM (
  SELECT AwayTeam,
    CASE
        WHEN FTHG > FTAG THEN 'Loss'
        WHEN FTHG = FTAG THEN 'Draw'
        ELSE 'Win'
    END AS Record
  FROM `portfolio-360521.premier_league2019.season_2019` 
)
WHERE Record = 'Loss'
GROUP BY AwayTeam
)

SELECT COALESCE(HomeTeam, 'Liverpool') AS Club, IFNULL(hlr.home_loss_record, 0) + IFNULL(alr.away_loss_record, 0) AS loss_record
FROM home_loss_record_CTE hlr
FULL OUTER JOIN away_loss_record_CTE alr
    ON hlr.HomeTeam = alr.AwayTeam
ORDER BY loss_record
