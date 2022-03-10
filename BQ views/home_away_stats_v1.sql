WITH home_stats as 
(
SELECT xg.home_team_id as team_id
, t.team_name
, 'home' as location 
, COUNT(game_id) as num_games
, AVG(home_player_xgoals) as home_xgf_avg
--, APPROX_QUANTILES(home_player_xgoals, 100)[OFFSET(50)] as home_xgf_med
, AVG(away_player_xgoals) as home_xga_avg
--, APPROX_QUANTILES(away_player_xgoals, 100)[OFFSET(50)] as home_xga_med
FROM asa_xg.game_xg xg 
LEFT JOIN asa_xg.mls_teams t ON t.team_id = xg.home_team_id
WHERE 
DATE(date_time_utc) >= DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)
GROUP BY 1,2,3)

, away_stats as 
(SELECT xg.away_team_id as team_id
, t.team_name
, 'away' as location 
, COUNT(game_id) as num_games
, AVG(away_player_xgoals) as away_xgf_avg
--, APPROX_QUANTILES(away_player_xgoals, 100)[OFFSET(50)] as away_xgf_med
, AVG(home_player_xgoals) as away_xga_avg
--, APPROX_QUANTILES(home_player_xgoals, 100)[OFFSET(50)] as away_xga_med
FROM asa_xg.game_xg xg 
LEFT JOIN asa_xg.mls_teams t ON t.team_id = xg.away_team_id
WHERE 
DATE(date_time_utc) >= DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)
GROUP BY 1,2,3
)

SELECT 
