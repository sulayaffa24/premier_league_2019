# 2018/19 Premier League SQL and Tableau Project

I will build the final table of the 2018/19 premier league table with the following columns:

- Football Club
- Number of matches played
- Number of games won
- Number of games tied
- Number of games lost
- Total points of the season
- Number of goals 
- Number of goals conceded
- Goal difference

### Number of Matches Played
___

I will start with the number of matches played. Each team plays 38 games in total 19 games at home and 19 games away from home. I will first get the number of games played at home and a separate query to get the number of games played away from home. Later I will combine these queries using a `CTE` to get the total games played in the season.

```sql
WITH home_games_CTE AS (
    SELECT hometeam, COUNT(*) AS number_of_games_played
    FROM public.premier_league
    GROUP BY hometeam
),
away_games_CTE AS (
    SELECT awayteam, COUNT(*) AS number_of_games_played
    FROM public.premier_league
    GROUP BY awayteam
)

SELECT 
    hometeam AS Club, 
    hg.number_of_games_played + ag.number_of_games_played AS games_played
FROM home_games_CTE hg
JOIN away_games_CTE ag
ON hg.hometeam = ag.awayteam
```

**Results**

Club | games_played|
-----|-------------|
Chelsea | 38       |
Wolves | 38        |
Bournemouth | 38   |
Burnley | 38       |
Chelsea | 38       |
Everton | 38       |
West Ham | 38      |
Tottenham | 38     |
Leicester | 38     |
Huddersfield | 38  |
Man United |  38   |
Cardiff | 38       |
Fulham | 38        |
Liverpool | 38     |
Crystal Palace | 38  |
Arsenal | 38       |
Brighton |  38    |
Southampton | 38       |
Watford | 38       |
Newcastle | 38       |
Man City | 38       |


### Number of Games Won
___

Let's get the number of games won by each team, like the previous query we will start with the number of games won at home and then away from home and combine both queries to get the total games won in the season using a `CTE` just like the last query.

```sql
WITH wins_at_home_CTE AS (
    SELECT
        hometeam,
        COUNT(Record) AS Home_Win_Record
    FROM (
        SELECT 
            hometeam,
            CASE
                WHEN fthg > ftag THEN 'Win'
                WHEN fthg = ftag THEN 'Draw'
                ELSE 'Loss'
            END AS Record
        FROM public.premier_league
    ) Home_Record
    WHERE Record = 'Win'
    GROUP BY hometeam 
),
wins_away_from_home_CTE AS (
    SELECT
        awayteam,
        COUNT(Record) AS Away_Win_Record
    FROM (
        SELECT 
            awayteam,
            CASE
                WHEN fthg < ftag THEN 'Win'
                WHEN fthg = ftag THEN 'Draw'
                ELSE 'Loss'
            END AS Record
        FROM public.premier_league
    ) Away_Record
    WHERE Record = 'Win'
    GROUP BY awayteam
)

SELECT
    hometeam AS Club,
    Home_Win_Record + Away_Win_Record AS win_record 
FROM wins_at_home_CTE wah
JOIN wins_away_from_home_CTE wafh
ON wah.hometeam = wafh.awayteam
ORDER BY win_record DESC
```

**Results**

Club | win_record|
-----|-------------|
Man City | 32      |
Liverpool | 30     |
Tottenham | 23     |
Arsenal  |  21     |
Chelsea | 21       |
Man United | 19    |
Wolves | 16        |
Everton | 15       |
West Ham |  15     |
Leicester | 15     |
Watford | 14       |
Crystal Palace | 14   |
Bournemouth | 13      |
Newcastle | 12      |
Burnley | 11      |
Cardiff |  10     |
Brighton |  9   |
Southampton  |  9  |
Fulham  | 7   |
Huddersfield |  3  |

### Number of Games tied
___

We would use the same method as the `win_record` queries

```sql
WITH home_draw_CTE AS (
    SELECT
        hometeam,
        COUNT(Record) AS Home_Draw_Record
    FROM (
        SELECT 
            hometeam,
            CASE
                WHEN fthg > ftag THEN 'Win'
                WHEN fthg = ftag THEN 'Draw'
                ELSE 'Loss'
            END AS Record
        FROM public.premier_league
    ) Home_Record
    WHERE Record = 'Draw'
    GROUP BY hometeam 
),
away_draw_CTE AS (
    SELECT
        awayteam,
        COUNT(Record) AS Away_Draw_Record
    FROM (
        SELECT 
            awayteam,
            CASE
                WHEN fthg < ftag THEN 'Win'
                WHEN fthg = ftag THEN 'Draw'
                ELSE 'Loss'
            END AS Record
        FROM public.premier_league
    ) Away_Record
    WHERE Record = 'Draw'
    GROUP BY awayteam
)

SELECT
    COALESCE(hometeam,'Man City') AS Club,
    COALESCE(Home_Draw_Record, 0) + COALESCE(Away_Draw_Record, 0) AS draw_record 
FROM home_draw_CTE hd
FULL OUTER JOIN away_draw_CTE ad
ON hd.hometeam = ad.awayteam
ORDER BY draw_record DESC

```

**Results**

Club | tied_record|
-----|-------------|
Southampton | 12   |
Wolves | 9         |
Chelsea | 9        |
Newcastle | 9      |
Man United | 9     |
Brighton | 9       |
Everton | 9        |
Watford | 8        |
Leicester | 7      |
Burnley  |  7      |
Crystal Palace | 7  |
Huddersfield |  7   |
Arsenal    |   7    |
Liverpool  |   7    |
West Ham   |   7    |
Bournemouth |   6   |
Fulham      |   5   |
Cardiff     |   4   |
Tottenham   |   2   |
Man City    |   2   |


### Number of Games Lost
___

Number of games lost.

```sql
WITH home_loss_CTE AS (
    SELECT
        hometeam,
        COUNT(Record) AS Home_Loss_Record
    FROM (
        SELECT 
            hometeam,
            CASE
                WHEN fthg < ftag THEN 'Loss'
                WHEN fthg = ftag THEN 'Draw'
                ELSE 'Win'
            END AS Record
        FROM public.premier_league
    ) Home_Record
    WHERE Record = 'Loss'
    GROUP BY hometeam 
),
away_loss_CTE AS (
    SELECT
        awayteam,
        COUNT(Record) AS Away_Loss_Record
    FROM (
        SELECT 
            awayteam,
            CASE
                WHEN fthg > ftag THEN 'Loss'
                WHEN fthg = ftag THEN 'Draw'
                ELSE 'Win'
            END AS Record
        FROM public.premier_league
    ) Away_Record
    WHERE Record = 'Loss'
    GROUP BY awayteam
)

SELECT
    COALESCE(hometeam, 'Liverpool') AS Club,
    COALESCE(Home_Loss_Record, 0) + COALESCE(Away_Loss_Record, 0) AS loss_record 
FROM home_loss_CTE hl
FULL OUTER JOIN away_loss_CTE al
ON hl.hometeam = al.awayteam
ORDER BY loss_record

```

**Results**

Club | loss_record|
-----|-------------|
Liverpool | 1      |
Man City | 4       |
Chelsea | 8        |
Arsenal  |  10     |
Man United | 10    |
Wolves  | 13       |
Tottenham | 13     |
Everton | 14       |
Watford | 16       |
West Ham | 16      |
Leicester | 16     |
Crystal Palace | 17      |
Newcastle | 17      |
Southampton  |  17  |
Bournemouth | 19      |
Burnley |   20      |
Brighton |  20      |
Cardiff  | 24       |
Fulham   |  26      |
Huddersfield  |  28 |

### Total Points of the Season
___

A win equates to 3 points a draw equates to a point and a loss equates a zero points.

```sql
WITH points_home_CTE AS (
SELECT
    hometeam,
    SUM(CASE
            WHEN fthg > ftag THEN 3
            WHEN fthg = ftag THEN 1
            ELSE 0
        END) AS Points
FROM public.premier_league
GROUP BY hometeam
),
points_away_CTE AS (
SELECT
    awayteam,
    SUM(CASE
            WHEN fthg < ftag THEN 3
            WHEN fthg = ftag THEN 1
            ELSE 0
        END) AS Points
FROM public.premier_league
GROUP BY awayteam
)

SELECT
    hometeam AS Clubs,
    ph.Points +  pa.Points AS total_points
FROM points_home_CTE ph
JOIN points_away_CTE pa 
ON ph.hometeam = pa.awayteam
ORDER BY total_points DESC

```

**Results**

Club | total_points|
-----|-------------|
Man City | 98      |
Liverpool | 97     |
Chelsea | 72       |
Tottenham | 71     |
Arsenal | 70       |
Man United | 66    |
Wolves | 57        |
Everton | 54       |
West Ham |  52     |
Leicester  |  52   |
Watford | 50       |
Crystal Palace | 49 |
Newcastle | 45      |
Bournemouth | 45    |
Burnley | 40       |
Southampton |  39  |
Brighton  | 36      |
Cardiff | 34       |
Fulham | 26      |
Huddersfield | 16   |

### Number of Goals Scored
___

```sql
WITH home_goals_CTE AS (
    SELECT hometeam, SUM(fthg) AS home_goal
    FROM public.premier_league
    GROUP BY  hometeam
),
away_goals_CTE AS (
    SELECT awayteam, SUM(ftag) AS away_goal
    FROM public.premier_league
    GROUP BY  awayteam
)

SELECT
    hometeam AS Club,
    home_goal + away_goal AS total_goals
FROM home_goals_CTE hg
JOIN away_goals_CTE ag
ON hg.hometeam = ag.awayteam
ORDER BY total_goals DESC
```

**Results**

Club | total_goals|
-----|-------------|
Man City | 95      |
Liverpool | 89     |
Arsenal | 73       |
Tottenham | 67     |
Man United | 65    |
Chelsea | 63       |
Bournemouth | 56   |
Everton | 54       |
West Ham |  52     |
Watford | 52       |
Crystal Palace | 51     |
Leicester | 51     |
Wolves | 47       |
Southampton |  45  |
Burnley  |  45    |
Newcastle  |  42  |
Brighton  |  35   |
Fulham    |  34   |
Cardiff   |  34   |
Huddersfield | 22 |


### Number of Goals Conceded
___

```sql
WITH goals_conceded_home_CTE AS (
    SELECT hometeam, SUM(ftag) AS home_goal_conceded
    FROM public.premier_league
    GROUP BY  hometeam
),
goals_conceded_away_CTE AS (
    SELECT awayteam, SUM(fthg) AS away_goal_conceded
    FROM public.premier_league
    GROUP BY  awayteam
)

SELECT
    hometeam AS Club,
    home_goal_conceded + away_goal_conceded AS total_goals_conceded
FROM goals_conceded_home_CTE gch 
JOIN goals_conceded_away_CTE gca 
ON gch.hometeam = gca.awayteam
ORDER BY total_goals_conceded
```

**Results**

Club | total_goals_conceded|
-----|-------------|
Liverpool | 22      |
Man City | 23     |
Chelsea | 39     |
Tottenham | 39     |
Wolves | 46     |
Everton | 46     |
Newcastle | 48     |
Leicester | 48     |
Arsenal  |  51    |
Crystal Palace | 53     |
Man United | 54     |
West Ham | 55     |
Watford | 59     |
Brighton | 60     |
Southampton |  65  |
Burnley | 68     |
Cardiff | 69     |
Bournemouth | 70     |
Huddersfield | 76     |
Fulham   |   81   |


### Final Table
___

Now that we have cleaned up the data we can now build the final table of the season. I created a view on all the results to combine them in one table.

```sql
SELECT
	mp.hometeam AS Club,
	mp.games_played AS games,
	gw.total_wins AS wins,
	gt.total_draw AS draws,
	gl.total_loss AS lost,
	pts.total_points AS points,
	gs.total_goals AS goals_scored,
	gc.total_goals_conceded AS goals_conceded,
	gs.total_goals - gc.total_goals_conceded AS goal_difference
FROM public.matches_played mp
JOIN games_won gw
ON mp.hometeam = gw.hometeam
JOIN games_tied gt
ON gw.hometeam = gt.club
JOIN games_lost gl
ON gt.club = gl.club
JOIN points pts
ON gl.club = pts.club
JOIN goals_scored gs
ON pts.club = gs.club
JOIN goals_conceded gc
ON gs.club = gc.club
ORDER BY points DESC
```

**Results**

Club  | games  |  wins  |  draws  | lost  |  points  |  goals_scored  | goals_conceded | goal_diff |
------|--------|--------|---------|-------|----------|----------------|----------------|-----------|
Man City|  38  |   32   |    2    |   4   |    98    |      95        |        23      |      72   |
Liverpool|  38  |   30   |    7    |   1   |    97    |      89        |        22      |      67   |
Chelsea|  38  |   21   |    9    |   8   |    72    |      63        |        39      |      24   |
Tottenham|  38  |   23   |    2    |   13   |    71    |      67        |        39      |      28   |
Arsenal|  38  |   21   |    7    |   10   |    70    |      73        |        51      |      22   |
Man United|  38  |   19   |    9    |   10   |    66    |      65        |        54      |      11   |
Wolves|  38  |   16   |    9    |   13   |    57    |      47        |        46      |      1   |
Everton|  38  |   15   |    9    |   14   |    54    |      54        |        46      |      8   |
West Ham|  38  |   15   |    7    |   16   |    52    |      52        |        55      |      -3   |
Leicester|  38  |   15   |    7    |   16   |    52    |      51        |        48      |      3   |
Watford|  38  |   14   |    8    |   16   |    50    |      52        |        59      |      -7   |
Crystal Palace|  38  |   14   |    7    |   17   |    49    |      51        |        53      |      -2   |
Newcastle|  38  |   12   |    9    |   17   |    45    |      42        |        48      |      -6   |
Bournemouth|  38  |   13   |    6    |   19   |    45    |      56        |        70      |      -14   |
Burnley|  38  |   11   |    7    |   20   |    40    |      45        |        68      |      -23   |
Southampton|  38  |   9   |    12    |   17   |    39    |      45        |        65      |      -20   |
Brighton|  38  |   9   |    9    |   20   |    36    |      35        |        60      |      -25   |
Cardiff|  38  |   10   |    4    |   24   |    34    |      34        |        69      |      -35   |
Fulham|  38  |   7   |    5    |   26   |    26    |      34        |        81      |      -47   |
Huddersfield|  38  |   3   |    7    |   28   |    16    |      22        |        76      |      -54   |
