USE [PortfolioProject]
GO

/****** Object:  Table [dbo].[listings_test]    Script Date: 19/03/2024 14:54:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[raw_lisbon_listings](
    [id] [nvarchar](max) NULL,
    [listing_url] [nvarchar](max) NULL,
    [scrape_id] [nvarchar](max) NULL,
    [last_scraped] [nvarchar](max) NULL,
    [source] [nvarchar](max) NULL,
    [name] [nvarchar](max) NULL,
    [description] [nvarchar](max) NULL,
    [neighborhood_overview] [nvarchar](max) NULL,
    [picture_url] [nvarchar](max) NULL,
    [host_id] [nvarchar](max) NULL,
    [host_url] [nvarchar](max) NULL,
    [host_name] [nvarchar](max) NULL,
    [host_since] [nvarchar](max) NULL,
    [host_location] [nvarchar](max) NULL,
    [host_about] [nvarchar](max) NULL,
    [host_response_time] [nvarchar](max) NULL,
    [host_response_rate] [nvarchar](max) NULL,
    [host_acceptance_rate] [nvarchar](max) NULL,
    [host_is_superhost] [nvarchar](max) NULL,
    [host_thumbnail_url] [nvarchar](max) NULL,
    [host_picture_url] [nvarchar](max) NULL,
    [host_neighbourhood] [nvarchar](max) NULL,
    [host_listings_count] [nvarchar](max) NULL,
    [host_total_listings_count] [nvarchar](max) NULL,
    [host_verifications] [nvarchar](max) NULL,
    [host_has_profile_pic] [nvarchar](max) NULL,
    [host_identity_verified] [nvarchar](max) NULL,
    [neighbourhood] [nvarchar](max) NULL,
    [neighbourhood_cleansed] [nvarchar](max) NULL,
    [neighbourhood_group_cleansed] [nvarchar](max) NULL,
    [latitude] [nvarchar](max) NULL,
    [longitude] [nvarchar](max) NULL,
    [property_type] [nvarchar](max) NULL,
    [room_type] [nvarchar](max) NULL,
    [accommodates] [nvarchar](max) NULL,
    [bathrooms] [nvarchar](max) NULL,
    [bathrooms_text] [nvarchar](max) NULL,
    [bedrooms] [nvarchar](max) NULL,
    [beds] [nvarchar](max) NULL,
    [amenities] [nvarchar](max) NULL,
    [price] [nvarchar](max) NULL,
    [minimum_nights] [nvarchar](max) NULL,
    [maximum_nights] [nvarchar](max) NULL,
    [minimum_minimum_nights] [nvarchar](max) NULL,
    [maximum_minimum_nights] [nvarchar](max) NULL,
    [minimum_maximum_nights] [nvarchar](max) NULL,
    [maximum_maximum_nights] [nvarchar](max) NULL,
    [minimum_nights_avg_ntm] [nvarchar](max) NULL,
    [maximum_nights_avg_ntm] [nvarchar](max) NULL,
    [calendar_updated] [nvarchar](max) NULL,
    [has_availability] [nvarchar](max) NULL,
    [availability_30] [nvarchar](max) NULL,
    [availability_60] [nvarchar](max) NULL,
    [availability_90] [nvarchar](max) NULL,
    [availability_365] [nvarchar](max) NULL,
    [calendar_last_scraped] [nvarchar](max) NULL,
    [number_of_reviews] [nvarchar](max) NULL,
    [number_of_reviews_ltm] [nvarchar](max) NULL,
    [number_of_reviews_l30d] [nvarchar](max) NULL,
    [first_review] [nvarchar](max) NULL,
    [last_review] [nvarchar](max) NULL,
    [review_scores_rating] [nvarchar](max) NULL,
    [review_scores_accuracy] [nvarchar](max) NULL,
    [review_scores_cleanliness] [nvarchar](max) NULL,
    [review_scores_checkin] [nvarchar](max) NULL,
    [review_scores_communication] [nvarchar](max) NULL,
    [review_scores_location] [nvarchar](max) NULL,
    [review_scores_value] [nvarchar](max) NULL,
    [license] [nvarchar](max) NULL,
    [instant_bookable] [nvarchar](max) NULL,
    [calculated_host_listings_count] [nvarchar](max) NULL,
    [calculated_host_listings_count_entire_homes] [nvarchar](max) NULL,
    [calculated_host_listings_count_private_rooms] [nvarchar](max) NULL,
    [calculated_host_listings_count_shared_rooms] [nvarchar](max) NULL,
    [reviews_per_month] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


USE [PortfolioProject]
GO

/****** Object:  Table [dbo].[lisbon_calendar]    Script Date: [Fecha del script] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[raw_lisbon_calendar](
    [listing_id] [nvarchar] (max) NULL,
    [date] [nvarchar] (max) NULL,
    [available] [nvarchar] (max) NULL,
    [price] [nvarchar] (max) NULL,
    [adjusted_price] [nvarchar] (max) NULL,
    [minimum_nights] [nvarchar] (max) NULL,
    [maximum_nights] [nvarchar] (max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


USE [PortfolioProject]
GO

/****** Object:  Table [dbo].[nombretabla]    Script Date: [Fecha del script] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[raw_lisbon_reviews](
    [listing_id] [nvarchar] (max) NULL,
    [id] [nvarchar] (max) NULL,
    [date] [nvarchar] (max) NULL,
    [reviewer_id] [nvarchar] (max) NULL,
    [reviewer_name] [nvarchar] (max) NULL,
    [comments] [nvarchar] (max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

