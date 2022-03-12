CREATE OR REPLACE TABLE curated.game_xg AS

WITH home AS
(SELECT 
game_id
, date_time_utc
, home_team_id as team_id
, t.team_name
, t.team_short_name
, ROUND(home_player_xgoals,2) as xgf
, away_team_id as opp_id
, t2.team_name as opp_name
, t2.team_short_name as opp_short_name
, ROUND(away_player_xgoals,2) as xga
, ROUND(player_xgoal_difference,2) as xgd
, ROUND(home_xpoints,2) as xpoints
, 'home' as location
FROM asa_xg.game_xg g
LEFT JOIN asa_xg.mls_teams t on t.team_id = g.home_team_id
LEFT JOIN asa_xg.mls_teams t2 on t2.team_id = g.away_team_id

), 

away AS
(SELECT 
game_id
, date_time_utc
, away_team_id as team_id
, t2.team_name 
, t2.team_short_name
, ROUND(away_player_xgoals,2) as xgf
, home_team_id as opp_id
, t.team_name as opp_name
, t.team_short_name as opp_short_name
, ROUND(home_player_xgoals,2) as xga
, ROUND(player_xgoal_difference*-1,2) as xgd
, ROUND(away_xpoints,2) as xpoints
, 'away' as location
FROM asa_xg.game_xg g
LEFT JOIN asa_xg.mls_teams t on t.team_id = g.home_team_id
LEFT JOIN asa_xg.mls_teams t2 on t2.team_id = g.away_team_id
)

SELECT * FROM home
UNION ALL
SELECT * FROM away