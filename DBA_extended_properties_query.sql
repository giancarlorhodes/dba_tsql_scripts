

/*
    Script to Retrieve Extended Properties from All Databases

    Description:
    This script collects extended properties from all databases on the SQL Server instance. 
    It builds dynamic SQL to switch context to each database and query the `sys.extended_properties` 
    view to gather any existing properties. 

    After executing the dynamic SQL, the script checks for any databases that do not have extended 
    properties and inserts a placeholder indicating "No Extended Properties" for those databases.

    Key Components:
    - A temporary table (#ExtendedProperties) is created to store the results.
    - Dynamic SQL is constructed to handle each database context individually.
    - Error handling is implemented to manage any inaccessible databases.
    - A final query populates the temporary table with entries for databases without extended properties.

    Author: [Your Name]
    Date: [Today's Date]
*/



--- WORKING COPY V1 BUT all database are not included
--- I WOULD LIKE TO GET each database in the result set and just print a "no extend properties" row in the Property Name and PropertyValue fields.
-- for those databases, there would be only one row per database with the "no extend properties" row
DECLARE @SQL NVARCHAR(MAX);

-- Create a temporary table to store the results
IF OBJECT_ID('tempdb..#ExtendedProperties') IS NOT NULL
    DROP TABLE #ExtendedProperties;

CREATE TABLE #ExtendedProperties
(
    DatabaseName SYSNAME,
    ObjectClass NVARCHAR(100),
    PropertyName NVARCHAR(100),
    PropertyValue SQL_VARIANT
);

-- Initialize dynamic SQL
SET @SQL = '';

-- Build the dynamic SQL to run on all databases
SELECT @SQL = @SQL + '
BEGIN TRY
    EXEC(''USE ' + QUOTENAME(name) + ';
    INSERT INTO #ExtendedProperties (DatabaseName, ObjectClass, PropertyName, PropertyValue)
    SELECT 
        ''''' + QUOTENAME(name) + ''''' AS DatabaseName,
        ep.class_desc AS ObjectClass,
        ep.name AS PropertyName,
        ep.value AS PropertyValue
    FROM 
        sys.extended_properties ep
    WHERE 
        ep.class = 0'')
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



