SELECT *
FROM weight_log_info_merged
--- The different ids associated with the weight log info table ---
SELECT id, COUNT(*) num_ids
FROM weight_log_info_merged
GROUP BY id
---Summary Statistics---
SELECT id, AVG (weight_pound) avg_weight_pound, 
SUM(weight_pound) sum_weight_pound
FROM weight_log_info_merged
GROUP BY id
ORDER BY avg_weight_pound DESC

SELECT id, AVG (weight_kg) avg_weight_kg, 
SUM(weight_kg) sum_weight_kg
FROM weight_log_info_merged
GROUP BY id
ORDER BY avg_weight_kg DESC

SELECT id, AVG (bmi) avg_bmi, 
SUM(bmi) sum_bmi
FROM weight_log_info_merged
GROUP BY id
ORDER BY avg_bmi DESC

SELECT id, AVG(time) avg_time
FROM weight_log_info_merged
GROUP BY id
ORDER BY avg_time DESC

--- Find weekday associated with each date---
SELECT id,date, DATE_PART('dow', date) day_of_week
FROM weight_log_info_merged

--- Find weekday assoicated with each date with day of week in text form---
SELECT id,date, DATE_PART('dow', date) day_of_week, 
To_char(date, 'Day') day_of_week_string
FROM weight_log_info_merged

--- What BMI Category is the most ---
SELECT bmi_category, COUNT(CASE WHEN bmi_category='Healthy' THEN 1
WHEN bmi_category='Overweight' THEN 1
WHEN bmi_category='Obese' THEN 1 ELSE NULL END) AS bmi_count
FROM weight_log_info_merged
GROUP BY bmi_category
ORDER BY bmi_count DESC;

--- At what hour did these users usually log their weight info---
SELECT id, AVG(t1.hours) avg_hour_logged
FROM (
SELECT id, EXTRACT(HOUR FROM time) hours
FROM weight_log_info_merged) t1
GROUP BY id
ORDER BY avg_hour_logged DESC;

--- Average Weight In Pounds Associated With Each Id Using Window Function---
SELECT id, bmi_category, AVG(weight_pound) OVER(PARTITION BY id) rolling_avg_weight
FROM weight_log_info_merged

--- Calories Burned vs BMI---
SELECT bmi_category, bmi, calories
FROM weight_log_info_merged w
JOIN daily_activity_merged d
ON w.id = d.id

SELECT bmi_category, AVG(calories) avg_calories
FROM weight_log_info_merged w
JOIN daily_activity_merged d
ON w.id = d.id
GROUP BY bmi_category
ORDER BY avg_calories DESC;
