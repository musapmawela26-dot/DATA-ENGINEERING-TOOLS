/*============================================================
  CREATE DATABASE
============================================================*/
IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'property24'
)
BEGIN
    CREATE DATABASE property24;
END;
GO

USE property24;
GO

/*============================================================
  CREATE TABLE (COMMENTED AS REQUESTED)
============================================================*/
-- IF NOT EXISTS (
--     SELECT 1
--     FROM sys.tables
--     WHERE name = 'property_details'
--       AND schema_id = SCHEMA_ID('dbo')
-- )
-- BEGIN
--     CREATE TABLE dbo.property_details (
--         PROPERTY_ID int IDENTITY(1,1) PRIMARY KEY,
--         COUNTRY varchar(100),
--         PROVINCE varchar(100),
--         CITY varchar(100),
--         PROPERTY_PRICE int,
--         BEDROOMS int,
--         BATHROOMS int,
--         PARKING int,
--         FLOOR_SIZE int,
--         Monthly_Repayment int,
--         Total_Once_off_Costs int,
--         Min_Gross_Monthly_Income int
--     );
-- END;
GO

/*============================================================
  GENERATE EXACTLY 100,000 PROPERTY RECORDS
============================================================*/
WITH Numbers AS (
    SELECT TOP (100000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO dbo.property_details (
    COUNTRY,
    PROVINCE,
    CITY,
    PROPERTY_PRICE,
    BEDROOMS,
    BATHROOMS,
    PARKING,
    FLOOR_SIZE,
    Monthly_Repayment,
    Total_Once_off_Costs,
    Min_Gross_Monthly_Income
)
SELECT
    'South Africa' AS COUNTRY,

    /*==========================
      PROVINCE (ALL 9)
    ==========================*/
    CASE n % 9
        WHEN 0 THEN 'Gauteng'
        WHEN 1 THEN 'Western Cape'
        WHEN 2 THEN 'KwaZulu-Natal'
        WHEN 3 THEN 'Eastern Cape'
        WHEN 4 THEN 'Free State'
        WHEN 5 THEN 'Mpumalanga'
        WHEN 6 THEN 'Limpopo'
        WHEN 7 THEN 'North West'
        ELSE 'Northern Cape'
    END AS PROVINCE,

    /*==========================
      CITY PER PROVINCE
    ==========================*/
    CASE n % 9
        WHEN 0 THEN
            CASE n % 5
                WHEN 0 THEN 'Sandton'
                WHEN 1 THEN 'Midrand'
                WHEN 2 THEN 'Centurion'
                WHEN 3 THEN 'Fourways'
                ELSE 'Alberton'
            END
        WHEN 1 THEN
            CASE n % 5
                WHEN 0 THEN 'Cape Town'
                WHEN 1 THEN 'Sea Point'
                WHEN 2 THEN 'Claremont'
                WHEN 3 THEN 'Bellville'
                ELSE 'Stellenbosch'
            END
        WHEN 2 THEN
            CASE n % 4
                WHEN 0 THEN 'Umhlanga'
                WHEN 1 THEN 'Durban North'
                WHEN 2 THEN 'Ballito'
                ELSE 'Hillcrest'
            END
        WHEN 3 THEN
            CASE n % 3
                WHEN 0 THEN 'Gqeberha'
                WHEN 1 THEN 'East London'
                ELSE 'Jeffreys Bay'
            END
        WHEN 4 THEN
            CASE n % 2
                WHEN 0 THEN 'Bloemfontein'
                ELSE 'Welkom'
            END
        WHEN 5 THEN
            CASE n % 2
                WHEN 0 THEN 'Nelspruit'
                ELSE 'White River'
            END
        WHEN 6 THEN
            CASE n % 2
                WHEN 0 THEN 'Polokwane'
                ELSE 'Tzaneen'
            END
        WHEN 7 THEN
            CASE n % 2
                WHEN 0 THEN 'Rustenburg'
                ELSE 'Hartbeespoort'
            END
        ELSE
            CASE n % 2
                WHEN 0 THEN 'Kimberley'
                ELSE 'Upington'
            END
    END AS CITY,

    /*==========================
      PROPERTY PRICE (RANDS)
    ==========================*/
    ABS(CHECKSUM(NEWID())) %
    CASE n % 9
        WHEN 0 THEN 4500000
        WHEN 1 THEN 6500000
        WHEN 2 THEN 3800000
        WHEN 3 THEN 2600000
        WHEN 4 THEN 1900000
        WHEN 5 THEN 2300000
        WHEN 6 THEN 2100000
        WHEN 7 THEN 2800000
        ELSE 1800000
    END + 850000 AS PROPERTY_PRICE,

    /*==========================
      PROPERTY FEATURES
    ==========================*/
    ABS(CHECKSUM(NEWID())) % 4 + 1 AS BEDROOMS,
    ABS(CHECKSUM(NEWID())) % 3 + 1 AS BATHROOMS,
    ABS(CHECKSUM(NEWID())) % 3 + 1 AS PARKING,
    ABS(CHECKSUM(NEWID())) % 180 + 60 AS FLOOR_SIZE,

    /*==========================
      FINANCIALS
    ==========================*/
    ABS(CHECKSUM(NEWID())) % 45000 + 8000  AS Monthly_Repayment,
    ABS(CHECKSUM(NEWID())) % 300000 + 50000 AS Total_Once_off_Costs,
    ABS(CHECKSUM(NEWID())) % 160000 + 30000 AS Min_Gross_Monthly_Income
FROM Numbers;
GO
