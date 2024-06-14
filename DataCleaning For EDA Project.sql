-- SQL Project - Data Cleaning for Explotarary Data Analysis

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

SELECT * 
FROM world_layoffs.layoffs;


-- Creating Staging Table
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;


-- STEPS for DATA_CLEANING
-- 1. Removing Duplication
-- 2. Data Standardizion and Fixing
-- 3. Null values Checking
-- 4. Removing Unnecessary Columns


-- 1. Removing Duplication

SELECT *
FROM world_layoffs.layoffs_staging
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		world_layoffs.layoffs_staging;

-- Checking Duplications
SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;

SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Oda'
;


-- Confirming Final Duplications
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;


-- CTE_Logic to execute delete duplication but we will not delete at staging 
WITH Duplicates_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1
)
DELETE
FROM Duplicates_CTE
;


ALTER TABLE world_layoffs.layoffs_staging ADD row_num INT;


SELECT *
FROM world_layoffs.layoffs_staging
;

-- Create another staging for to perform data deletion
CREATE TABLE `world_layoffs`.`layoffs_staging1` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

INSERT INTO `world_layoffs`.`layoffs_staging1`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;

-- As we are confirm now row_num>=2 are duplicates we can delete all of it

DELETE FROM world_layoffs.layoffs_staging1
WHERE row_num >= 2;


-- 2. Data Standization and Fixings

SELECT * 
FROM world_layoffs.layoffs_staging1;

-- Checking null value column by column need to manipulate the data or not
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging1
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging1
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;


SELECT *
FROM world_layoffs.layoffs_staging1
WHERE company LIKE 'Bally%';



SELECT *
FROM world_layoffs.layoffs_staging1
WHERE company LIKE 'airbnb%';

-- it looks like airbnb is a travel industry as the other rows , so manipulating these kind of scenario.
-- Need to update industry from other non-null rows to null rows of the same company

-- Change some blank to null , with only Null value it is easy to work

UPDATE world_layoffs.layoffs_staging1
SET industry = NULL
WHERE industry = '';

-- Check Null value

SELECT *
FROM world_layoffs.layoffs_staging1
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- Manipulate Null value with non-null values of same company

UPDATE layoffs_staging1 t1
JOIN layoffs_staging1 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- checking and now Bally's was the only one without a populated row to populate this null values
SELECT *
FROM world_layoffs.layoffs_staging1
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- ---------------------------------------------------

-- Standardize others necessary values too
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging1
ORDER BY industry;

UPDATE layoffs_staging1
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging1
ORDER BY country;

UPDATE layoffs_staging1
SET country = TRIM(TRAILING '.' FROM country);

-- For Exploratory Anlysis Fix the DATE_COLUMN Formats and Type

UPDATE layoffs_staging1
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging1
MODIFY COLUMN `date` DATE;

SELECT *
FROM world_layoffs.layoffs_staging1;


-- 3. Null values checking and Manipulation

-- For next phase of analysis total_laid_off, percentage_laid_off and funds_raised_millions column's null values useful. 
-- That's why no manipulation of data.

-- 4. Removing Unnecessary Columns and rows

SELECT *
FROM world_layoffs.layoffs_staging1
WHERE total_laid_off IS NULL;


SELECT *
FROM world_layoffs.layoffs_staging1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless rows that can't be useful in our analysis
DELETE FROM world_layoffs.layoffs_staging1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- row_num column no need anymore
ALTER TABLE layoffs_staging1
DROP COLUMN row_num;

SELECT * 
FROM world_layoffs.layoffs_staging1;
