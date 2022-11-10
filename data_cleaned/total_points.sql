/*
First, I wanted to create 2 CTEs 
The first CTE is to get the number of points at home and the second CTE is to get the number of points away from home
A win equates to 3 points, and tie equate to a point and loss equate to 0 points
I decided to SELECT the HomeTeam and create a CASE statement to get the SUM of points
Join both tables
Finally, we can save the query as view in BigQuery then join with the other views to create the final table
*/

WITH points_away_from_home_CTE AS (
  SELECT AwayTeam,
    SUM(CASE
        WHEN FTAG > FTHG THEN 3
        WHEN FTAG = FTHG THEN 1
        ELSE 0
    END) AS Points
  FROM `portfolio-360521.premier_league2019.season_2019` 
  GROUP BY AwayTeam
),
points_at_home_CTE AS (
  SELECT HomeTeam,
  SUM(CASE
      WHEN FTHG > FTAG THEN 3
      WHEN FTHG = FTAG THEN 1
      ELSE 0
  END) AS Points
FROM `portfolio-360521.premier_league2019.season_2019` 
GROUP BY HomeTeam
)

Select pafh.AwayTeam AS Team, pafh.Points + pah.Points AS Points
From points_at_home_CTE pah 
Join points_away_from_home_CTE pafh
  on pafh.AwayTeam = pah.HomeTeam
ORDER BY Points DESC
