/*
Let's find the total number of shots and the number of shots on target by each team
*/
WITH shots_at_home_CTE AS (
  SELECT HomeTeam, SUM(HS) total_shots, SUM(HST) shots_on_target 
  FROM `portfolio-360521.premier_league2019.season_2019` 
  GROUP BY HomeTeam
),
shots_away_from_home AS (
  SELECT AwayTeam, SUM(`portfolio-360521.premier_league2019.season_2019`.AS) total_shots, SUM(AST) shots_on_target 
  FROM `portfolio-360521.premier_league2019.season_2019` 
  GROUP BY AwayTeam
)

SELECT HomeTeam, 
        sah.total_shots + safh.total_shots AS shots, 
        sah.shots_on_target + safh.shots_on_target AS total_shots_on_target,
        ROUND((sah.shots_on_target + safh.shots_on_target) / (sah.total_shots + safh.total_shots), 2) * 100 as shot_accuracy_percentage
FROM shots_at_home_CTE sah
JOIN shots_away_from_home safh
  ON sah.HomeTeam = safh.AwayTeam
ORDER BY shot_accuracy_percentage DESC
