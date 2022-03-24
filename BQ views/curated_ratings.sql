DECLARE next_round DEFAULT (SELECT min(round) from curated.schedule WHERE simple_date >= CURRENT_DATE());
CREATE OR REPLACE TABLE curated.difficulty_ratings as

WITH 
recent_games as
(
####grabs the last 7 (check qualify) home and away games for each team
SELECT 
team_short_name
-- , location
-- , date_time_utc
-- , opp_name
, game_id
, RANK() OVER(PARTITION BY team_short_name, location ORDER BY date_time_utc desc) as recency
FROM curated.game_xg_view
QUALIFY recency <= 7) 

, ratings as 
(SELECT 
v.team_short_name
, location
### xgF ratings offense
, AVG(xgf) as xgf
### xgA ratings defense
, AVG(xga) as xga
, COUNT(distinct v.game_id) as sample_size
###, min(date_time_utc) as earliest_game_in_sample

FROM curated.game_xg_view v
INNER JOIN recent_games rg ON rg.team_short_name = v.team_short_name
AND rg.game_id = v.game_id
GROUP BY 1,2
--ORDER BY 3 desc
)

, schedule_creation as
(
SELECT 
s.team_name
, s.short_name
, s.round
, s.location
, s.opp_short_name 
, r.xga as opp_xga
, r.xgf as opp_xgf
, s.date
from curated.schedule s
LEFT JOIN ratings r ON
r.team_short_name = s.opp_short_name 
AND s.location != r.location ###makes sure locations are inverted
WHERE round BETWEEN 
###round_selector
next_round
AND next_round+5 ## between is inclusive of both ends 
)

SELECT 
team_name
, short_name
, COUNT(1) as num_games
, ROUND(100*COUNT(IF(location = 'home', 1, null))/COUNT(1),0) as perc_home_games
, ROUND(AVG(opp_xga),2) as avg_opp_xga ###higher is better  , it's how many xG the opp give up
, ROUND(AVG(opp_xgf),2) as avg_opp_xgf ### lower is better, it's the avg xGF of the opps
, STRING_AGG(IF(location = 'home', UPPER(opp_short_name), LOWER(opp_short_name)), ' | ' ORDER BY date ASC) as next_opps
FROM schedule_creation
GROUP BY 1,2
ORDER BY avg_opp_xgf 