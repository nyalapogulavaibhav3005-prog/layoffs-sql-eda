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
Based on the cleaned data:
- **Top companies by total layoffs:** Amazon (18,150), Google (12,000), Meta (11,000), Salesforce (10,090), with Philips and Microsoft tied at 10,000.
- **By year:** 2022 had the most layoffs (159,611), followed by 2023 (124,077), 2020 (80,928), and 2021 (15,823). The 2023 total covers only about the first two months of the year, since the data ends in March 2023.
- **Biggest spikes:** monthly layoffs jumped to 53,151 in November 2022 and 84,714 in January 2023.
- **Rolling total:** layoffs in the dataset passed 380,000 by March 2023.
- **Industry trends:** Transportation, Travel, and Finance led in 2020, Retail led in 2022, and "Other" led in 2023.

## Screenshots

**Rolling total of layoffs by month** (CTE + window function)

<img width="488" height="481" alt="Screenshot 2026-11-04 182411" src="https://github.com/user-attachments/assets/6af69814-e090-4fd7-93ce-9e38ca15a077" />


**Top 3 industries by layoffs each year** (CTE + DENSE_RANK)

<img width="522" height="298" alt="Screenshot 2026-11-04 181833" src="https://github.com/user-attachments/assets/e9319a60-cf36-47ed-ab69-6d70184c3009" />


**Top 5 companies by layoffs each year** (CTE + DENSE_RANK)

<img width="497" height="202" alt="Screenshot 2026-11-04 182029" src="https://github.com/user-attachments/assets/38ecc311-9f54-434a-89f6-f5bec28fdc9c" />


**Top 10 companies by total layoffs**

<img width="327" height="245" alt="Screenshot 2026-11-04 182437" src="https://github.com/user-attachments/assets/dc431015-e229-40ef-bf08-4b2bba242a19" />


**Total layoffs by year**

<img width="202" height="134" alt="Screenshot 2026-11-04 182527" src="https://github.com/user-attachments/assets/5fd6b93d-987c-4397-bae5-9189a16873a0" />


## How to Run
1. Import the raw layoffs dataset into MySQL as a table named `layoffs`.
2. Run `01_data_cleaning.sql`.
3. Run `02_exploratory_data_analysis.sql`.

## Author
**Nyalapogula Sai Vaibhav** · [LinkedIn](https://www.linkedin.com/in/saivaibhav2067)
