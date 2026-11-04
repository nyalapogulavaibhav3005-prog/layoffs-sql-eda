-- =====================================================
-- Layoffs Dataset: Exploratory Data Analysis (MySQL)
-- Run after 01_data_cleaning.sql (uses the cleaned table layoffs_dup2)
-- =====================================================

-- 1. Overview: biggest single layoff and highest percentage
SELECT MAX(total_laid_off) AS max_laid_off,
       MAX(percentage_laid_off) AS max_percentage
FROM layoffs_dup2;

-- 2. Companies that laid off 100% of staff (shut down), biggest funding first
SELECT *
FROM layoffs_dup2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 3. Top 10 companies by total layoffs
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_dup2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- 4. Layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_dup2
GROUP BY industry
ORDER BY 2 DESC;

-- 5. Layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_dup2
GROUP BY country
ORDER BY 2 DESC;

-- 6. Layoffs by year
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_dup2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- 7. Layoffs by funding stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_dup2
GROUP BY stage
ORDER BY 2 DESC;

-- 8. Rolling total of layoffs by month (CTE + window function)
WITH Rolling_Total AS (
    SELECT DATE_FORMAT(`date`, '%Y-%m') AS `month`,
           SUM(total_laid_off) AS total_off
    FROM layoffs_dup2
    WHERE `date` IS NOT NULL
    GROUP BY `month`
)
SELECT `month`,
       total_off,
       SUM(total_off) OVER (ORDER BY `month`) AS rolling_total
FROM Rolling_Total
ORDER BY `month`;

-- 9. Top 5 companies by layoffs each year (CTEs + DENSE_RANK)
WITH Company_Year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_dup2
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;

-- 10. Top 3 industries by layoffs each year (CTEs + DENSE_RANK)
WITH Industry_Year (industry, years, total_laid_off) AS (
    SELECT industry, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_dup2
    GROUP BY industry, YEAR(`date`)
),
Industry_Year_Rank AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM Industry_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Industry_Year_Rank
WHERE ranking <= 3;
