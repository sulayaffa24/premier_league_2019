/* 
Using CTEs to get the number of games played at home and away from home.
Using the COUNT function to count the number of games 
Using the GROUP BY clause since we are using an aggregate function COUNT
We can now join the 2 CTEs and add the number of games played at home and away
Finally, we can save the query as view in BigQuery then join with the other views to create the final table
*/

WITH home_games AS (
    SELECT HomeTeam, COUNT(*) AS h_match_played
    FROM `portfolio-360521.premier_league2019.season_2019` 
    GROUP BY HomeTeam
),
away_games AS (
    SELECT AwayTeam, COUNT(*) AS a_match_played
    FROM `portfolio-360521.premier_league2019.season_2019` 
    GROUP BY Awayteam
)


SELECT HomeTeam, hg.h_match_played + ag.a_match_played AS match_played
FROM home_games hg
JOIN away_games ag
  ON hg.HomeTeam = ag.AwayTeam
