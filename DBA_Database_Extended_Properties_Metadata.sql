

/*
----------------------------------------------------------------------------------
-- Script Name: Retrieve Database-Level Extended Properties for All Databases
-- Description: 
--     This script retrieves the extended properties (Description, Owner, 
--     Compliance, and Comment) from all user databases on the SQL Server instance.
--     It aggregates the extended properties for each database into a single 
--     result set with one row per database.
--
-- Details:
--     1. A temporary table (#DatabaseProperties) is created to store the results.
--     2. A cursor iterates over all user databases (excluding system databases).
--     3. For each database, dynamic SQL is used to switch context and query
--        the extended properties at the database level using the sys.extended_properties 
--        system catalog view.
--     4. Extended properties are returned in a single row for each database 
--        (with NULL for missing properties).
--     5. At the end of the script, results are selected from the temporary table.
--
-- Usage:
--     Execute this script in a known database context, such as 'master'. The script 
--     dynamically handles database context switching and will retrieve extended 
--     properties for all user databases on the server.
--
-- Requirements:
--     - SQL Server 2008 or higher
--     - Adequate permissions to access the databases and their extended properties
--
-- Notes:
--     - System databases (master, model, msdb, tempdb) are excluded from the result.
--     - Ensure you have the required permissions to view extended properties in 
--       each database.
--
-- Created by: Giancarlo Rhodes
-- Date: 10/07/2024
----------------------------------------------------------------------------------
*/

--- this show the recovery model for all databases on this server
SELECT 
    name AS DatabaseName, 
    recovery_model_desc AS RecoveryModel
FROM 
    sys.databases;


--Simple Recovery Model:
--The transaction log is automatically truncated after each checkpoint (i.e., when the system saves data to disk).
--This means the log doesn’t grow excessively, but you can't restore the database to a specific point in time.
--Transaction log backups are not supported.
--Full Recovery Model:
--The transaction log keeps all records of transactions until a log backup is taken.
--This allows for point-in-time recovery, meaning you can restore the database to any specific point before a failure.
--The log continues to grow until it is manually truncated by backing up the log, and failure to manage log backups can lead to disk space issues.

--- CHANGE THE MODEL FOR THE SERVER SO THAT EVERY DATABASE after this will be SIMPLE and have extended properties
-- USE [Model]

-- change the system model 
USE [Model]
GO

ALTER DATABASE  [Model]
SET RECOVERY SIMPLE;
GO


--- change recovery model for a specific database
USE [WDST]
GO

ALTER DATABASE [WDST]
SET RECOVERY SIMPLE;
GO


--- CHANGE THE MODEL FOR THE SERVER SO THAT EVERY DATABASE after this will be SIMPLE and have extended properties
USE [Model]
GO

-- Add the 'Description' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Description', 
    @value = N'';
GO

-- Add the 'Owner' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Owner', 
    @value = N'';
GO

-- Add the 'Compliance' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Compliance', 
    @value = N'';
GO

-- Add the 'Comment' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Comment', 
    @value = N'';
GO



--- specific database
--USE [GeotabAdapterOptimizerDb];
-- USE [Model]
USE [WDST]
GO

-- Add the 'Description' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Description', 
    @value = N'';
GO

-- Add the 'Owner' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Owner', 
    @value = N'';
GO

-- Add the 'Compliance' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Compliance', 
    @value = N'';
GO

-- Add the 'Comment' extended property
EXEC sys.sp_addextendedproperty 
    @name = N'Comment', 
    @value = N'';
GO






















--- UPDATING extended properties
USE [GeotabAdapterOptimizerDb];
GO


-- Add the 'Description' extended property
EXEC sys.sp_updateextendedproperty 
    @name = N'Description', 
    @value = N'MDC currently uses GeoTab software and devices to collect and manage data on their vehicle equipment. There is a desire to go beyond that and use the GeoTab API to store the data on premise for further reporting and data analytics';
GO

-- Add the 'Owner' extended property
EXEC sys.sp_updateextendedproperty 
    @name = N'Owner', 
    @value = N'chris.scheppers@mdc.mo.gov, giancarlo.rhodes@mdc.mo.gov, Conservation Business Services';
GO

EXEC sys.sp_updateextendedproperty 
	@name = N'Compliance',
     @value = N'Third party database, does not follow any MDC standard.';

	 
-- Add the 'Comment' extended property
EXEC sys.sp_updateextendedproperty 
    @name = N'Comment', 
    @value = N'​Available code base - GitHub - Geotab/mygeotab-api-adapter';
GO




USE [MdcStandard];
GO

SELECT 
    ep.name AS PropertyName, 
    ep.value AS PropertyValue
FROM sys.extended_properties ep
WHERE ep.class = 0 -- 0 means it's a database-level property
AND ep.name IN ('Description', 'Owner', 'Compliance', 'Comment');


USE MdcStandard;
GO

SELECT 
    DB_NAME() AS DatabaseName,
    MAX(CASE WHEN ep.name = 'Description' THEN ep.value END) AS Description,
    MAX(CASE WHEN ep.name = 'Owner' THEN ep.value END) AS Owner,
    MAX(CASE WHEN ep.name = 'Compliance' THEN ep.value END) AS Compliance,
    MAX(CASE WHEN ep.name = 'Comment' THEN ep.value END) AS Comment
FROM sys.extended_properties ep
WHERE ep.class = 0 -- 0 means it's a database-level property
AND ep.name IN ('Description', 'Owner', 'Compliance', 'Comment');





-- Switch to the master database
USE master;
GO

-- Create a temporary table to store results
IF OBJECT_ID('tempdb..#DatabaseProperties') IS NOT NULL
    DROP TABLE #DatabaseProperties;

CREATE TABLE #DatabaseProperties (
    DatabaseName NVARCHAR(128),
    Description NVARCHAR(MAX),
    Owner NVARCHAR(MAX),
    Compliance NVARCHAR(MAX),
    Comment NVARCHAR(MAX)
);

-- Declare a cursor to loop through all user databases
DECLARE @DatabaseName NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);

-- Declare a cursor to loop through all databases
DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM sys.databases
WHERE database_id > 4; -- Exclude system databases

-- Open the cursor
OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DatabaseName;

-- Loop through all databases
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build the dynamic SQL to retrieve extended properties for each database
    SET @sql = '
    USE [' + @DatabaseName + '];
    INSERT INTO #DatabaseProperties (DatabaseName, Description, Owner, Compliance, Comment)
    SELECT 
        DB_NAME() AS DatabaseName,
        MAX(CASE WHEN ep.name = ''Description'' THEN CAST(ep.value AS NVARCHAR(MAX)) END) AS Description,
        MAX(CASE WHEN ep.name = ''Owner'' THEN CAST(ep.value AS NVARCHAR(MAX)) END) AS Owner,
        MAX(CASE WHEN ep.name = ''Compliance'' THEN CAST(ep.value AS NVARCHAR(MAX)) END) AS Compliance,
        MAX(CASE WHEN ep.name = ''Comment'' THEN CAST(ep.value AS NVARCHAR(MAX)) END) AS Comment
    FROM sys.extended_properties ep
    WHERE ep.class = 0 
    AND ep.name IN (''Description'', ''Owner'', ''Compliance'', ''Comment'');';

    -- Execute the dynamic SQL for the current database
    EXEC sp_executesql @sql;

    -- Fetch the next database
    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END;

-- Close and deallocate the cursor
CLOSE db_cursor;
DEALLOCATE db_cursor;

-- Select the results from the temporary table
SELECT * FROM #DatabaseProperties;

-- Clean up the temporary table
DROP TABLE #DatabaseProperties;
GO



--- add extended properties to all databases




			