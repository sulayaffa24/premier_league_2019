WITH cards_at_home_CTE AS (
  SELECT Referee, COUNT(*) num_of_games, SUM(HC) yellow_cards_home, SUM(HR) red_cards_home
  FROM `portfolio-360521.premier_league2019.season_2019`
  GROUP BY Referee
),
cards_at_away_CTE AS (
  SELECT Referee, COUNT(*) num_of_games, SUM(AC) yellow_cards_away, SUM(AR) red_cards_away
  FROM `portfolio-360521.premier_league2019.season_2019`
  GROUP BY Referee
)

SELECT Referee,
        cah.num_of_games + caa.num_of_games AS number_of_games,
        cah.yellow_cards_home + caa.yellow_cards_away AS num_yellow_cards, 
        cah.red_cards_home + caa.red_cards_away AS num_red_cards
FROM cards_at_home_CTE cah
JOIN cards_at_away_CTE caa
  USING(Referee)
ORDER BY num_yellow_cards DESC
