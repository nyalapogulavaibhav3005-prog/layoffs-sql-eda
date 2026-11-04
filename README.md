# Layoffs Dataset: SQL Data Cleaning & Exploratory Data Analysis

An end-to-end SQL project in MySQL: cleaning a raw layoffs dataset, then exploring it to find trends by company, industry, funding stage, and year.

## Questions Answered
- Which companies and industries laid off the most people?
- How did layoffs change year over year?
- What is the rolling total of layoffs over time?
- Which companies and industries rank highest each year?
- Do later-stage or earlier-stage companies lay off more people?

## Dataset
- **Source:** _[add the source and link, e.g. Kaggle / layoffs.fyi]_
- **Size:** 2,361 raw rows → 2,356 after removing duplicates → 1,995 after removing rows with no layoff data
- **Period covered:** March 2020 to March 2023
- **Columns:** company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions

## Tools
MySQL, MySQL Workbench

## Project Structure
| File | Description |
|---|---|
| `01_data_cleaning.sql` | Cleans the raw data in a staging table |
| `02_exploratory_data_analysis.sql` | Exploratory analysis queries |

## Part 1: Data Cleaning
The raw `layoffs` table is never edited. All work is done on copies (`layoffs_dup`, `layoffs_dup2`).

1. **Removed duplicates** using `ROW_NUMBER() OVER (PARTITION BY ...)` across all columns, then deleted rows with `row_num > 1`.
2. **Standardized the data**
   - Trimmed whitespace in company names
   - Removed trailing `.` from country names (e.g. `United States.`)
   - Merged industry variants (`CryptoCurrency`, `Crypto Currency` → `crypto`)
   - Converted `date` from text to `DATE` using `STR_TO_DATE`
3. **Handled NULL and blank values**
   - Converted blanks to `NULL`
   - Filled missing industries by self-joining on company name
4. **Removed unusable data**
   - Deleted rows with no `total_laid_off` and no `percentage_laid_off`
   - Dropped the helper `row_num` column

## Part 2: Exploratory Data Analysis
**SQL concepts used:** aggregate functions, CTEs, window functions, `DENSE_RANK()`, rolling totals.

## Key Findings
Based on the cleaned data (1,995 rows):
- **Total layoffs recorded:** about 383,700 people.
- **Top companies:** Amazon (~18,150), Google (12,000), Meta (11,000), Salesforce (~10,090), and Microsoft (10,000).
- **Top industries:** Consumer (~45,200), Retail (~43,600), Other (~36,300), Transportation (~33,700), and Finance (~28,300).
- **By country:** the United States accounts for roughly two-thirds of all layoffs (~256,600), followed by India (~36,000) and the Netherlands (~17,200).
- **By year:** 2022 had the most layoffs (~160,700). 2023 reached ~125,700 in just the first two months and a few days of March.
- **By funding stage:** Post-IPO companies account for over half of all layoffs (~204,100).
- **Shutdowns:** 116 companies laid off 100% of their workforce.

## Screenshots
_Add 2 or 3 screenshots of your query results here._

## How to Run
1. Import the raw layoffs dataset into MySQL as a table named `layoffs`.
2. Run `01_data_cleaning.sql`.
3. Run `02_exploratory_data_analysis.sql`.

## Author
**Nyalapogula Sai Vaibhav** · [LinkedIn](https://www.linkedin.com/in/saivaibhav2067)
