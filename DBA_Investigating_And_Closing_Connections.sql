

--- INVESTIGATION STEP

-- Step 1: Find the session ID (SPID) that is using the database
EXEC sp_who
EXEC sp_who2;
-- Note the SPID of the session connected to your database.


----- TODO: This is not returning all users. 
--USE master;
--SELECT 
--    sp.spid, 
--    sp.status, 
--    sp.loginame, 
--    sp.hostname, 
--    sp.program_name, 
--    sp.blocked, 
--    sp.waittype, 
--    sp.waittime, 
--    sp.lastwaittype, 
--    sp.cpu, 
--    sp.physical_io, 
--    sp.memusage, 
--    sp.open_tran, 
--    sp.status, 
--    sp.cmd, 
--    sp.dbid, 
--    sp.blocked
--FROM 
--    sys.sysprocesses sp
--WHERE 
--    sp.status = 'runnable' 
--    OR sp.status = 'suspended';

---- Check your current permissions
--SELECT 
--    IS_SRVROLEMEMBER('sysadmin') AS IsSysadmin,
--    HAS_PERMS_BY_NAME(null, null, 'VIEW SERVER STATE') AS HasViewServerState;

---- Grant VIEW SERVER STATE if needed
--GRANT VIEW SERVER STATE TO [your_login];



--- SOLUTION   #  1
USE master;
GO

ALTER DATABASE DQS_MAIN
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE;
GO


--- After connections are closed, you can reopen access to it.
ALTER DATABASE DQS_MAIN
SET MULTI_USER;
GO




