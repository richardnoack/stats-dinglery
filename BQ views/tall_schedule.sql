#### this transforms the schedule into a tall format with 1 row per game per team
CREATE OR REPLACE TABLE curated.schedule as 
WITH 
fixed_names as 
(SELECT * EXCEPT(home_squad_short_name, away_squad_short_name)
, 
CASE 
WHEN home_squad_short_name = 'NE' THEN 'NER'
WHEN home_squad_short_name = 'DC' THEN 'DCU'
WHEN home_squad_short_name = 'LA' THEN 'LAG'
WHEN home_squad_short_name = 'SJ' THEN 'SJE'
WHEN home_squad_short_name = 'DAL' THEN 'FCD'
WHEN home_squad_short_name = 'RBNY' THEN 'NYRB'
ELSE home_squad_short_name
END AS home_squad_short_name

, 
CASE 
WHEN away_squad_short_name = 'NE' THEN 'NER'
WHEN away_squad_short_name = 'DC' THEN 'DCU'
WHEN away_squad_short_name = 'LA' THEN 'LAG'
WHEN away_squad_short_name = 'SJ' THEN 'SJE'
WHEN away_squad_short_name = 'DAL' THEN 'FCD'
WHEN away_squad_short_name = 'RBNY' THEN 'NYRB'
ELSE away_squad_short_name
END AS away_squad_short_name
 FROM asa_xg.schedule

)
, home AS
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
FROM fixed_names
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
FROM fixed_names)

SELECT * FROM home
UNION ALL
SELECT * FROM away