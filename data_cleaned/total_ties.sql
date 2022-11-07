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
