WITH home_win_record_CTE AS (
  SELECT HomeTeam, COUNT(Record) AS home_win_record
FROM (
  SELECT HomeTeam,
    CASE
        WHEN FTHG > FTAG THEN 'Win'
        WHEN FTHG = FTAG THEN 'Draw'
        ELSE 'Loss'
    END AS Record
  FROM `portfolio-360521.premier_league2019.season_2019` 
)
WHERE Record = 'Win'
GROUP BY HomeTeam
),
away_win_record_CTE AS (
 SELECT AwayTeam, COUNT(Record) AS away_win_record
FROM (
  SELECT AwayTeam,
    CASE
        WHEN FTAG > FTHG THEN 'Win'
        WHEN FTAG = FTHG THEN 'Draw'
        ELSE 'Loss'
    END AS Record
  FROM `portfolio-360521.premier_league2019.season_2019` 
)
WHERE Record = 'Win'
GROUP BY AwayTeam
)

SELECT HomeTeam, hwr.home_win_record + awr.away_win_record AS win_record
FROM home_win_record_CTE hwr
JOIN away_win_record_CTE awr
    ON hwr.HomeTeam = awr.Awayteam
ORDER BY win_record DESC
