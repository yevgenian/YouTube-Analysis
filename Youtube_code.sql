-- Creating the 'youtube' table with the necessary columns
CREATE TABLE youtube (
    Rank INT, -- Rank of the Youtuber
    Youtuber TEXT, -- Name of the Youtuber
    Subscribers INT, -- Number of Subscribers
    Video_views NUMERIC, -- Number of video views
    Category TEXT, -- Video category
    Title TEXT, -- Video title
    Uploads INT, -- Number of video uploads
    Country TEXT, -- Country of the Youtuber
    Abbreviation TEXT, -- Country abbreviation
    Channel_type TEXT, -- Type of channel
    Video_views_rank NUMERIC, -- Rank based on video views
    Country_rank TEXT, -- Rank by country
    Channel_type_rank TEXT, -- Rank by channel type
    Video_views_30d NUMERIC, -- Video views in the last 30 days
    Low_month_earn FLOAT, -- Estimated low monthly earnings
    High_month_earn FLOAT, -- Estimated high monthly earnings
    Low_year_earn FLOAT, -- Estimated low yearly earnings
    High_year_earn FLOAT, -- Estimated high yearly earnings
    Subscribers_30d TEXT, -- Subscribers gained in the last 30 days
    Created_year TEXT, -- Year the channel was created
    Created_month TEXT, -- Month the channel was created
    Created_date TEXT, -- Date the channel was created
    Education FLOAT, -- Education level of the Youtuber
    Population TEXT, -- Population of the country
    Unemployment_rate FLOAT, -- Unemployment rate in the country
    Urban_population FLOAT, -- Urban population in the country
    Latitude NUMERIC (9,6), -- Latitude coordinate
    Longitude NUMERIC (9,6) -- Longitude coordinate
)
  
-- Duplicating the original table to preserve raw data
CREATE TABLE youtube_original
AS TABLE youtube

-- Altering the 'youtube' table to remove unnecessary columns for analysis
ALTER TABLE youtube
DROP COLUMN country_rank,
DROP COLUMN channel_type_rank,
DROP COLUMN education,
DROP COLUMN population,
DROP COLUMN unemployment_rate,
DROP COLUMN urban_population,
DROP COLUMN latitude,
DROP COLUMN longitude

ALTER TABLE youtube
DROP COLUMN video_views_30d,
DROP COLUMN subscribers_30d,
DROP COLUMN low_month_earn,
DROP COLUMN high_month_earn
  
-- Adding a new column for average yearly earnings
ALTER TABLE youtube
ADD COLUMN avg_year_earn FLOAT

-- Calculating average yearly earnings and updating the new column
UPDATE youtube
SET avg_year_earn = (low_year_earn + high_year_earn)/2

-- Dropping the old earnings columns as they are no longer needed
ALTER TABLE youtube
DROP COLUMN low_year_earn,
DROP COLUMN high_year_earn

-- Checking for invalid or missing values in the 'created_year' column
SELECT DISTINCT(created_year)
FROM youtube;

-- Deleting rows with invalid year data (nan and 1970) that are not useful for analysis
DELETE FROM youtube
WHERE created_year IN ('nan', '1970');

-- Merging 'created_year', 'created_month', and 'created_date' into a single date column
ALTER TABLE youtube
ADD COLUMN created_full_date DATE;

UPDATE youtube
SET created_full_date = TO_DATE(created_year || '-' || created_month || '-' || created_date, 'YYYY-Mon-DD');

-- Dropping the individual year, month, and date columns after merging
ALTER TABLE youtube
DROP COLUMN created_year,
DROP COLUMN created_month,
DROP COLUMN created_date;

-- Renaming the 'created_full_date' column to 'created_date' for clarity
ALTER TABLE youtube
RENAME COLUMN created_full_date to created_date

-- Removing unnecessary columns: 'title' and 'abbreviation'
ALTER TABLE youtube
DROP COLUMN title,
DROP COLUMN abbreviation;

-- Replacing 'nan' values with 'Unknown' in the 'category', 'country', and 'channel_type' columns
UPDATE youtube
SET category = CASE WHEN category = 'nan' THEN 'Unknown' ELSE category END,
    country = CASE WHEN country = 'nan' THEN 'Unknown' ELSE country END,
    channel_type = CASE WHEN channel_type = 'nan' THEN 'Unknown' ELSE channel_type END;
