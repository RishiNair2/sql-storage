SELECT *
FROM sleep_day_merged
--- The different ids associated with the sleep log ---
SELECT id, COUNT(*) num_ids
FROM sleep_day_merged
GROUP BY id

--- How many times each person logged their sleep records
SELECT id, COUNT(total_sleep_records) tot_sleep_records
FROM sleep_day_merged
GROUP BY id

---Summary Statistics---
SELECT id, AVG (total_minutes_asleep) avg_minutes_asleep, 
SUM(total_minutes_asleep) sum_minutes_asleep
FROM sleep_day_merged
GROUP BY id
ORDER BY avg_minutes_asleep DESC

SELECT id, AVG (total_time_in_bed) avg_time_in_bed, 
SUM(total_time_in_bed) sum_minutes_asleep
FROM sleep_day_merged
GROUP BY id
ORDER BY avg_time_in_bed DESC

--- Find weekday associated with each date---
SELECT id,sleep_day, DATE_PART('dow', sleep_day) day_of_week
FROM sleep_day_merged

--- Find weekday assoicated with each date with day of week in text form---
SELECT id,sleep_day, DATE_PART('dow', sleep_day) day_of_week, 
To_char(sleep_day, 'Day') day_of_week_string
FROM sleep_day_merged

--- Find day of week where users slept the most on average---
SELECT t1.day_of_week new_day_of_week, AVG(total_minutes_asleep) avg_minutes_asleep
FROM(
SELECT id, DATE_PART('dow', sleep_day) day_of_week, total_minutes_asleep
FROM sleep_day_merged) t1
GROUP BY new_day_of_week
ORDER BY avg_minutes_asleep DESC

---Find day of week where users slept the most ---
SELECT t1.day_of_week new_day_of_week, SUM(total_minutes_asleep) sum_minutes_asleep
FROM(
SELECT id, DATE_PART('dow', sleep_day) day_of_week, total_minutes_asleep
FROM sleep_day_merged) t1
GROUP BY new_day_of_week
ORDER BY sum_minutes_asleep DESC

--- Users with the most minutes of sleep---
SELECT sleep_day, SUM(total_minutes_asleep) total_min_asleep
FROM sleep_day_merged
GROUP BY sleep_day

--- How long it takes users to fall asleep---
SELECT id, (total_time_in_bed - total_minutes_asleep) time_it_takes_to_sleep
FROM sleep_day_merged
ORDER BY time_it_takes_to_sleep DESC;

--- Average time it takes users to fall asleep---
SELECT id, AVG(total_time_in_bed - total_minutes_asleep) avg_time_it_takes_to_sleep
FROM sleep_day_merged
GROUP BY id
ORDER BY avg_time_it_takes_to_sleep DESC;

---Convert total minutes asleep to hours---
SELECT id, (total_minutes_asleep/60) time_it_takes_to_sleep_hrs
FROM sleep_day_merged
ORDER BY time_it_takes_to_sleep_hrs DESC;

--- Average Hours Slept for each id----
SELECT id, AVG(FLOOR(total_minutes_asleep/60)) avg_hrs_sleep
FROM sleep_day_merged
GROUP BY id
ORDER BY avg_hrs_sleep DESC;

---Sleep Category of Underslept, Overslept, and Healthy Sleep
SELECT id, CASE WHEN t1.time_it_takes_to_sleep_hrs <7 THEN 'Underslept'
WHEN t1.time_it_takes_to_sleep_hrs >= 7 AND t1.time_it_takes_to_sleep_hrs <= 9 THEN 'Healthy Sleep'
WHEN t1.time_it_takes_to_sleep_hrs > 9 THEN 'Overslept' END AS score_category
FROM(
SELECT id, (total_minutes_asleep/60) time_it_takes_to_sleep_hrs
FROM sleep_day_merged) t1

-- How many people Underslept, Overslept, and had Healthy Sleep---
SELECT id,SUM(CASE WHEN t2.score_category ='Underslept' THEN 1 ELSE 0 END) underslept_count
FROM(
SELECT id, CASE WHEN t1.time_it_takes_to_sleep_hrs <7 THEN 'Underslept'
WHEN t1.time_it_takes_to_sleep_hrs >= 7 AND t1.time_it_takes_to_sleep_hrs <= 9 THEN 'Healthy Sleep'
WHEN t1.time_it_takes_to_sleep_hrs > 9 THEN 'Overslept' END AS score_category
FROM(
SELECT id, (total_minutes_asleep/60) time_it_takes_to_sleep_hrs
FROM sleep_day_merged) t1) t2
GROUP BY id
ORDER BY underslept_count DESC