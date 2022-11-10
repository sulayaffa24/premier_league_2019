/* 
Using CTEs to get the total number of goals scored.
Using the SUM function to add the number of goals scored
Using the GROUP BY clause since we are using an aggregate function SUM
We can now join the 2 CTEs and add the number of goals scored at home and away
Finally, we can save the query as view in BigQuery then join with the other views to create the final table
*/

WITH home_goals AS (
  SELECT HomeTeam, SUM(FTHG) AS goals_scored_at_home
  FROM `portfolio-360521.premier_league2019.season_2019`
  GROUP BY HomeTeam
),
away_goals AS (
  SELECT AwayTeam, SUM(FTAG) AS goals_scored_away_from_home
  FROM `portfolio-360521.premier_league2019.season_2019`
  GROUP BY AwayTeam
)

SELECT HomeTeam AS club, hg.goals_scored_at_home + ag.goals_scored_away_from_home AS goal_scored
FROM home_goals hg
JOIN away_goals ag
  ON hg.HomeTeam = ag.AwayTeam
ORDER BY goal_scored DESC
