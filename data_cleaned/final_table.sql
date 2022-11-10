/*
Final Table
Joined all the tables to get the final table
*/

SELECT w.HomeTeam AS Club, 
        mp.match_played AS games_played, 
        w.win_record AS wins, 
        d.draw_record, 
        l.loss_record, 
        gf.goal_scored, 
        ga.goals_against, 
        gf.goal_scored - ga.goals_against AS goal_difference,
        tp.Points
FROM `portfolio-360521.premier_league2019.wins` w
JOIN `portfolio-360521.premier_league2019.draws` d
  ON w.HomeTeam = d.Club
JOIN `portfolio-360521.premier_league2019.losses` l
  ON d.Club = l.Club
JOIN `portfolio-360521.premier_league2019.matches_played` mp
  ON l.Club = mp.HomeTeam
JOIN `portfolio-360521.premier_league2019.goals_for` gf
  ON mp.HomeTeam = gf.club
JOIN `portfolio-360521.premier_league2019.goals_against` ga
  ON gf.club = ga.Hometeam
JOIN `portfolio-360521.premier_league2019.total_points` tp
  ON ga.Hometeam = tp.Team
ORDER BY Points DESC
