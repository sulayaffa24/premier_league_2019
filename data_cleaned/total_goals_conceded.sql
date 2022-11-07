WITH goals_conceded_at_home_CTE AS (
SELECT HomeTeam, SUM(FTAG) AS goals_conceded_at_home
FROM `portfolio-360521.premier_league2019.season_2019`
GROUP BY HomeTeam
),
goals_conceded_away_from_home_CTE AS (
SELECT AwayTeam, SUM(FTHG) AS goals_conceded_away
FROM `portfolio-360521.premier_league2019.season_2019`
GROUP BY AwayTeam
)

SELECT Hometeam, gch.goals_conceded_at_home + gca.goals_conceded_away AS goals_against
FROM goals_conceded_at_home_CTE gch
JOIN goals_conceded_away_from_home_CTE gca
  ON gch.Hometeam = gca.AwayTeam
ORDER BY goals_against
