-- EDA

-- Exploring Data

-- Finding Trends and Patterns

-- Exploring Outliers

SELECT * 
FROM world_layoffs.layoffs_staging1;

SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging1;


-- MAX and MIN percentage_laid_off
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging1
WHERE  percentage_laid_off IS NOT NULL;

-- Checking Percentage_laid_off = 1 Company , and exploring why these company were so low percentage_laid_off
SELECT company
FROM world_layoffs.layoffs_staging1
WHERE  percentage_laid_off = 1;


-- Checking Order By funds_raised_millions of company
SELECT *
FROM world_layoffs.layoffs_staging1
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt looks like an EV company, Quibi were raised like 2 billion dollars and went under.

-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging1
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging1
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- By Country total_laid_off

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging1
GROUP BY country
ORDER BY 2 DESC;


-- 4 Years of total_laid_off
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging1
GROUP BY YEAR(date)
ORDER BY 1 ASC;

-- Total_laid_off by industry
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging1
GROUP BY industry
ORDER BY 2 DESC;

-- Total_laid_off by stage
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging1
GROUP BY stage
ORDER BY 2 DESC;


-- Checking more detais on layoffs by Complex query with partition time_year and ranking
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging1
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Total of Layoffs by Monthly of year
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
GROUP BY dates
ORDER BY dates ASC;

-- Build a CTE for above total of Layoffs by Monthly of year
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging1
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
