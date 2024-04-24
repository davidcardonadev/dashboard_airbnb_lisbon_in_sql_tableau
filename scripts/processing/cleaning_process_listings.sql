USE [PortfolioProject]
GO

-- Drop the table if it already exists
IF OBJECT_ID('PortfolioProject.dbo.lisbon_listings_cleansed', 'U') IS NOT NULL
	DROP TABLE PortfolioProject.dbo.lisbon_listings_cleansed;

------------------------------------------------------------------------------------------------------------
-- Create Table_cleansed to store the data that will be cleaned
SELECT listing_url,
	name,
	host_id,
	host_since,
	host_location,
	host_response_rate,
	host_acceptance_rate,
	host_is_superhost,
	neighbourhood_cleansed,
	neighbourhood_group_cleansed,
	latitude,
	longitude,
	property_type,
	room_type,
	accommodates,
	bathrooms_text,
	bedrooms,
	beds,
	price,
	minimum_nights,
	maximum_nights,
	number_of_reviews,
	number_of_reviews_ltm,
	last_review,
	review_scores_rating,
	review_scores_location,
	instant_bookable
INTO lisbon_listings_cleansed
FROM [dbo].[raw_lisbon_listings];

------------------------------------------------------------------------------------------------------------
-- Add cleansed columns to the table
ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD name_cleansed NVARCHAR(250);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD listing_id BIGINT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD host_id_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD host_since_cleansed DATE;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD host_location_country_cleansed NVARCHAR(100);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD host_response_rate_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD host_acceptance_rate_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD zipcode_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD longitude_cleansed FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD latitude_cleansed FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD accommodates_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD bathrooms_cleansed FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD bathrooms_type_cleansed NVARCHAR(100);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD minimum_nights_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD maximum_nights_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD number_of_reviews_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD number_of_reviews_12m_cleansed INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD review_scores_rating_cleansed FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD review_scores_location_cleansed FLOAT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD last_review_cleansed DATE;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed ADD price_cleansed FLOAT;

------------------------------------------------------------------------------------------------------------
-- take the right part of the string listing_url to get the correct listing_id
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET listing_id = convert(BIGINT, RIGHT(listing_url, CHARINDEX('/', reverse(listing_url)) - 1))

------------------------------------------------------------------------------------------------------------
--Clean name deleting the star character to avoid futures errors
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET name = REPLACE(REPLACE(REPLACE(name, '/', '-'), NCHAR(9733), ''), ' · ', '/');

------------------------------------------------------------------------------------------------------------
-- Update the name_cleansed  with the extracted values from the name column
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET name_cleansed = (
		SELECT MAX(CASE WHEN part_number = 1 THEN value END)
		FROM (
			SELECT value,
				ROW_NUMBER() OVER (
					ORDER BY (
							SELECT NULL
							)
					) AS part_number
			FROM STRING_SPLIT(PortfolioProject.dbo.lisbon_listings_cleansed.name, '/')
			) AS split_parts
		)

------------------------------------------------------------------------------------------------------------
-- Update the bedrooms with the extracted values from the name column
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET Bedrooms = (
		SELECT MAX(CASE WHEN part_number = 2
						AND ISNUMERIC(value) = 0
						AND value LIKE '%bedroom%' THEN SUBSTRING(value, 1, charindex(' ', value, 1)) WHEN part_number = 3
						AND ISNUMERIC(value) = 0
						AND value LIKE '%bedroom%' THEN SUBSTRING(value, 1, charindex(' ', value, 1)) END)
		FROM (
			SELECT value,
				ROW_NUMBER() OVER (
					ORDER BY (
							SELECT NULL
							)
					) AS part_number
			FROM STRING_SPLIT(PortfolioProject.dbo.lisbon_listings_cleansed.name, '/')
			) AS split_parts
		)

------------------------------------------------------------------------------------------------------------
-- Update the beds with the extracted values from the name column
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET Beds = (
		SELECT MAX(CASE WHEN part_number = 2
						AND ISNUMERIC(value) = 0
						AND (
							value LIKE '%bed'
							OR value LIKE '%beds'
							) THEN SUBSTRING(value, 1, charindex(' ', value, 1)) WHEN part_number = 3
						AND ISNUMERIC(value) = 0
						AND (
							value LIKE '%bed'
							OR value LIKE '%beds'
							) THEN SUBSTRING(value, 1, charindex(' ', value, 1)) WHEN part_number = 4
						AND ISNUMERIC(value) = 0
						AND (
							value LIKE '%bed'
							OR value LIKE '%beds'
							) THEN SUBSTRING(value, 1, charindex(' ', value, 1)) END)
		FROM (
			SELECT value,
				ROW_NUMBER() OVER (
					ORDER BY (
							SELECT NULL
							)
					) AS part_number
			FROM STRING_SPLIT(PortfolioProject.dbo.lisbon_listings_cleansed.name, '/')
			) AS split_parts
		)

------------------------------------------------------------------------------------------------------------
-- Update the bathrooms_text with the extracted values from the name column
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET bathrooms_text = (
		SELECT MAX(CASE WHEN part_number = 2
						AND ISNUMERIC(value) = 0
						AND value LIKE '%bath%' THEN value WHEN part_number = 3
						AND ISNUMERIC(value) = 0
						AND value LIKE '%bath%' THEN value WHEN part_number = 4
						AND ISNUMERIC(value) = 0
						AND value LIKE '%bath%' THEN value WHEN part_number = 5
						AND ISNUMERIC(value) = 0
						AND value LIKE '%bath%' THEN value END)
		FROM (
			SELECT value,
				ROW_NUMBER() OVER (
					ORDER BY (
							SELECT NULL
							)
					) AS part_number
			FROM STRING_SPLIT(PortfolioProject.dbo.lisbon_listings_cleansed.name, '/')
			) AS split_parts
		);

--clean bathrooms_text and creating bathrooms_cleansed and bathrooms_type_cleansed
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET bathrooms_cleansed = CASE WHEN bathrooms_text LIKE '%half_bath%' THEN 0.5 WHEN isnumeric(substring(bathrooms_text, 1, CHARINDEX(' ', bathrooms_text))) = 1 THEN convert(FLOAT, substring(bathrooms_text, 1, CHARINDEX(' ', bathrooms_text))) ELSE 0 END,
	bathrooms_type_cleansed = CASE WHEN substring(bathrooms_text, CHARINDEX(' ', bathrooms_text), len(bathrooms_text)) LIKE '%private%' THEN 'private' WHEN substring(bathrooms_text, CHARINDEX(' ', bathrooms_text), len(bathrooms_text)) LIKE '%shared%' THEN 'shared' ELSE 'baths' END

------------------------------------------------------------------------------------------------------------
-- clean host_id column
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET host_id_cleansed = convert(BIGINT, host_id)

------------------------------------------------------------------------------------------------------------
-- clean host_since to date format
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET host_since_cleansed = CONVERT(DATE, host_since, 103);

------------------------------------------------------------------------------------------------------------
-- Update the host_location just to get the country.
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET host_location_country_cleansed = RIGHT(nullif(host_location, ''), nullif(CHARINDEX(',', reverse(host_location)) - 1, - 1))

------------------------------------------------------------------------------------------------------------
-- clean host_response_rate
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET host_response_rate_cleansed = SUBSTRING(NULLIF(host_response_rate, 'N/A'), 1, len(NULLIF(host_response_rate, 'N/A')) - 1)

------------------------------------------------------------------------------------------------------------
-- clean host_acceptance_rate
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET host_acceptance_rate_cleansed = SUBSTRING(NULLIF(host_acceptance_rate, 'N/A'), 1, len(NULLIF(host_acceptance_rate, 'N/A')) - 1)

------------------------------------------------------------------------------------------------------------
-- update the host_is_superhost to "Yes" and "No"
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET host_is_superhost = CASE WHEN host_is_superhost = 't' THEN 'Yes' WHEN host_is_superhost = 'f' THEN 'No' ELSE host_is_superhost END;

------------------------------------------------------------------------------------------------------------
-- clean altitude and longitude
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET longitude_cleansed = convert(FLOAT, longitude),
	latitude_cleansed = convert(FLOAT, latitude)

------------------------------------------------------------------------------------------------------------
-- update the price
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET price_cleansed = convert(FLOAT, replace(REPLACE(price, '$', ''), ',', ''))

------------------------------------------------------------------------------------------------------------
-- update the last_review
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET last_review_cleansed = CONVERT(DATE, last_review, 103);

------------------------------------------------------------------------------------------------------------
--clean review_scores_rating to float
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET review_scores_rating_cleansed = CASE WHEN isnumeric(review_scores_rating) = 1 THEN convert(FLOAT, review_scores_rating) ELSE NULL END

------------------------------------------------------------------------------------------------------------
--clean review_scores_location to float
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET review_scores_location_cleansed = CASE WHEN isnumeric(review_scores_location) = 1 THEN convert(FLOAT, review_scores_location) ELSE NULL END

------------------------------------------------------------------------------------------------------------
-- update the instant_bookable to "Yes" and "No"
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET instant_bookable = CASE WHEN instant_bookable = 't' THEN 'Yes' WHEN instant_bookable = 'f' THEN 'No' ELSE instant_bookable END;

------------------------------------------------------------------------------------------------------------
-- update the zipcode

DROP TABLE IF EXISTS #temp_lisbon_listings_zipcode;


-- This query calculates the minimum distance between each listing in the lisbon_listings_cleansed table and all postal codes in the zipcode_portugal table, 
-- and then selects the postal code corresponding to the minimum distance for each listing.
-- The result is stored in a temporary table named #temp_lisbon_listings_zipcode.
-- Selecting the listing_id, longitude_cleansed, latitude_cleansed, and minimum postal code and distance 
-- for each unique combination of listing_id, longitude_cleansed, and latitude_cleansed
SELECT n.listing_id,
	n.longitude_cleansed,
	n.latitude_cleansed,
	-- Calculating the minimum postal code for each group
	MIN(zp.[postal code]) AS min_postal_code,
	-- Calculating the minimum distance for each group
	MIN(SQRT(POWER(n.latitude_cleansed - zp.latitude, 2) + POWER(n.longitude_cleansed - zp.longitude, 2))) AS min_distance
-- Storing the result in a temporary table named #temp_lisbon_listings_zipcode
INTO #temp_lisbon_listings_zipcode
FROM (
	-- Subquery to select unique combinations of listing_id, longitude_cleansed, and latitude_cleansed
	SELECT listing_id,
		longitude_cleansed,
		latitude_cleansed
	FROM lisbon_listings_cleansed
	GROUP BY listing_id,
		longitude_cleansed,
		latitude_cleansed
	) AS n
-- Joining with the zipcode_portugal table to calculate distances and filter based on the specified threshold
INNER JOIN (
	-- Subquery to select unique combinations of postal code, latitude, and longitude
	SELECT [postal code],
		latitude,
		longitude
	FROM PortfolioProject.dbo.zipcode_portugal
	GROUP BY [postal code],
		latitude,
		longitude
	) AS zp
	-- Applying a filter condition to select only those postal codes within the specified distance threshold
	ON SQRT(POWER(n.latitude_cleansed - zp.latitude, 2) + POWER(n.longitude_cleansed - zp.longitude, 2)) < 0.05
-- Grouping the result by listing_id, longitude_cleansed, and latitude_cleansed
GROUP BY listing_id,
	longitude_cleansed,
	latitude_cleansed;
---------------------------------------

-- This query updates the zipcode_cleansed column in the lisbon_listings_cleansed table 
-- with the minimum postal code obtained from the temporary table #temp_lisbon_listings_zipcode.
-- Updating the zipcode_cleansed column in lisbon_listings_cleansed with the minimum postal code
UPDATE a
SET a.zipcode_cleansed = b.min_postal_code
FROM PortfolioProject.dbo.lisbon_listings_cleansed AS a
-- Joining with the temporary table #temp_lisbon_listings_zipcode to get the minimum postal code
INNER JOIN #temp_lisbon_listings_zipcode AS b
	ON a.listing_id = b.listing_id;

------------------------------------------------------------------------------------------------------------
-- Drops all the columns that are already cleansed and we do not use becausae we created other column for that
ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

DROP COLUMN host_id,
	name,
	bathrooms_text,
	host_since,
	host_response_rate,
	host_acceptance_rate,
	longitude,
	latitude,
	host_location,
	accommodates,
	minimum_nights,
	maximum_nights,
	number_of_reviews,
	number_of_reviews_ltm,
	review_scores_rating,
	review_scores_location,
	last_review,
	price

------------------------------------------------------------------------------------------------------------
-- Update all columns with null if
UPDATE PortfolioProject.dbo.lisbon_listings_cleansed
SET listing_url = NULLIF(listing_url, ''),
	name_cleansed = NULLIF(name_cleansed, ''),
	host_is_superhost = NULLIF(host_is_superhost, ''),
	neighbourhood_cleansed = NULLIF(neighbourhood_cleansed, ''),
	neighbourhood_group_cleansed = NULLIF(neighbourhood_group_cleansed, ''),
	property_type = NULLIF(property_type, ''),
	room_type = NULLIF(room_type, ''),
	bathrooms_cleansed = NULLIF(bathrooms_cleansed, ''),
	bathrooms_type_cleansed = NULLIF(bathrooms_type_cleansed, ''),
	instant_bookable = NULLIF(instant_bookable, ''),
	listing_id = NULLIF(listing_id, ''),
	host_id_cleansed = NULLIF(host_id_cleansed, ''),
	host_since_cleansed = NULLIF(host_since_cleansed, ''),
	host_location_country_cleansed = NULLIF(host_location_country_cleansed, ''),
	host_response_rate_cleansed = NULLIF(host_response_rate_cleansed, ''),
	host_acceptance_rate_cleansed = NULLIF(host_acceptance_rate_cleansed, ''),
	longitude_cleansed = NULLIF(longitude_cleansed, ''),
	latitude_cleansed = NULLIF(latitude_cleansed, ''),
	accommodates_cleansed = NULLIF(accommodates_cleansed, ''),
	bedrooms = NULLIF(bedrooms, ''),
	beds = NULLIF(beds, ''),
	minimum_nights_cleansed = NULLIF(minimum_nights_cleansed, ''),
	maximum_nights_cleansed = NULLIF(maximum_nights_cleansed, ''),
	number_of_reviews_cleansed = NULLIF(number_of_reviews_cleansed, ''),
	number_of_reviews_12m_cleansed = NULLIF(number_of_reviews_12m_cleansed, ''),
	review_scores_rating_cleansed = NULLIF(review_scores_rating_cleansed, ''),
	review_scores_location_cleansed = NULLIF(review_scores_location_cleansed, ''),
	last_review_cleansed = NULLIF(last_review_cleansed, ''),
	price_cleansed = NULLIF(price_cleansed, '');

------------------------------------------------------------------------------------------------------------
-- change the type of the column.
ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN listing_url NVARCHAR(250);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN host_is_superhost NVARCHAR(3);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN beds INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN bedrooms INT;

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN neighbourhood_cleansed NVARCHAR(100);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN neighbourhood_group_cleansed NVARCHAR(100);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN property_type NVARCHAR(100);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN room_type NVARCHAR(100);

ALTER TABLE PortfolioProject.dbo.lisbon_listings_cleansed

ALTER COLUMN instant_bookable NVARCHAR(3);

------------------------------------------------------------------------------------------------------------
-- Showing the results
SELECT listing_id,
	listing_url,
	name_cleansed,
	property_type,
	price_cleansed,
	room_type,
	host_is_superhost,
	zipcode_cleansed,
	neighbourhood_cleansed,
	neighbourhood_group_cleansed,
	accommodates_cleansed,
	bedrooms,
	beds,
	bathrooms_cleansed,
	bathrooms_type_cleansed,
	instant_bookable,
	minimum_nights_cleansed,
	maximum_nights_cleansed,
	host_id_cleansed,
	host_since_cleansed,
	host_location_country_cleansed,
	host_response_rate_cleansed,
	host_acceptance_rate_cleansed,
	longitude_cleansed,
	latitude_cleansed,
	number_of_reviews_cleansed,
	number_of_reviews_12m_cleansed,
	last_review_cleansed,
	review_scores_rating_cleansed,
	review_scores_location_cleansed
FROM PortfolioProject.dbo.lisbon_listings_cleansed
