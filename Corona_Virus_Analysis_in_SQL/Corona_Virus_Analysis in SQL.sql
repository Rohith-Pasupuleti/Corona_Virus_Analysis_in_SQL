use new_schema;

-- 1 Display the data

select * from Corona_Virus_Dataset;
   

--2 Write a code to check NULL values

SELECT *
FROM Corona_Virus_Dataset
WHERE Province IS NULL OR Country IS NULL OR Latitude IS NULL OR Longitude IS NULL OR Dt IS NULL OR Confirmed IS NULL OR Deaths IS NULL OR Recovered IS NULL;


-- 3 Check total number of rows

SELECT COUNT(*)
FROM Corona_Virus_Dataset;


-- 4 Check what is start_date and end_date

SELECT *
SELECT MIN(Dt) AS start_date, MAX(Dt) AS end_date
FROM Corona_Virus_Dataset;


-- 5 Number of month present in dataset

SELECT COUNT(DISTINCT CONCAT(YEAR(Dt), '-', MONTH(Dt))) AS num_months
FROM Corona_Virus_Dataset;


-- 6 Find monthly average for confirmed, deaths, recovered

SELECT 
    YEAR(Dt) AS year,
    MONTH(Dt) AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM Corona_Virus_Dataset
GROUP BY 
    YEAR(Dt),
    MONTH(Dt)
ORDER BY 
    year,
    month;

    
-- 7 Find most frequent value for confirmed, deaths, recovered each month
 
WITH MonthlyData AS (
    SELECT YEAR(Dt) AS year, MONTH(Dt) AS month, Confirmed, Deaths, Recovered,
        ROW_NUMBER() OVER(PARTITION BY YEAR(Dt), MONTH(Dt) ORDER BY COUNT(*) DESC) AS rank_confirmed,
        ROW_NUMBER() OVER(PARTITION BY YEAR(Dt), MONTH(Dt) ORDER BY COUNT(*) DESC) AS rank_deaths,
        ROW_NUMBER() OVER(PARTITION BY YEAR(Dt), MONTH(Dt) ORDER BY COUNT(*) DESC) AS rank_recovered
    FROM 
        Corona_Virus_Dataset
    GROUP BY 
        YEAR(Dt),
        MONTH(Dt),
        Confirmed,
        Deaths,
        Recovered )

SELECT  year, month,
    MAX(CASE WHEN rank_confirmed = 1 THEN Confirmed ELSE NULL END) AS most_frequent_confirmed,
    MAX(CASE WHEN rank_deaths = 1 THEN Deaths ELSE NULL END) AS most_frequent_deaths,
    MAX(CASE WHEN rank_recovered = 1 THEN Recovered ELSE NULL END) AS most_frequent_recovered
FROM 
    MonthlyData
GROUP BY 
    year,
    month
ORDER BY 
    year,
    month;


-- 8 Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Dt) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM 
    Corona_Virus_Dataset
GROUP BY 
    YEAR(Dt)
ORDER BY 
    year;


-- 9 Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Dt) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM 
    Corona_Virus_Dataset
GROUP BY 
    YEAR(Dt)
ORDER BY 
    year;


-- 10 The total number of cases of confirmed, deaths, recovered each month

SELECT 
    YEAR(Dt) AS year,
    MONTH(Dt) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM 
    Corona_Virus_Dataset
GROUP BY 
    YEAR(Dt),
    MONTH(Dt)
ORDER BY 
    year,
    month;


-- 11 Check how corona virus spread out with respect to confirmed case
-- (Eg.: total confirmed cases, their average, variance & STDEV )


SELECT 
    SUM(Confirmed) AS total_confirmed_cases,
    AVG(Confirmed) AS average_confirmed_cases,
    VARIANCE(Confirmed) AS variance_confirmed_cases,
    SQRT(VARIANCE(Confirmed)) AS standard_deviation_confirmed_cases
FROM 
    Corona_Virus_Dataset;


-- 12 Check how corona virus spread out with respect to death case per month
-- (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Dt) AS year,
    MONTH(Dt) AS month,
    SUM(Confirmed) AS total_confirmed_cases,
    AVG(Confirmed) AS average_confirmed_cases,
    VARIANCE(Confirmed) AS variance_confirmed_cases,
    SQRT(VARIANCE(Confirmed)) AS standard_deviation_confirmed_cases
FROM 
    Corona_Virus_Dataset
GROUP BY  YEAR(Dt), MONTH(Dt)
ORDER BY year, month;


-- 13 Check how corona virus spread out with respect to recovered case
-- (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Dt) AS year,
    MONTH(Dt) AS month,
    SUM(Recovered) AS total_recovered_cases,
    AVG(Recovered) AS average_recovered_cases,
    VARIANCE(Recovered) AS variance_recovered_cases,
    SQRT(VARIANCE(Recovered)) AS standard_deviation_recovered_cases
FROM 
    Corona_Virus_Dataset
GROUP BY YEAR(Dt), MONTH(Dt)
ORDER BY year, month;


-- 14 Find Country having highest number of the Confirmed cases

SELECT 
    Country,
    MAX(Confirmed) AS highest_confirmed_cases
FROM 
    Corona_Virus_Dataset
GROUP BY 
    Country
ORDER BY 
    highest_confirmed_cases DESC
LIMIT 1;


-- 15 Find Country having lowest number of the death case

SELECT 
    Country,
    MIN(Deaths) AS lowest_death_cases
FROM 
    Corona_Virus_Dataset
GROUP BY 
    Country
ORDER BY 
    lowest_death_cases
LIMIT 1;


-- 16 Find top 5 countries having highest recovered case

SELECT 
    Country,
    SUM(Recovered) AS total_recovered_cases
FROM 
    Corona_Virus_Dataset
GROUP BY 
    Country
ORDER BY 
    total_recovered_cases DESC
LIMIT 5;
