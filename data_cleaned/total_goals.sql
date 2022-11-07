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
