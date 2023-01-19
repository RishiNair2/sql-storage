----Daily Activity Merged SQL Queries----
SELECT *
FROM daily_activity_merged

----FIND MAX, MIN, AND AVERAGE DISTANCE, MINUTES, STEPS, CALORIES
SELECT id, MAX(total_distance) max_distance, MIN(total_distance) min_distance, 
AVG(total_distance) avg_distance
FROM daily_activity_merged
GROUP BY id;

SELECT id, MAX(total_steps) max_steps, MIN(total_steps) min_steps, 
AVG(total_steps) avg_steps
FROM daily_activity_merged
GROUP BY id;

SELECT id, MAX(calories) max_calories, MIN(calories) min_calories, 
AVG(calories) avg_carlories
FROM daily_activity_merged
GROUP BY id;


SELECT id, SUM(t1.total_minutes) total_minutes_logged,MAX(t1.total_minutes)max_minutes_logged,
AVG(t1.total_minutes) average_minutes_logged, MIN(t1.total_minutes) min_minutes_logged
FROM (
SELECT id, (very_active_minutes + fairly_active_minutes + lightly_active_minutes + 
sedentary_minutes) total_minutes
FROM daily_activity_merged) t1
GROUP BY id

SELECT id, MAX(very_active_minutes) max_very_active_minutes, MIN(very_active_minutes) min_very_active_minutes, 
AVG(very_active_minutes) avg_very_active_minutes
FROM daily_activity_merged
GROUP BY id;

SELECT id, MAX(fairly_active_minutes) max_fairly_active_minutes, MIN(fairly_active_minutes) min_fairly_active_minutes, 
AVG(fairly_active_minutes) avg_fairly_active_minutes
FROM daily_activity_merged
GROUP BY id;

SELECT id, MAX(lightly_active_minutes) max_lightly_active_minutes, MIN(lightly_active_minutes) min_lightly_active_minutes, 
AVG(lightly_active_minutes) avg_lightly_active_minutes
FROM daily_activity_merged
GROUP BY id;

--- TOTAL NUMBER OF PEOPLE WHO LOGGED THEIR ACTIVITY----
SELECT COUNT (DISTINCT id) total_num_of_people
FROM daily_activity_merged

--- HOW MANY TIMES EACH OF THE USERS WORE/USED THE FITBIT TRACKER
SELECT id, COUNT (id) each_id
FROM daily_activity_merged
GROUP BY id

---THE MODE DAY WHERE PEOPLE LOGGED THEIR DATA
SELECT weekday_string as mode_weekday
FROM(
SELECT weekday_string, cnt, DENSE_RANK() OVER (ORDER BY cnt DESC) rnk
FROM (
SELECT weekday_string, COUNT(*) cnt
FROM daily_activity_merged
GROUP BY weekday_string) t1
	)t2
WHERE rnk = 1

-- Average of Each Type of Activity Level By Id---
SELECT id, AVG(very_active_minutes) avg_very_active_minutes,
AVG(fairly_active_minutes) avg_fairly_active_minutes,
AVG(lightly_active_minutes) avg_lightly_active_minutes,
AVG(sedentary_minutes) avg_sedentary_minutes
FROM daily_activity_merged
GROUP BY id

---How Often People are Active By Day---
SELECT weekday_string, AVG(very_active_minutes) avg_very_active_minutes,
AVG(fairly_active_minutes) avg_fairly_active_minutes,
AVG(lightly_active_minutes) avg_lightly_active_minutes,
AVG(sedentary_minutes) avg_sedentary_minutes
FROM daily_activity_merged
GROUP BY weekday_string
ORDER BY weekday_string 

--- If people are on average active or not active by id ---
SELECT id, CASE WHEN t1.total_active_minutes >= 150 THEN 'Meets CDC Recommendation'
ELSE 'Doesn"t Meet CDC Reccomendation' END cdc_reccomendation_category
FROM(
SELECT id, AVG(very_active_minutes) + AVG(fairly_active_minutes) + 
AVG(lightly_active_minutes) total_active_minutes
FROM daily_activity_merged
GROUP BY id) t1

--- If People Are Active They Need To Take more than 10,000 Steps A Day---
SELECT id, AVG(total_steps) avg_total_steps
FROM daily_activity_merged
GROUP BY id

SELECT id, CASE WHEN t1.avg_total_steps < 5000 THEN 'Inactive'
WHEN t1.avg_total_steps BETWEEN 5000 AND 7500 THEN 'Low Active'
WHEN t1.avg_total_steps BETWEEN 7500 AND 9900 THEN 'Somewhat Active'
WHEN t1.avg_total_steps > 10000 THEN 'Active' END active_or_not_active_category
FROM(
SELECT id, AVG(total_steps) avg_total_steps
FROM daily_activity_merged
GROUP BY id) t1

--- Comparisons Between Calories, Total Steps, And How Long They Are Active--
SELECT id, SUM(total_steps) sum_total_steps, SUM(calories) sum_calories,
SUM(very_active_minutes + fairly_active_minutes) sum_active_minutes
FROM daily_activity_merged
GROUP BY id

--- How many steps people took on average each day ----
SELECT weekday_string, AVG(total_steps) avg_total_steps
FROM daily_activity_merged
GROUP BY weekday_string
ORDER BY avg_total_steps DESC

--- Activity Level Vs Time In Bed ---
SELECT a.id, AVG(calories) avg_calories, AVG(total_minutes_asleep) avg_min_asleep
FROM daily_activity_merged a
JOIN sleep_day_merged s
ON a.id = s.id
GROUP BY a.id

