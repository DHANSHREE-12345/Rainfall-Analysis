create database RAINFALL_ANALYSIS;

USE RAINFALL_ANALYSIS;

SHOW tables;

select * from `rainfall in india 1901-2015`;
	
alter table `rainfall in india 1901-2015` rename to rainfall_in_india_1901_to_2015;

select * from rainfall_in_india_1901_to_2015;

# 1. Find the SUBDIVISION with the highest average rainfall in the month of June across all years.

SELECT SUBDIVISION, avg(JUN) AS Max_June_Rainfall
FROM rainfall_in_india_1901_to_2015
group by SUBDIVISION
ORDER BY Max_June_Rainfall DESC
LIMIT 1;

# 2. Calculate the total annual rainfall for each state.

SELECT SUBDIVISION, SUM(ANNUAL) AS Total_Annual_Rainfall
FROM rainfall_in_india_1901_to_2015
GROUP BY SUBDIVISION
ORDER BY Total_Annual_Rainfall DESC;

# 3. Get the subdivision with the highest average rainfall during the monsoon season (June to September) for the year 2000.

SELECT SUBDIVISION, AVG(`Jun-Sep`) AS Avg_Monsoon_Rainfall
FROM rainfall_in_india_1901_to_2015
WHERE YEAR = 2000
GROUP BY SUBDIVISION
ORDER BY Avg_Monsoon_Rainfall DESC
LIMIT 1;

# 4. Find the top 5 state with the most rainfall in the winter season (January and February).

SELECT SUBDIVISION, `Jan-Feb`
FROM rainfall_in_india_1901_to_2015
ORDER BY `Jan-Feb` DESC
LIMIT 5;

# 5. Find the average monthly rainfall for each subdivision from 1901 to 2015.

SELECT SUBDIVISION, AVG(JAN) AS Avg_Jan, AVG(FEB) AS Avg_Feb, AVG(MAR) AS Avg_Mar,
       AVG(APR) AS Avg_Apr, AVG(MAY) AS Avg_May, AVG(JUN) AS Avg_Jun, 
       AVG(JUL) AS Avg_Jul, AVG(AUG) AS Avg_Aug, AVG(SEP) AS Avg_Sep, 
       AVG(OCT) AS Avg_Oct, AVG(NOV) AS Avg_Nov
FROM rainfall_in_india_1901_to_2015
GROUP BY SUBDIVISION;


# 6. Calculate the trend of rainfall for each subdivision over the years (1901-2015).

SELECT SUBDIVISION, YEAR, ANNUAL,
       ANNUAL - LAG(ANNUAL, 1) OVER (PARTITION BY SUBDIVISION ORDER BY YEAR) AS Annual_Rainfall_Trend
FROM rainfall_in_india_1901_to_2015;

# 7. Find the year with the highest total annual rainfall across all subdivisions.

SELECT YEAR, SUBDIVISION, SUM(ANNUAL) AS Total_Rainfall
FROM rainfall_in_india_1901_to_2015
GROUP BY YEAR,SUBDIVISION
ORDER BY Total_Rainfall DESC
LIMIT 1;

# 8. Get the subdivision with the lowest average rainfall during the dry season (October to December) across all years.

SELECT SUBDIVISION, AVG(`Oct-Dec`) AS Avg_Dry_Season_Rainfall
FROM rainfall_in_india_1901_to_2015
GROUP BY SUBDIVISION
ORDER BY Avg_Dry_Season_Rainfall ASC
LIMIT 1;

# 9. Find subdivision where the average rainfall in July is above 500 mm.

SELECT SUBDIVISION,  JUL
FROM rainfall_in_india_1901_to_2015
WHERE JUL > 500
ORDER BY JUL DESC;

# 10. Compare the total rainfall of two specific states (e.g., 'Kerala' and 'Tamil Nadu').

SELECT SUBDIVISION, SUM(ANNUAL) AS Total_Annual_Rainfall
FROM rainfall_in_india_1901_to_2015
WHERE SUBDIVISION IN ('Kerala', 'Tamil Nadu')
GROUP BY SUBDIVISION
ORDER BY Total_Annual_Rainfall DESC;

# 11. Identify the 10 wettest years (highest annual rainfall) in the dataset for a specific subdivision.

SELECT YEAR, ANNUAL
FROM rainfall_in_india_1901_to_2015
WHERE SUBDIVISION = 'ANDAMAN & NICOBAR ISLANDS'
ORDER BY ANNUAL DESC
LIMIT 10;

# 12. Determine the average annual rainfall for each decade (e.g., 1901-1910, 1911-1920, etc.) for all subdivisions.

SELECT (YEAR/10)*10 AS Decade, SUBDIVISION, AVG(ANNUAL) AS Avg_Annual_Rainfall
FROM rainfall_in_india_1901_to_2015
GROUP BY Decade, SUBDIVISION
ORDER BY Decade, SUBDIVISION;

# 13. Find the subdivisions with the highest rainfall difference between the months of June and october.

SELECT SUBDIVISION, JUN - OCT AS Rainfall_Difference
FROM rainfall_in_india_1901_to_2015
ORDER BY Rainfall_Difference DESC
LIMIT 1;

# 14. Rank subdivisions by their average rainfall during the pre-monsoon season (March to May).

SELECT SUBDIVISION, AVG(`Mar-May`) AS Avg_PreMonsoon_Rainfall
FROM rainfall_in_india_1901_to_2015
GROUP BY SUBDIVISION
ORDER BY Avg_PreMonsoon_Rainfall DESC;

# 15. Find the top 5 years with the lowest monsoon season rainfall (June to September) across India.

SELECT YEAR, SUM(`Jun-Sep`) AS Total_Monsoon_Rainfall
FROM rainfall_in_india_1901_to_2015
GROUP BY YEAR
ORDER BY Total_Monsoon_Rainfall ASC
LIMIT 5;

# 16. Find the year with the highest average rainfall in a specific subdivision and show the corresponding yearly trend of rainfall.

SELECT r.YEAR, r.SUBDIVISION, r.ANNUAL, 
       (SELECT AVG(ANNUAL) 
        FROM rainfall_in_india_1901_to_2015 
        WHERE SUBDIVISION = r.SUBDIVISION) AS Avg_Subdivision_Rainfall,
       r.ANNUAL - (SELECT AVG(ANNUAL)
                   FROM rainfall_in_india_1901_to_2015
                   WHERE YEAR = r.YEAR) AS Annual_Rainfall_Trend
FROM rainfall_in_india_1901_to_2015 r
WHERE r.ANNUAL = (SELECT MAX(ANNUAL) 
                  FROM rainfall_in_india_1901_to_2015 
                  WHERE SUBDIVISION = r.SUBDIVISION)
AND r.SUBDIVISION = 'ANDAMAN & NICOBAR ISLANDS';

# 17. Get the SUBDIVISION with the highest average rainfall in July, and show its rank within its state based on annual rainfall.

SELECT d.SUBDIVISION, d.JUL, d.ANNUAL,
       (SELECT COUNT(*) + 1 
        FROM rainfall_in_india_1901_to_2015 s
        WHERE s.ANNUAL > d.ANNUAL) AS Rank_In_State
FROM rainfall_in_india_1901_to_2015 d
WHERE d.JUL = (SELECT MAX(JUL) 
               FROM rainfall_in_india_1901_to_2015);

# 18. Find the subdivision with the lowest rainfall in October and compare it with the subdivision's highest rainfall in August.

SELECT r.SUBDIVISION, r.OCT, 
       (SELECT MAX(AUG) 
        FROM rainfall_in_india_1901_to_2015 s 
        WHERE s.SUBDIVISION = r.SUBDIVISION) AS Max_Aug_Rainfall
FROM rainfall_in_india_1901_to_2015 r
WHERE r.OCT = (SELECT MIN(OCT) 
               FROM rainfall_in_india_1901_to_2015);

