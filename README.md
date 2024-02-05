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

