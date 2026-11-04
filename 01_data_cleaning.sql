-- =====================================================
-- Layoffs Dataset: Data Cleaning (MySQL)
-- Steps:
--   1. Remove duplicates
--   2. Standardize the data
--   3. Handle NULL / blank values
--   4. Remove unneeded rows and columns
-- The raw table is never modified; all work is done on a copy.
-- =====================================================

SELECT * FROM layoffs;

-- -----------------------------------------------------
-- 0. Staging tables (keep the raw data safe)
-- -----------------------------------------------------
CREATE TABLE layoffs_dup LIKE layoffs;

INSERT layoffs_dup
SELECT * FROM layoffs;

CREATE TABLE layoffs_dup2 LIKE layoffs;
ALTER TABLE layoffs_dup2 ADD row_num INT;

-- -----------------------------------------------------
-- 1. Remove duplicates
-- Rows that are identical across every column get row_num > 1.
-- -----------------------------------------------------
INSERT INTO layoffs_dup2 (`company`, `location`, `industry`, `total_laid_off`,
    `percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`, `row_num`)
SELECT company, location, industry, total_laid_off, percentage_laid_off,
       `date`, stage, country, funds_raised_millions,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off,
                        percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_dup;

-- Inspect the duplicates
SELECT * FROM layoffs_dup2 WHERE row_num > 1;

-- Delete them
DELETE FROM layoffs_dup2 WHERE row_num > 1;

-- -----------------------------------------------------
-- 2. Standardize the data
-- -----------------------------------------------------

-- 2a. Trim extra spaces in company names
SELECT DISTINCT company, TRIM(company) FROM layoffs_dup2 ORDER BY 1;

UPDATE layoffs_dup2
SET company = TRIM(company);

-- 2b. Country: remove trailing '.' (e.g. "United States.")
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) FROM layoffs_dup2 ORDER BY 1;

UPDATE layoffs_dup2
SET country = TRIM(TRAILING '.' FROM country);

-- 2c. Industry: merge Crypto variants
SELECT DISTINCT industry FROM layoffs_dup2 ORDER BY 1;
SELECT * FROM layoffs_dup2 WHERE industry LIKE 'crypto%';

UPDATE layoffs_dup2
SET industry = 'crypto'
WHERE industry IN ('CryptoCurrency', 'Crypto Currency');

-- 2d. Date: convert text to DATE type
UPDATE layoffs_dup2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_dup2
MODIFY COLUMN `date` DATE;

-- -----------------------------------------------------
-- 3. NULL and blank values
-- -----------------------------------------------------

-- 3a. Treat blank industries as NULL so they can be filled in
UPDATE layoffs_dup2
SET industry = NULL
WHERE industry = '';

-- 3b. Fill missing industry from other rows of the same company
UPDATE layoffs_dup2 t1
JOIN layoffs_dup2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- 3c. Convert blank layoff figures to NULL
UPDATE layoffs_dup2
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_dup2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

-- -----------------------------------------------------
-- 4. Remove unusable rows and helper columns
-- -----------------------------------------------------

-- Rows with neither total nor percentage laid off carry no useful information
DELETE FROM layoffs_dup2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_dup2
DROP COLUMN row_num;

-- Cleaned table
SELECT * FROM layoffs_dup2;
