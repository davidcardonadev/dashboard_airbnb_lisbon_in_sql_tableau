USE [PortfolioProject]
GO

-- Drop the table if it already exists
IF OBJECT_ID('PortfolioProject.dbo.lisbon_reviews_cleansed', 'U') IS NOT NULL
	DROP TABLE PortfolioProject.dbo.lisbon_reviews_cleansed;

------------------------------------------------------------------------------------------------------------
-- Create Table_cleansed to store the data that will be cleaned
SELECT CONVERT(BIGINT, listing_id) AS listing_id,
	CONVERT(BIGINT, id) AS id,
	CONVERT(DATE, DATE) AS date_cleansed,
	CONVERT(BIGINT, reviewer_id) AS reviewer_id,
	reviewer_name,
	comments
INTO lisbon_reviews_cleansed
FROM [dbo].[raw_lisbon_reviews];

SELECT *
FROM PortfolioProject.dbo.lisbon_reviews_cleansed