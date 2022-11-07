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
