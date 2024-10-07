-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Find max and min total_laid_off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- find all row with percentage_laid_off = 1 and order funds_raised_millions descending
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Find sum of total_laid_off of company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- find all row with total_laid_off = 12000
SELECT *
FROM layoffs_staging2
WHERE total_laid_off = 12000;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- find total number of layoffs grouped by month
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;
;

WITH Rolling_Total AS(
	SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY month
    ORDER BY 1
)

SELECT `Month`, total_off,SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;


SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

-- Use to rank companies based on the number of employees laid off in each year
WITH Company_Year (company, years, total_laid_off) AS(
	SELECT company,YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_staging2
	GROUP BY company,YEAR(`date`)
	ORDER BY 3 DESC
),
Company_Year_Ranking AS(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
	FROM Company_Year
	WHERE years IS NOT NULL
-- ORDER BY Ranking
)

SELECT *
FROM Company_Year_Ranking
WHERE Ranking <= 5;
;