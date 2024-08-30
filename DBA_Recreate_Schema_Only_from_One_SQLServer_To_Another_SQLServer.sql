

/*
================================================================================
-- Script: Recreate Dev Database with Schema from Test Environment
-- 
-- Description:
-- This script is designed to perform the following tasks:
-- 1. Drop the existing development database, if it exists.
-- 2. Create a new, empty development database.
-- 3. Apply the schema from the test environment to the newly created 
--    development database.
--
-- Note:
-- - This script does not include any data migration; only the schema 
--   (tables, views, stored procedures, functions, etc.) will be recreated.
-- - It is highly recommended to take a backup of the current dev database 
--   before running this script, if any important data exists.
-- 
-- Usage:
-- 1. Ensure you have a backup of the current dev database, if necessary.
-- 2. Generate the schema script from the test environment using SQL Server 
--    Management Studio (SSMS).
-- 3. Paste the generated schema script in the section provided below.
-- 4. Execute this script in SQL Server Management Studio (SSMS).
--
-- Author: Giancarlo Rhodes
-- Date: 8/30/2024
================================================================================
*/


-- STEP 1 
--   1. Backup the Current Dev Database (Optional but Recommended)
--  Before dropping the database, you may want to back it up just in case you need to restore any data.
BACKUP DATABASE [MyDatabaseName]
TO DISK = 'D:\Dev\Backups\MyDatabaseName08302024.bak'
WITH FORMAT, INIT;



-- Step 2: Drop Existing Dev Database
USE master;
ALTER DATABASE [MyDatabaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE [MyDatabaseName];



-- Step 3: Create New Dev Database
CREATE DATABASE [MyDatabaseName];--- I DON'T THINK I NEED THIS STEP BACK STEP 4 in doing this for me.


-- STEP 4: Generate Schema Script from the Test Environment
--Generate a schema-only script from your test environment. You can do this through SQL Server Management Studio (SSMS):

--Right-click on the test database in SSMS.
--Go to Tasks > Generate Scripts.
--In the Choose Objects step, select Schema only.
--Save the script.

---------------   WARNING    CHANGE THE ENVIRONMENTS BEFORE RUNNING THIS PART  --------------
------  MAKE ADJUSTMENTS TO THE SCRIPT BELOW FOR THE PATHS  ---
--- YOU MAY NEED TO DELETE THE Phyical files for the filesystem
USE [master]
GO
--- blah blah blah
--- schema only script goes here

----Alternatively, you can use the following T-SQL command to generate a schema-only script for all objects:

------- WARNING ARE YOU IN THE RIGHT ENVIRONMENT TEST, PROD, ???????   !!!! ----------------------
--DECLARE @SchemaScript NVARCHAR(MAX);
--SET @SchemaScript = (
--    SELECT definition
--    FROM sys.sql_modules
--    WHERE object_id = OBJECT_ID(N'sys.sp_generate_inserts')
--);

--EXEC sp_executesql @SchemaScript;

