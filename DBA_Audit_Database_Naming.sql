

--SELECT name
--FROM sys.databases;

--SELECT name
--FROM sys.databases
--WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');




--SELECT 
--    name AS Name,
--    CASE 
--        WHEN name COLLATE Latin1_General_BIN LIKE '[A-Z][a-zA-Z0-9]*' 
--        THEN 'True' 
--        ELSE 'False' 
--    END AS MeetsDatabaseNameRule,
--    'Data Standard Link - https://missouriconservation.sharepoint.com/:w:/r/sites/EnterpriseDataCommunications/Shared%20Documents/Information%20Technology/Database%20Management/MDC%20SQL%20DataBase%20Design%20Standards%20and%20Guidelines.docx?d=w459b2dd9e5d347178f5e915746fb8d92&csf=1&web=1&e=fHNq0W' AS Standards
--FROM sys.databases
--WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');



--SELECT 
--    name,
--    CASE 
--        WHEN name COLLATE Latin1_General_BIN LIKE '[A-Z][a-z0-9]*[A-Z][a-z0-9]*'
--        THEN 'True' 
--        ELSE 'False' 
--    END AS MeetsDatabaseNameRule,
--    'Data Standard Link - https://missouriconservation.sharepoint.com/:w:/r/sites/EnterpriseDataCommunications/Shared%20Documents/Information%20Technology/Database%20Management/MDC%20SQL%20DataBase%20Design%20Standards%20and%20Guidelines.docx?d=w459b2dd9e5d347178f5e915746fb8d92&csf=1&web=1&e=fHNq0W' AS StandardsRules
--FROM sys.databases
--WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');





--SELECT 
--    name,
--    CASE 
--        WHEN 
--            -- Check if the first character is uppercase and the rest are alphanumeric
--            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
--            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
--            -- Ensure there is at least one uppercase character after the first character
--            name COLLATE Latin1_General_BIN LIKE '%[A-Z]%'
--        THEN 'True' 
--        ELSE 'False' 
--    END AS MeetsDatabaseNameRule,
--    'Data Standard Link - https://missouriconservation.sharepoint.com/:w:/r/sites/EnterpriseDataCommunications/Shared%20Documents/Information%20Technology/Database%20Management/MDC%20SQL%20DataBase%20Design%20Standards%20and%20Guidelines.docx?d=w459b2dd9e5d347178f5e915746fb8d92&csf=1&web=1&e=fHNq0W' AS StandardsRules
--FROM sys.databases
--WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

---- V.01 VERSION
SELECT 
    name,
    CASE 
        WHEN 
            -- Check if the first character is uppercase
            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
            -- Check that the name contains only alphanumeric characters
            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
            -- Ensure the name contains both uppercase and lowercase letters (PascalCase rule)
            name COLLATE Latin1_General_BIN LIKE '%[a-z]%' AND
            name COLLATE Latin1_General_BIN LIKE '%[A-Z]%'
        THEN 'True' 
        ELSE 'False' 
    END AS MeetsDatabaseNameRule,
    'Data Standard Link - https://missouriconservation.sharepoint.com/:w:/r/sites/EnterpriseDataCommunications/Shared%20Documents/Information%20Technology/Database%20Management/MDC%20SQL%20DataBase%20Design%20Standards%20and%20Guidelines.docx?d=w459b2dd9e5d347178f5e915746fb8d92&csf=1&web=1&e=fHNq0W' AS StandardsRules
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');



---- V1.0  VERSION
SELECT 
    name,
    CASE 
        WHEN 
            -- Check if the first character is uppercase
            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
            -- Check that the name contains only alphanumeric characters
            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
            -- Ensure the name contains at least one lowercase letter
            name COLLATE Latin1_General_BIN LIKE '%[a-z]%' AND
            -- Ensure there is no consecutive uppercase sequence (e.g., 'MDCAtlas')
            name COLLATE Latin1_General_BIN NOT LIKE '%[A-Z][A-Z]%' 
        THEN 'True' 
        ELSE 'False' 
    END AS MeetsDatabaseNameRule,
    'Data Standard Link - https://missouriconservation.sharepoint.com/:w:/r/sites/EnterpriseDataCommunications/Shared%20Documents/Information%20Technology/Database%20Management/MDC%20SQL%20DataBase%20Design%20Standards%20and%20Guidelines.docx?d=w459b2dd9e5d347178f5e915746fb8d92&csf=1&web=1&e=fHNq0W' AS StandardsRules
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');



SELECT 
    name,
    CASE 
        WHEN 
            -- Check if the first character is uppercase
            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
            -- Check that the name contains only alphanumeric characters
            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
            -- Ensure the name contains at least one lowercase letter
            name COLLATE Latin1_General_BIN LIKE '%[a-z]%' AND
            -- Ensure there is no consecutive uppercase sequence (e.g., 'MDCAtlas')
            name COLLATE Latin1_General_BIN NOT LIKE '%[A-Z][A-Z]%' 
        THEN 'True' 
        ELSE 'False' 
    END AS MeetsDatabaseNameRule,
    CASE 
        WHEN 
            -- If the database name does not meet the PascalCase standard
            LEFT(name, 1) COLLATE Latin1_General_BIN NOT LIKE '[A-Z]' OR
            name COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9]%' OR
            name COLLATE Latin1_General_BIN NOT LIKE '%[a-z]%' OR
            name COLLATE Latin1_General_BIN LIKE '%[A-Z][A-Z]%'
        THEN 
            -- Suggest a corrected name in PascalCase
            REPLACE(REPLACE(
                LOWER(name), 
                LEFT(name, 1), 
                UPPER(LEFT(name, 1))
            ), '_', '') 
        ELSE NULL
    END AS NewNameSuggestion,
    'Data Standard Link - https://missouriconservation.sharepoint.com/:w:/r/sites/EnterpriseDataCommunications/Shared%20Documents/Information%20Technology/Database%20Management/MDC%20SQL%20DataBase%20Design%20Standards%20and%20Guidelines.docx?d=w459b2dd9e5d347178f5e915746fb8d92&csf=1&web=1&e=fHNq0W' AS StandardsRules
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');






---- SUMMARY QUERY
--- V.01
DECLARE @ServerName NVARCHAR(128);

-- Get the server name and assign it to the variable
SET @ServerName = CONVERT(NVARCHAR(128), SERVERPROPERTY('MachineName'));

-- Get the count of databases following and not following the standard
SELECT 
    @ServerName AS ServerName,
    SUM(CASE 
        WHEN 
            -- Check if the first character is uppercase
            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
            -- Check that the name contains only alphanumeric characters
            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
            -- Ensure the name contains both uppercase and lowercase letters (PascalCase rule)
            name COLLATE Latin1_General_BIN LIKE '%[a-z]%' AND
            name COLLATE Latin1_General_BIN LIKE '%[A-Z]%'
        THEN 1 
        ELSE 0 
    END) AS NumberOfDatabasesFollowingStandard,
    SUM(CASE 
        WHEN 
            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
            name COLLATE Latin1_General_BIN LIKE '%[a-z]%' AND
            name COLLATE Latin1_General_BIN LIKE '%[A-Z]%'
        THEN 0 
        ELSE 1 
    END) AS NumberOfDatabasesNotFollowingStandard
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');





---- v1.0 
DECLARE @ServerName NVARCHAR(128);

-- Get the server name and assign it to the variable
SET @ServerName = CONVERT(NVARCHAR(128), SERVERPROPERTY('MachineName'));

-- Summary query for database counts following and not following the naming rule
SELECT 
    @ServerName AS ServerName,
    SUM(CASE 
        WHEN 
            -- Check if the first character is uppercase
            LEFT(name, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]' AND
            -- Check that the name contains only alphanumeric characters
            name COLLATE Latin1_General_BIN NOT LIKE '%[^a-zA-Z0-9]%' AND
            -- Ensure the name contains at least one lowercase letter
            name COLLATE Latin1_General_BIN LIKE '%[a-z]%' AND
            -- Ensure there is no consecutive uppercase sequence (e.g., 'MDCAtlas')
            name COLLATE Latin1_General_BIN NOT LIKE '%[A-Z][A-Z]%' 
        THEN 1 
        ELSE 0 
    END) AS NumberOfDatabasesFollowingRule,
    SUM(CASE 
        WHEN 
            -- The conditions for the databases that do not follow the naming rule
            LEFT(name, 1) COLLATE Latin1_General_BIN NOT LIKE '[A-Z]' OR
            name COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9]%' OR
            name COLLATE Latin1_General_BIN NOT LIKE '%[a-z]%' OR
            name COLLATE Latin1_General_BIN LIKE '%[A-Z][A-Z]%'
        THEN 1 
        ELSE 0 
    END) AS NumberOfDatabasesNotFollowingRule
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');






