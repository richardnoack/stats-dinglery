#### this transforms the schedule into a tall format with 1 row per game per team
CREATE OR REPLACE TABLE curated.schedule as 
WITH home AS
(SELECT 
id as match_id
, round
, real_round
, `date`
, DATE(`date`) as simple_date
, home_squad_id as team_id
, home_squad_name as team_name
, home_squad_short_name as short_name
, away_squad_id as opp_id
, away_squad_name as opp_name
, away_squad_short_name as opp_short_name
, venue_name as stadium
, 'home' as location
FROM asa_xg.schedule
)
, away as
(SELECT 
id as match_id
, round
, real_round
, `date`
, DATE(`date`) as simple_date
, away_squad_id as team_id
, away_squad_name as team_name
, away_squad_short_name as short_name
, home_squad_id as opp_id
, home_squad_name as opp_name
, home_squad_short_name as opp_short_name
, venue_name as stadium
, 'away' as location
FROM asa_xg.schedule)

SELECT * FROM home
UNION ALL
SELECT * FROM away