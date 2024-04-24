USE [PortfolioProject]
GO

-- Drop the table if it already exists
IF OBJECT_ID('PortfolioProject.dbo.lisbon_calendar_cleansed', 'U') IS NOT NULL
	DROP TABLE PortfolioProject.dbo.lisbon_calendar_cleansed;

------------------------------------------------------------------------------------------------------------
-- Create Table_cleansed to store the data that will be cleaned
SELECT CONVERT(BIGINT, listing_id) AS listing_id,
	CONVERT(DATE, date) AS date_cleansed,
	available,
	price,
	adjusted_price,
	CONVERT(INT,minimum_nights) AS minimum_nights,
	CONVERT(INT,maximum_nights) AS maximum_nights
INTO lisbon_calendar_cleansed
FROM [dbo].[raw_lisbon_calendar];

------------------------------------------------------------------------------------------------------------
-- updated available to "Yes" and "No"
UPDATE PortfolioProject.dbo.lisbon_calendar_cleansed
SET available = CASE WHEN available = 't' THEN 'Yes' WHEN available = 'f' THEN 'No' ELSE available END;

------------------------------------------------------------------------------------------------------------
-- update the price
UPDATE PortfolioProject.dbo.lisbon_calendar_cleansed
SET price = nullif(convert(FLOAT, replace(REPLACE(price, '$', ''), ',', '')), '')

------------------------------------------------------------------------------------------------------------
-- update the adjusted_price
UPDATE PortfolioProject.dbo.lisbon_calendar_cleansed
SET adjusted_price = nullif(convert(FLOAT, replace(REPLACE(adjusted_price, '$', ''), ',', '')), '');

------------------------------------------------------------------------------------------------------------
--  Null if to all columns
UPDATE PortfolioProject.dbo.lisbon_calendar_cleansed
SET available = NULLIF(available, ''),
	minimum_nights = NULLIF(minimum_nights, ''),
	maximum_nights = NULLIF(maximum_nights, '');

------------------------------------------------------------------------------------------------------------
-- updated data types columns
ALTER TABLE PortfolioProject.dbo.lisbon_calendar_cleansed

ALTER COLUMN price FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_calendar_cleansed

ALTER COLUMN adjusted_price FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_calendar_cleansed

ALTER COLUMN available NVARCHAR(3);

------------------------------------------------------------------------------------------------------------
SELECT listing_id,
	date_cleansed,
	available,
	price,
	adjusted_price,
	minimum_nights,
	maximum_nights
FROM PortfolioProject.dbo.lisbon_calendar_cleansed