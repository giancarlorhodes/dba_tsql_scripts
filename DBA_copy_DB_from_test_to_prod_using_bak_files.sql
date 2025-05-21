




--- SEE ACTIVE CONNECTIONS
USE master;
GO
EXEC sp_who2;


SELECT 
    s.session_id,
    s.login_name,
    c.client_net_address,
    s.database_id,
    DB_NAME(s.database_id) AS database_name,
    r.status AS request_status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time,
    r.wait_time,
    r.wait_type,
    r.blocking_session_id
FROM 
    sys.dm_exec_sessions s
JOIN 
    sys.dm_exec_connections c ON s.session_id = c.session_id
JOIN 
    sys.dm_exec_requests r ON s.session_id = r.session_id
WHERE 
    DB_NAME(s.database_id) = 'StreamTeam_New2';  -- Replace with your database name


	---   put database into single user mode
ALTER DATABASE StreamTeamNew SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- take database offline
ALTER DATABASE StreamTeamNew SET OFFLINE WITH ROLLBACK IMMEDIATE;

-- detach database
USE master;
EXEC sp_detach_db 'StreamTeamNew';


-- Check Logical Names in Your Backup
-- To see the logical file names stored in your backup, run:
RESTORE FILELISTONLY FROM DISK = 'D:\Backup\StreamTeam_New2.bak';

RESTORE FILELISTONLY FROM DISK = 'D:\Backup\StreamTeam_New2_Appdb01.bak';


-- check logical and physical active database
SELECT 
 DB_NAME(database_id) AS DatabaseName,
    name AS LogicalName,
    physical_name AS PhysicalName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB
FROM sys.master_files
WHERE database_id = DB_ID('StreamTeam');

SELECT 
 DB_NAME(database_id) AS DatabaseName,
    name AS LogicalName,
    physical_name AS PhysicalName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB
FROM sys.master_files
WHERE database_id = DB_ID('StreamTeamOld');

SELECT 
 DB_NAME(database_id) AS DatabaseName,
    name AS LogicalName,
    physical_name AS PhysicalName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB
FROM sys.master_files
WHERE database_id = DB_ID('StreamTeam_New2');


-- overwrites  
RESTORE DATABASE StreamTeam_New2 
FROM DISK = 'D:\Backup\StreamTeam_New2.bak'
WITH REPLACE,
MOVE 'StreamTeam_New2' TO 'D:\Data\StreamTeam_New2.mdf',
     MOVE 'StreamTeam_New2_Log' TO 'E:\Logs\StreamTeam_New2_log.ldf';



-- no overwrite, there could be conflicts with phyical file locations where an error would prevent completion
RESTORE DATABASE StreamTeam_New2 
FROM DISK = 'D:\Backup\StreamTeam_New2.bak'
WITH MOVE 'StreamTeam_New2' TO 'D:\Data\StreamTeam_New2.mdf',
     MOVE 'StreamTeam_New2_Log' TO 'E:\Logs\StreamTeam_New2_log.ldf';


--If the backup file is called StreamTeam_New2_Appdb01.bak, here’s how you can 
-- RESTORE it while renaming the logical and physical file names:
-- Got it! If the backup file is called StreamTeam_New2_Appdb01.bak, here’s how you 
-- can restore it while renaming the logical and physical file names:


RESTORE DATABASE StreamTeamOld 
FROM DISK = 'D:\Backup\StreamTeam_New2_Appdb01.bak'
WITH MOVE 'StreamTeam_New2' TO 'D:\Data\StreamTeamOld.mdf',
     MOVE 'StreamTeam_New2_log' TO 'E:\Logs\StreamTeamOld_log.ldf';


