


/*
========================================================================================
    -- SQL Server Permission Management Script for db_executor Role
-- Author: Giancarlo Rhodes
-- Date: 9/13/2024
-- Description: This script is designed to manage and restrict the EXECUTE permissions for the 
    `db_executor` role in the specified database
	
	
    Description:
    This script is designed to manage and restrict the EXECUTE permissions for the 
    `db_executor` role in the specified database. The following operations are performed:

    1. Revoke any inherited or broad EXECUTE permissions on all objects within the `dbo`
       schema from the `db_executor` role. This ensures that the role does not have 
       unintended permissions on other objects in the schema.

    2. Explicitly grant EXECUTE permission on two specific objects: 
        - The `dbo.GetPersonInfo` stored procedure.
        - The `dbo.FNGetPersonId` scalar-valued function.
       
    3. Verify that the `db_executor` role has only the intended EXECUTE permissions by
       querying the system views to list objects the role can execute.

    Instructions:
    - Before running the script, replace `[YourDatabaseName]` with the actual name of
      your database.
    - Review the permissions granted and ensure they match your security requirements.

    Objects Affected:
    - Stored Procedures:
        1. dbo.GetPersonInfo
    - Scalar-Valued Functions:
        1. dbo.FNGetPersonId

    Notes:
    - The script ensures that `db_executor` does NOT have permissions on:
        1. dbo.LaneSelections
        2. dbo.DashBoardToRegistration
        3. dbo.FnGetPrimaryConservationIdIfMerged

========================================================================================
*/






USE [master]
GO


-- pre step if setting up the login at the server level and granting user basic db_reader at the database level 
/****** Object:  Login [somedomain\someuser]    Script Date: 9/9/2024 8:22:00 AM ******/
CREATE LOGIN [somedomain\someuser] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO


USE [MyDatabase]
GO
CREATE USER [somedomain\someuser] FOR LOGIN [somedomain\someuser]
GO
USE [MyDatabase]
GO
ALTER ROLE [db_datareader] ADD MEMBER [somedomain\someuser]
GO





--- create a custom role
-- The db_executor is not a built-in role in SQL Server, but it is a commonly used custom role 
-- that many DBAs create to grant users the ability to execute all stored procedures within
-- a database without giving them broader access.

-- Here’s a guide on how to create and manage a db_executor role:

-- STEP #1 create the custom role of the database level
USE [MyDatabase];
CREATE ROLE db_executor;


-- STEP #2: Grant Execute Permission to the Role
-- Now, grant the EXECUTE permission to this role on all stored procedures:
-- This command gives the EXECUTE permission to all stored procedures and functions for any user assigned to the db_executor role.

USE [MyDatabase]; 
GRANT EXECUTE TO db_executor;


-- STEP #3. Assigning a User to the db_executor Role
--  Once the role is created, you can add specific logins or users to this role.
--  Adding a User to the Role
--   This adds the Domain\LoginName user to the db_executor role, granting them the ability to execute stored procedures.


USE [MyDatabase];
EXEC sp_addrolemember 'db_executor', 'somedomain\someuser';



-- STEP 4  Managing the db_executor Role
--   To manage the role or see what members are part of the db_executor role, you can use the following commands
-- The sys.database_principals view is a system catalog view in SQL Server that contains information about all the 
-- database-level security principals. A principal can be a database user, a database role, or an 
-- application role within the context of the database


 USE [MyDatabase];
SELECT 
    DP1.name AS DatabaseRoleName,  
    DP2.name AS MemberName
FROM   
    sys.database_role_members AS DRM  
    INNER JOIN sys.database_principals AS DP1 
        ON DRM.role_principal_id = DP1.principal_id  
    INNER JOIN sys.database_principals AS DP2 
        ON DRM.member_principal_id = DP2.principal_id  
WHERE 
    DP1.name = 'db_executor';


-- STEP 5. TEST
--   how do I test it? It's a domain account and I don't have access to the password

--- 1. Impersonate the Domain Account in SQL Server
--- SQL Server allows you to impersonate another user with the EXECUTE AS statement. This is a great 
--- way to test permissions without needing the actual password.

USE [MyDatabase];
EXECUTE AS LOGIN = 'somedomain\someuser';  

USE [MyDatabase]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[SPM_FeesReportProcedure]
		@StartDate = N'2024-01-01',
		@EndDate = N'2024-09-09 00:00:00.000'

SELECT	'Return Value' = @return_value

GO


--Revert Back to Your Original Login:
--Once you're done testing, you can switch back to your original session using:
REVERT




--- ANOTHER SIMPLER WAY TO VERIFY db_executor is set up correctly
USE [MyDatabase];  -- Use the relevant database
-- show the properties of the new role
SELECT 
    dp.name AS PrincipalName,
    p.class_desc,              -- This will indicate the scope (e.g., DATABASE, OBJECT)
    p.permission_name,         -- The permission type (e.g., EXECUTE)
    p.state_desc               -- GRANT, DENY, REVOKE
FROM 
    sys.database_permissions p
JOIN 
    sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
WHERE 
    dp.name = 'db_executor'     -- Filter for the db_executor role
    AND p.permission_name = 'EXECUTE';




--- lists users of the custom role
USE [MyDatabase];  -- Use the relevant database

SELECT 
    dp2.name AS UserName,       -- The name of the user or login
    dp2.type_desc AS PrincipalType, -- The type of principal (SQL_USER, WINDOWS_USER, etc.)
    dp1.name AS RoleName        -- The role (should be 'db_executor')
FROM 
    sys.database_role_members drm
JOIN 
    sys.database_principals dp1 ON drm.role_principal_id = dp1.principal_id  -- Role
JOIN 
    sys.database_principals dp2 ON drm.member_principal_id = dp2.principal_id  -- User or login
WHERE 
    dp1.name = 'db_executor';   -- Filter for the db_executor role





----  ADVANCED --------------------------------------------------------------------------------------
-- To grant the db_executor role EXECUTE permission on only dbo.GetPersonInfo and dbo.FNGetPersonId 
--  WHILE ensuring it does not have EXECUTE permissions on other procedures and functions, you can follow these steps:

-- STEP 1. Revoke Existing Permissions on All Procedures and Functions
-- First, revoke any existing EXECUTE permissions from the db_executor role to ensure it 
-- doesn't have permissions on all procedures/functions.

USE [MyDatabase];

-- Revoke EXECUTE on all procedures and functions from db_executor
REVOKE EXECUTE ON SCHEMA::dbo FROM db_executor;

-- This ensures that db_executor will not have inherited permissions on all objects within the dbo schema.

-- STEP 2. Grant EXECUTE Permission on Specific Stored Procedure and Function
-- Now, you can explicitly grant EXECUTE permission on the desired objects (dbo.GetPersonInfo and dbo.FNGetPersonId).


USE [MyDatabase];

-- Grant EXECUTE on the dbo.GetPersonInfo stored procedure
GRANT EXECUTE ON OBJECT::dbo.GetPersonInfo TO db_executor;

-- Grant EXECUTE on the dbo.FNGetPersonId scalar-valued function
GRANT EXECUTE ON OBJECT::dbo.FNGetPersonId TO db_executor;


-- STEP 3. Verify Permissions
-- To verify that db_executor only has permissions on the two specific objects, you can use this query:

--- this will empty on object specific grants have been given to this custom role


--- this query below  with return an empty set the role have not been assigned specific objects and
-- instead has execute over the entire database.
-- Verifying Implicit Permissions
-- If the db_executor role was granted EXECUTE on the entire database, you may not see specific object-level permissions. 
-- SQL Server allows inherited permissions from higher levels like the database. This is why the first query may have returned nothing.

--	If the query is returning no results, it may be because the db_executor role hasn't been explicitly 
-- granted EXECUTE permissions on specific objects. In SQL Server, when a custom role like db_executor is 
-- created and EXECUTE permissions are granted on the database level, those permissions might apply implicitly 
-- to all stored procedures or functions without being tied to specific objects.


USE [MyDatabase];

SELECT 
    dp.name AS PrincipalName,
    p.class_desc,
    p.permission_name,
    p.state_desc,
    o.name AS ObjectName,
    o.type_desc
FROM 
    sys.database_permissions p
JOIN 
    sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
JOIN 
    sys.objects o ON p.major_id = o.object_id
WHERE 
    dp.name = 'db_executor'
    AND p.permission_name = 'EXECUTE';

