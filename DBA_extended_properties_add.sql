

-- SQL141 (DONE)
-- SQL142  (DONE)
-- SQL14DR (DONE)
-- MDCBiData (DONE)
-- RSDB01\DEV (DONE)
-- RSDB01\TEST (DONE)
-- MDCRetro (DONE) 
-- ReportSRV01 (DONE)
-- TESTReportSRV01 (DONE)
-- CBCDB01\TEST (DONE) 
-- CBCDB01\PROD (DONE)




--TESTAppDB01\DEV  (DONE) 
--TESTAppDB01\TEST (DONE)
--AppDB01 (DONE)
--SDEDEV2 (SKIPPED)
--SDETEST2 (SKIPPED)
--SDE2  (SKIPPED)
--HRISDSQL (DONE)
--TESTHRISDSQL  (DONE)
--TESTSQL141 (DONE)
--TESTSQL142 (DONE)
--TESTSQL14DR (DONE)



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
    sys.databases
WHERE 
    name NOT IN ('master', 'msdb', 'tempdb');





----Simple Recovery Model:
----The transaction log is automatically truncated after each checkpoint (i.e., when the system saves data to disk).
----This means the log doesn’t grow excessively, but you can't restore the database to a specific point in time.
----Transaction log backups are not supported.
----Full Recovery Model:
----The transaction log keeps all records of transactions until a log backup is taken.
----This allows for point-in-time recovery, meaning you can restore the database to any specific point before a failure.
----The log continues to grow until it is manually truncated by backing up the log, and failure to manage log backups can lead to disk space issues.



----- CHANGE THE MODEL FOR THE SERVER SO THAT EVERY DATABASE after this will be SIMPLE and have extended properties
---- USE [Model]

---- change the system model 
--USE [Model]
--GO

--ALTER DATABASE  [Model]
--SET RECOVERY SIMPLE;
--GO


----- change recovery model for a specific database
--USE [WDST]
--GO

--ALTER DATABASE [WDST]
--SET RECOVERY SIMPLE;
--GO






--- THIS SHOULD BE DEFAULT OF EVERY SERVER
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
--USE ECS
--USE FowlReport_Oracle
--USE HED_Oracle
--USE mdctables
--USE MDCTABLES_Oracle
--USE MOCOMPERM_Oracle
--USE MOFOREST_Oracle
--USE MOGOBBLE_Oracle
--USE POS_AS400
--USE POS_Combined
--USE POS_Oracle
--USE RAPTOR
--USE RAPTOR_ORACLE
--USE SURVEYS_Oracle
USE Waterfowl_Oracle
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





/*   v1  
    Script to Add Extended Properties to All User Databases

    This script adds four extended properties ('Description', 'Owner', 'Compliance', 'Comment') 
    to every user database in the SQL Server instance, excluding system databases (master, 
    tempdb, model, msdb). It uses a cursor to iterate over each database, switching context to 
    each one and executing the `sys.sp_addextendedproperty` procedure for each property.

    The extended properties are initialized with empty values (`N''`), but this can be modified 
    to set specific values for each database.

    Note:
    - Excludes system databases: 'master', 'tempdb', 'model', 'msdb'.
    - Ensures each database is online before applying the extended properties.
*/

DECLARE @dbname NVARCHAR(128);

-- Declare the cursor to loop through all user databases
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') -- Exclude system databases
  AND state = 0; -- Ensure the database is online

-- Open the cursor
OPEN db_cursor;

-- Loop through all fetched databases
FETCH NEXT FROM db_cursor INTO @dbname;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Switch to the current database and add the extended properties
    EXEC('USE [' + @dbname + '];

    EXEC sys.sp_addextendedproperty 
        @name = N''Description'', 
        @value = N'''';

    EXEC sys.sp_addextendedproperty 
        @name = N''Owner'', 
        @value = N'''';

    EXEC sys.sp_addextendedproperty 
        @name = N''Compliance'', 
        @value = N'''';

    EXEC sys.sp_addextendedproperty 
        @name = N''Comment'', 
        @value = N'''';
    ');

    -- Fetch the next database name
    FETCH NEXT FROM db_cursor INTO @dbname;
END

-- Clean up
CLOSE db_cursor;
DEALLOCATE db_cursor;








--  v2 with error catching
DECLARE @dbname NVARCHAR(128);

-- Declare the cursor to loop the through all user databases
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'msdb') -- Exclude system databases
  AND state = 0; -- Ensure the database is online

-- Open the cursor
OPEN db_cursor;

-- Loop through all fetched databases
FETCH NEXT FROM db_cursor INTO @dbname;
WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        -- Switch to the current database and add the extended properties
        EXEC('USE [' + @dbname + '];

        EXEC sys.sp_addextendedproperty 
            @name = N''Description'', 
            @value = N'''';

        EXEC sys.sp_addextendedproperty 
            @name = N''Owner'', 
            @value = N'''';

        EXEC sys.sp_addextendedproperty 
            @name = N''Compliance'', 
            @value = N'''';

        EXEC sys.sp_addextendedproperty 
            @name = N''Comment'', 
            @value = N'''';
        ');
    END TRY
    BEGIN CATCH
        -- If an error occurs, print the error message and continue to the next database
        PRINT 'Error in database: ' + @dbname + ' - ' + ERROR_MESSAGE();
    END CATCH;

    -- Fetch the next database name
    FETCH NEXT FROM db_cursor INTO @dbname;
END

-- Clean up
CLOSE db_cursor;
DEALLOCATE db_cursor;







---  will list out all database and if they have extended properties or not
-- V2   include all databases
DECLARE @SQL NVARCHAR(MAX);

-- Create a temporary table to store the results
IF OBJECT_ID('tempdb..#ExtendedProperties') IS NOT NULL
    DROP TABLE #ExtendedProperties;

CREATE TABLE #ExtendedProperties
(
    DatabaseName SYSNAME,
    ObjectClass NVARCHAR(100),
    PropertyName NVARCHAR(100),
    PropertyValue NVARCHAR(MAX)
);

-- Initialize dynamic SQL
SET @SQL = '';

-- Build the dynamic SQL to run on all databases
SELECT @SQL = @SQL + '
BEGIN TRY
    EXEC(''USE ' + QUOTENAME(name) + ';
    IF EXISTS (SELECT 1 FROM sys.extended_properties WHERE class = 0)
    BEGIN
        INSERT INTO #ExtendedProperties (DatabaseName, ObjectClass, PropertyName, PropertyValue)
        SELECT 
            ''''' + QUOTENAME(name) + ''''' AS DatabaseName,
            ep.class_desc AS ObjectClass,
            ep.name AS PropertyName,
            CAST(ep.value AS NVARCHAR(MAX)) AS PropertyValue
        FROM 
            sys.extended_properties ep
        WHERE 
            ep.class = 0;
    END
    ELSE
    BEGIN
        INSERT INTO #ExtendedProperties (DatabaseName, ObjectClass, PropertyName, PropertyValue)
        VALUES 
            (''''' + QUOTENAME(name) + ''''', ''''DATABASE'''', ''''DOES NOT EXIST'''', ''''DOES NOT EXIST'''');
    END'')
END TRY
BEGIN CATCH
    -- Handle errors for inaccessible databases
    PRINT ''Could not access database: ' + name + '''
END CATCH;
'
FROM 
    sys.databases
WHERE 
    name NOT IN ('master', 'msdb', 'tempdb'); -- Exclude system databases

-- Execute the dynamic SQL
EXEC sp_executesql @SQL;

-- Select the results from the temporary table
SELECT * FROM #ExtendedProperties;

-- Drop the temporary table
DROP TABLE #ExtendedProperties;






			