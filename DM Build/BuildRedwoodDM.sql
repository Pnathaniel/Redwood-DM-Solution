-- Originally Written: January 2018|
-- Name: Stephanie, Nathan & Amanda
-- Peer Learning Group Redwood  
-----------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'RedwoodDM')
	CREATE DATABASE RedwoodDM
GO
USE RedwoodDM
--
-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables2
	WHERE name = N'FactSales'
       )
	DROP TABLE FactSales;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimCustomer'
       )
	DROP TABLE DimCustomer;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProperty'
       )
	DROP TABLE DimProperty;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimAgent'
       )
	DROP TABLE DimAgent;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimOffer'
       )
	DROP TABLE DimOffer;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;
--
-- Create tables
--

CREATE TABLE DimCustomer
	(Customer_SK	INT				NOT NULL IDENTITY (1001,1) PRIMARY KEY,
	Customer_AK		INT				NOT NULL,
	State			NVARCHAR(2)		NOT NULL,
	City			NVARCHAR(30)	NOT NULL,
	Zip_Code		NVARCHAR(20)	NOT NULL,
	Contact_Reason	NVARCHAR(200)	NOT NULL
);
--
CREATE TABLE DimAgent
	(Agent_SK		INT				NOT NULL IDENTITY (2001,1) PRIMARY KEY,
	Agent_AK		INT				NOT NULL,
	Title			NVARCHAR(20)	NOT NULL,
	Gender			NVARCHAR(1)		NOT NULL,
	Hire_Date		DATE			NOT NULL,
	Commission_Rate	INT				NOT NULL
);
--
CREATE TABLE DimOffer
	(Offer_SK		INT				NOT NULL IDENTITY (3001,1) PRIMARY KEY,
	Offer_AK		INT				NOT NULL,
	Initial_Offer	NVARCHAR(2)		NOT NULL,
	Counter_Offer	NVARCHAR(30)	NOT NULL,
);
--
CREATE TABLE DimProperty
	(Property_SK	INT				NOT NULL	IDENTITY (4001,1)	PRIMARY KEY,
	Property_AK		INT				NOT NULL,
	State			NVARCHAR(20)	NOT NULL,
	City			NVARCHAR(30)	NOT NULL,
	Zone			NVARCHAR(4)		NOT NULL,
	Zip_Code		NVARCHAR(20)	NOT NULL,
	Num_Beds		INT				NOT NULL,
	Num_Baths		DECIMAL(3,1)	NOT NULL, 
	Sq_Ft			INT				NOT NULL,
	Year_Built		INT				NOT NULL,
	Lot_Size		INT				NOT NULL,
	Num_Stories		INT				NOT NULL
	);
--
CREATE TABLE DimDate
	(Date_SK	DATE			NOT NULL	PRIMARY KEY,
	Date		DATE			NOT NULL,
	Year		INT				NOT NULL,
	Season		NVARCHAR(10)	NOT NULL,
	Month		NVARCHAR(10)	NOT NULL,
	Week		INT				NOT NULL,
	Day_Of_Week NVARCHAR(10)	NOT NULL,
	Holiday		NVARCHAR(10)	NOT NULL
	);
--
CREATE TABLE FactSales
	(Listing_Date	DATE		CONSTRAINT	fk_FactSales_DimDate	FOREIGN KEY REFERENCES	DimDate(Date_SK)	NOT NULL,
	Customer_SK		INT			CONSTRAINT	fk_FactSales_DimCustomer FOREIGN KEY REFERENCES	DimCustomer(Customer_SK) NOT NULL,
	Property_SK		INT			CONSTRAINT	fk_Proper_DimProperty	FOREIGN KEY REFERENCES	DimProperty(Property_SK) NOT NULL,
	Agent_SK		INT			CONSTRAINT	fk_Agent_DimAgent		FOREIGN KEY REFERENCES	DimAgent(Agent_SK) NOT NULL,
	Offer_SK		INT			CONSTRAINT	fk_FactSales_DimOffer	FOREIGN KEY REFERENCES	DimOffer(Offer_SK) NOT NULL,
	Asking_Price	MONEY		NOT NULL,
	Bid_Price		MONEY		NOT NULL,
	Days_on_Market	INT			IDENTITY (1,1) NOT NULL,
	Commission		MONEY		NOT NULL,
	CONSTRAINT pk_FactSales PRIMARY KEY (Listing_Date, Customer_SK, Property_SK, Agent_SK, Offer_SK)
	);
--
