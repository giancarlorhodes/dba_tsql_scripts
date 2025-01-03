

--- list all sysadmin's on a sql server
SELECT 
    l.name AS LoginName,
    l.type_desc AS LoginType,
    r.name AS ServerRole,
    l.create_date AS CreatedDate,
    l.modify_date AS ModifiedDate
FROM 
    sys.server_principals l
INNER JOIN 
    sys.server_role_members rm
ON 
    l.principal_id = rm.member_principal_id
INNER JOIN 
    sys.server_principals r
ON 
    rm.role_principal_id = r.principal_id
WHERE 
    r.name = 'sysadmin'
ORDER BY 
    LoginName, ServerRole;

--- all the db_owners an all the databases on a server

/*
    Script Name: List db_owner Members Across All Databases
    Description: This script retrieves a list of all members of the `db_owner` role
                 across all online databases on the current SQL Server instance.
                 The result includes the login name, role name, database name,
                 and server name.
                 
    Author:      [Your Name]
    Date:        [Today's Date]

    Parameters:  None

    Output:      - LoginName: The login associated with the db_owner role
                 - RoleName: The role name (always `db_owner`)
                 - DatabaseName: The name of the database
                 - ServerName: The name of the SQL Server instance

    Requirements:
                 - The executing user must have sufficient permissions to query
                   sys.database_principals and sys.database_role_members in all databases.
                 - Only online databases are included in the result.

    Usage Notes:
                 - Test the script in a non-production environment before executing
                   on a live server.
                 - Modify as needed for additional filtering or customization.

    Disclaimer:  Ensure the script is executed with proper permissions, as it queries
                 sensitive role membership information.
*/

-- v1
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = '';

-- Loop through each database to query db_owners
SELECT @SQL = @SQL + 
    'USE [' + name + '];
    SELECT 
        SUSER_SNAME(p.sid) AS LoginName,
        r.name AS RoleName,
        DB_NAME() AS DatabaseName,
        @@SERVERNAME AS ServerName
    FROM sys.database_principals r
    INNER JOIN sys.database_role_members rm ON r.principal_id = rm.role_principal_id
    INNER JOIN sys.database_principals p ON rm.member_principal_id = p.principal_id
    WHERE r.name = ''db_owner'';
    '
FROM sys.databases
WHERE state_desc = 'ONLINE';

-- Execute the dynamically generated script
EXEC sp_executesql @SQL;



-- v2  
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = '';


-- Create a temporary table to hold the results
CREATE TABLE #DbOwnerMembers (
    LoginName NVARCHAR(256),
    RoleName NVARCHAR(256),
    DatabaseName NVARCHAR(256),
    ServerName NVARCHAR(256)
);

SET @SQL = '';

-- Loop through each database to query db_owners
SELECT @SQL = @SQL + 
    'USE [' + name + '];
    INSERT INTO #DbOwnerMembers (LoginName, RoleName, DatabaseName, ServerName)
    SELECT 
        SUSER_SNAME(p.sid) AS LoginName,
        r.name AS RoleName,
        DB_NAME() AS DatabaseName,
        @@SERVERNAME AS ServerName
    FROM sys.database_principals r
    INNER JOIN sys.database_role_members rm ON r.principal_id = rm.role_principal_id
    INNER JOIN sys.database_principals p ON rm.member_principal_id = p.principal_id
    WHERE r.name = ''db_owner'';
    '
FROM sys.databases
WHERE state_desc = 'ONLINE';

-- Execute the dynamically generated script
EXEC sp_executesql @SQL;

-- Select the combined results
SELECT * FROM #DbOwnerMembers ORDER BY LoginName;

-- Clean up the temporary table
DROP TABLE #DbOwnerMembers;




--USE [IAM_Analysis]; -- Replace with the target database name
USE [MDC_Timber];


SELECT 
    sp.name AS LoginName,
    dp.name AS DatabaseUserName,
    dp.type_desc AS UserType,
    STRING_AGG(r.name, ', ') AS Roles -- Aggregates multiple roles into a single string
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
LEFT JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
WHERE dp.type IN ('S', 'U', 'G') -- S = SQL user, U = Windows user, G = Windows group
AND dp.name NOT IN ('guest', 'INFORMATION_SCHEMA', 'sys') -- Exclude system accounts
GROUP BY sp.name, dp.name, dp.type_desc;



-- Specify the target database to analyze
USE [MDC_Timber]; -- Replace with your database name

-- Retrieve database users, their roles, and associated login names
SELECT 
    sp.name AS LoginName,               -- Server login name
    dp.name AS DatabaseUserName,        -- Database user name
    dp.type_desc AS UserType,           -- Type of database user (SQL, Windows user, or Windows group)
    STRING_AGG(r.name, ', ') AS Roles   -- Aggregates multiple roles into a single string
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm 
    ON dp.principal_id = drm.member_principal_id -- Map database user to role membership
LEFT JOIN sys.database_principals r 
    ON drm.role_principal_id = r.principal_id   -- Map role membership to roles
LEFT JOIN sys.server_principals sp 
    ON dp.sid = sp.sid                         -- Map database user to server login
WHERE dp.type IN ('S', 'U', 'G')               -- Filter for SQL users, Windows users, and Windows groups
  AND dp.name NOT IN ('guest', 'INFORMATION_SCHEMA', 'sys') -- Exclude system accounts
GROUP BY sp.name, dp.name, dp.type_desc;       -- Group by login, database user, and user type



