# YouTube-Analysis

## **1. Project Description**

**📌 Title:** Global YouTube Statistic Analysis

**🎯 Goal:**

- Analyzed YouTube channels to uncover key patterns and insights related to top channels, categories, types, and countries.

- Used PostgreSQL to clean and optimize data, handling missing values and adjusting data types for consistency.

- Developed an interactive Tableau dashboard with visual reports based on selected key metrics.

- Conducted statistical analysis, creating scatter plots for correlation and box plots for distribution patterns.

- Uncovered insights into YouTube content performance, supporting strategic decision-making and content optimization.

**📂 Data Source:** https://www.kaggle.com/datasets/nelgiriyewithana/global-youtube-statistics-2023/data

**🚀 Final Vizualization:** https://public.tableau.com/views/YouTubeAnalysis_17429151197160/Overview?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link


## **1. Data Manipulation using PostgreSQL**

### 1.1 Connecting to PostgreSQL

First, I created a table in PostgreSQL to store the YouTube channel data:

```sql
CREATE TABLE youtube (
    Rank INT,
    Youtuber TEXT,
    Subscribers INT,
    Video_views NUMERIC,
    Category TEXT,
    Title TEXT,
    Uploads INT,
    Country TEXT,
    Abbreviation TEXT,
    Channel_type TEXT,
    Video_views_rank NUMERIC,
    Country_rank TEXT,
    Channel_type_rank TEXT,
    Video_views_30d NUMERIC,
    Low_month_earn FLOAT,
    High_month_earn FLOAT,
    Low_year_earn FLOAT,
    High_year_earn FLOAT,
    Subscribers_30d TEXT,
    Created_year TEXT,
    Created_month TEXT,
    Created_date TEXT,
    Education FLOAT,
    Population TEXT,
    Unemployment_rate FLOAT,
    Urban_population FLOAT,
    Latitude NUMERIC(9,6),
    Longitude NUMERIC(9,6)
);
```

There was an issue with data encoding. The default encoding (UTF-8) didn't support some characters, so I switched to the WIN1252 encoding (ask how to do it in ChatGPT).

### 1.2 Data Cleaning and Preparation

To ensure that no original data is lost during cleaning, I created a backup table:

```sql
CREATE TABLE youtube_original AS TABLE youtube;
```

Then, I dropped the columns that were not necessary for my analysis:

```sql
ALTER TABLE youtube
DROP COLUMN country_rank,
DROP COLUMN channel_type_rank,
DROP COLUMN education,
DROP COLUMN population,
DROP COLUMN unemployment_rate,
DROP COLUMN urban_population,
DROP COLUMN latitude,
DROP COLUMN longitude,
DROP COLUMN video_views_30d,
DROP COLUMN subscribers_30d,
DROP COLUMN low_month_earn,
DROP COLUMN high_month_earn;
```

I added a new column to calculate the average yearly earnings for each channel. After calculating, I removed the original earnings columns:

```sql
ALTER TABLE youtube
ADD COLUMN avg_year_earn FLOAT;

UPDATE youtube
SET avg_year_earn = (low_year_earn + high_year_earn) / 2;

ALTER TABLE youtube
DROP COLUMN low_year_earn,
DROP COLUMN high_year_earn;
```

The dataset had incorrect values (such as `nan` and `1970`) in the `created_year` column. I removed the rows with these values:

```sql
DELETE FROM youtube
WHERE created_year IN ('nan', '1970');
```

Then, I combined the `created_year`, `created_month`, and `created_date` columns into a single `created_date` column:

```sql
ALTER TABLE youtube
ADD COLUMN created_full_date DATE;

UPDATE youtube
SET created_full_date = TO_DATE(created_year || '-' || created_month || '-' || created_date, 'YYYY-Mon-DD');

ALTER TABLE youtube
DROP COLUMN created_year,
DROP COLUMN created_month,
DROP COLUMN created_date;

ALTER TABLE youtube
RENAME COLUMN created_full_date TO created_date;
```

I replaced any `nan` values in the `category`, `country`, and `channel_type` columns with the string `Unknown`:

```sql
UPDATE youtube
SET category = CASE WHEN category = 'nan' THEN 'Unknown' ELSE category END,
    country = CASE WHEN country = 'nan' THEN 'Unknown' ELSE country END,
    channel_type = CASE WHEN channel_type = 'nan' THEN 'Unknown' ELSE channel_type END;
```

## 2. Analysis and Visualization in Tableau

### 1. Setting Up Dynamic Visualizations

To allow for dynamic visualizations in Tableau, I created a parameter to choose the metric (such as Subscribers, Views, Uploads, or Earnings) and then used it to create a calculated field:

```sql
CASE [Selected Metric] 
    WHEN 'Subscribers' THEN SUM([subscribers])
    WHEN 'Views' THEN SUM([video_views])
    WHEN 'Uploads' THEN SUM([uploads])
    WHEN 'Earnings' THEN SUM([avg_year_earn])
END
```

### 2. Scale Label

I created a calculated field to adjust the scale labels for better readability (e.g., converting millions to 'M' or billions to 'B'):

```sql
CASE [Selected Metric] 
    WHEN 'Subscribers' THEN STR(ROUND(([Total Parameter] / 1000000000), 2)) + 'B'
    WHEN 'Views' THEN STR(ROUND(([Total Parameter] / 1000000000), 2)) + 'B'
    WHEN 'Uploads' THEN STR(ROUND(([Total Parameter] / 1000), 2)) + 'K'
    WHEN 'Earnings' THEN STR(ROUND(([Total Parameter] / 1000000), 2)) + 'M'
END
```

## **Key Takeaways from the Project 🚀:**
- Cleaned and optimized YouTube data using PostgreSQL, handling missing values and adjusting data types for consistency.

- Transformed raw data by removing unnecessary columns and calculating new metrics, such as average yearly earnings.

- Developed an interactive Tableau dashboard to visualize key metrics like subscribers, views, uploads, and earnings, with dynamic features.

- Conducted statistical analysis, including scatter plots for correlation and box plots for distribution patterns, uncovering valuable insights.

- Gained insights into YouTube channel performance, providing support for content optimization and strategic decision-making.
- 
This project showcases my ability to clean, transform, and analyze data using Python, PostgreSQL, and Tableau, enabling data-informed insights and decision-making.
