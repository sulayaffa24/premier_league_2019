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
