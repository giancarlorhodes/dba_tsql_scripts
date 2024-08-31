
/*
===============================================================================
-- Script Name: SQL Server Audit Setup and Configuration
-- Author: Giancarlo Rhodes
-- Date: 8/30/2024
-- 
-- Purpose:
-- This script is designed to configure SQL Server Audit for tracking data 
-- modification activities (INSERT, UPDATE, DELETE) within the specified database.
-- It creates a Server Audit to store the logs in a specified location and 
-- sets up a Database Audit Specification to monitor actions performed on the 
-- database. This audit setup helps in compliance, security, and monitoring by 
-- capturing and logging critical events.
--
-- Usage:
-- 1. Update the placeholders in the script with the actual database name 
--    and file path where the audit logs should be stored.
-- 2. Execute the script in SQL Server Management Studio (SSMS).
-- 3. The script will:
--    a. Create a Server Audit named 'MyServerAudit' to log events to a file.
--    b. Create a Database Audit Specification named 'MyDatabaseAuditSpec' 
--       for the specified database to audit INSERT, UPDATE, and DELETE operations.
--    c. Enable both the Server Audit and Database Audit Specification.
-- 4. Audit logs can be reviewed using the provided query at the end of this script.
--
-- Note:
-- - Ensure the file path specified for the audit logs is accessible by the 
--   SQL Server service account.
-- - The audit logs will capture events after the audit is enabled.
-- - Modify the database name, file path, and actions as per your requirements.
--
-- Example Usage:
-- EXEC sp
*/




USE WDST; -- Replace with your database name

SELECT 
    p.name AS PrincipalName,
    p.type_desc AS PrincipalType,
    p.default_schema_name,
    r.name AS RoleName,
    dp.permission_name,
    dp.state_desc AS PermissionState
FROM 
    sys.database_principals p
LEFT JOIN 
    sys.database_role_members drm ON p.principal_id = drm.member_principal_id
LEFT JOIN 
    sys.database_principals r ON drm.role_principal_id = r.principal_id
LEFT JOIN 
    sys.database_permissions dp ON p.principal_id = dp.grantee_principal_id
WHERE 
    dp.permission_name IN ('INSERT', 'UPDATE', 'DELETE')
    OR r.name IN ('db_owner', 'db_datawriter', 'db_ddladmin')
ORDER BY 
    PrincipalName, RoleName, PermissionState;





Use master;
SELECT 
    name AS AuditName,
    audit_id,
    is_state_enabled AS IsEnabled,
    queue_delay,
    on_failure,
    audit_guid,
    predicate
FROM 
    sys.server_audits;


--Setting Up SQL Server Audit
--Here’s a quick guide to setting up a basic SQL Server Audit:

--1. Create a Server Audit: This defines where the audit logs will be stored 
--(e.g., a file, the Windows Security log, or the Windows Application log).

---- Create a Server Audit that logs to a file
--CREATE SERVER AUDIT MyServerAudit
--TO FILE (FILEPATH = 'C:\SQLAuditLogs\', MAXSIZE = 10 MB);

---- Enable the Server Audit
--ALTER SERVER AUDIT MyServerAudit
--WITH (STATE = ON);


---- 2. Create a Database Audit Specification: This defines which actions within the database you want to audit.
--USE YourDatabaseName; -- Replace with your database name

---- Create a Database Audit Specification
--CREATE DATABASE AUDIT SPECIFICATION MyDatabaseAuditSpec
--FOR SERVER AUDIT MyServerAudit
--ADD (INSERT ON DATABASE::[YourDatabaseName] BY PUBLIC),
--ADD (UPDATE ON DATABASE::[YourDatabaseName] BY PUBLIC),
--ADD (DELETE ON DATABASE::[YourDatabaseName] BY PUBLIC);

---- Enable the Database Audit Specification
--ALTER DATABASE AUDIT SPECIFICATION MyDatabaseAuditSpec
--WITH (STATE = ON);


----3. Reviewing the Audit Logs: Once the audit is running, you can review the logs using the following query:
--SELECT 
--    event_time, 
--    action_id, 
--    succeeded, 
--    object_name, 
--    statement, 
--    server_principal_name, 
--    database_principal_name
--FROM 
--    sys.fn_get_audit_file('C:\SQLAuditLogs\*.sqlaudit', DEFAULT, DEFAULT);



--Summary:
--Server Audit: Configures the output for audit logs.
--Database Audit Specification: Specifies which actions are audited within a particular database.
--Log Review: Allows you to query the logs to see who performed which actions.
--This setup will enable auditing for future activities, allowing you to monitor INSERT, UPDATE, and DELETE operations in your database.


--- STEP 4 - this will work once auditing is set up and running
Use master;
SELECT 
    a.name AS AuditName,
    a.audit_id,
    a.is_state_enabled AS IsEnabled,
    d.database_id,
    d.name AS DatabaseName,
    s.action_id,
    s.action_name
FROM 
    sys.server_audits a
LEFT JOIN 
    sys.server_audit_specifications s ON a.audit_id = s.audit_id
LEFT JOIN 
    sys.database_audit_specifications d ON s.audit_id = d.audit_id
WHERE 
    d.database_id = DB_ID('WDST'); -- Replace with your database name


USE WDST; -- Replace with your database name
SELECT 
    name AS TableName, 
    is_tracked_by_cdc 
FROM 
    sys.tables 
WHERE 
    is_tracked_by_cdc = 1;



