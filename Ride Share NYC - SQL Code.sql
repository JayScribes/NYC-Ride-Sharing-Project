-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

SELECT 1

Skills Used:
Views, Tables, Joins, Aggregates, Extractions
Exploratory Data Analysis and Cleaning with SQL

/* Questions to be answered with this project
1) What are the hours with the most alcohol-related motor vehicle accidents?
2) What are the days with the most alcohol related motor vehicle accidents between the hours found previously?
3) What are the hours with the most ride shares between the days with the most alcohol-related motor vehicle accidents?
4) Does rain/snow/temp predict the frequency of alcohol-related motor vehicle accidents?
5) Does rain/snow/temp predict the frequency of rides? */

## Q1) What are the hours with the most alcohol-related motor vehicle accidents?

CREATE VIEW NY_rideshare.q1temp1 as
SELECT
  EXTRACT(hour from timestamp) as hour_of_accident,
  contributing_factor_vehicle_1,
  timestamp,
  unique_key
FROM
  NY_rideshare.ny_accidents
WHERE
  contributing_factor_vehicle_1 = "Alcohol Involvement"
GROUP BY
  hour_of_accident, contributing_factor_vehicle_1, timestamp, unique_key
ORDER BY
  hour_of_accident

SELECT
  COUNT(distinct unique_key) as num_accidents,
  hour_of_accident
FROM
  NY_rideshare.q1temp1
GROUP BY
  hour_of_accident
ORDER BY
  hour_of_accident
## This indicates that the hours with the highest alcohol-related motor vehicle accidents are 10PM to 6AM

## Q2) What are the days of the week with the most alcohol-related motor vehicle accidents between 10PM and 6AM?

CREATE VIEW NY_rideshare.q2temp1 as
SELECT
  EXTRACT(dayofweek from timestamp) as weekday,
  EXTRACT(time from timestamp) as time_of_accident,
  contributing_factor_vehicle_1,
  timestamp, unique_key
FROM
  NY_rideshare.ny_accidents
WHERE
  contributing_factor_vehicle_1 = "Alcohol Involvement"

SELECT
  COUNT(distinct unique_key) as num_accidents,
FROM
   NY_rideshare.q2temp1
WHERE
  time_of_accident not between "6:01:00" and "21:59:59"
GROUP BY
  weekday
ORDER BY
  weekday

## This indicates that the days of the week with the most alcohol-related motor vehicle accidents between 10PM and 6AM are Friday, Saturday, and Sunday

## Q3) What are the hours with the most ride shares between the days with the most alcohol-related motor vehicle accidents?

CREATE VIEW NY_rideshare.q3temp1 AS
SELECT
  key as uber_key,
  EXTRACT(date from pickup_datetime) as uber_date,
  EXTRACT(hour from pickup_datetime) as uber_hour,
  EXTRACT(dayofweek from pickup_datetime) as uber_day_of_week
FROM
  NY_rideshare.ny_uber
ORDER BY
  uber_date

CREATE VIEW NY_rideshare.q3temp2 as
SELECT
  EXTRACT(date from lpep_pickup_datetime) as taxi_date,
  EXTRACT(hour from lpep_pickup_datetime) as taxi_hour,
  EXTRACT(dayofweek from lpep_pickup_datetime) as tax_day_of_week,
  ROW_NUMBER() OVER (ORDER BY lpep_pickup_datetime) as taxi_key
FROM
  NY_rideshare.ny_taxi
ORDER BY
  taxi_date

SELECT
  COUNT(distinct uber_key) as uber_count,
  uber_hour
FROM
  NY_rideshare.q3temp1
WHERE
  uber_day_of_week = 1 or
  uber_day_of_week = 6 or 
  uber_day_of_week = 7
GROUP BY
  uber_hour
ORDER BY
  uber_hour

SELECT
  COUNT(distinct taxi_key) as taxi_count,
  taxi_hour
FROM
  NY_rideshare.q3temp2
WHERE
  tax_day_of_week = 1 or
  tax_day_of_week = 6 or 
  tax_day_of_week = 7
GROUP BY
  taxi_hour
ORDER BY
  taxi_hour

/* Neither of these show obvious spikes after 9AM. Indicating that there aren't spikes in ride shares when people go out to drink?
Possibly helping support the idea that people are driving out with their cars, drinking, and returning with their cars */

## 4) Does rain/snow/temp predict the prevalence of alcohol-related motor vehicle accidents?

CREATE VIEW NY_rideshare.q4temp1 as
SELECT 
  date,
  PRCP__mm_ as rain_mm,
  SNWD__mm_ as snow_mm,
  TMAX as max_temp,
  TMIN as min_temp
FROM
  NY_rideshare.ny_weather
WHERE 
  date >= "2012-07-01"
GROUP BY 
  date, PRCP__mm_, SNWD__mm_, TMAX, TMIN
ORDER BY 
  date

CREATE VIEW NY_rideshare.q4temp2 as
SELECT 
  COUNT(distinct unique_key) as count_accident,
  EXTRACT(date from timestamp) as date_accident,
FROM
  NY_rideshare.ny_accidents
WHERE
  contributing_factor_vehicle_1 = "Alcohol Involvement" and
  timestamp <= "2020-12-31"
GROUP BY 
  date_accident
ORDER BY
  date_accident

CREATE TABLE NY_rideshare.accidents_weather as ## This table will be imported into R for regression analyses
SELECT 
  *
FROM
  NY_rideshare.q4temp1
RIGHT JOIN NY_rideshare.q4temp2 on
  q4temp1.date = q4temp2.date_accident
ORDER BY
  date

## 5) Does rain/snow/temp predict the frequency of rides? 

Join the uber and taxi tables then join it to the weather table
