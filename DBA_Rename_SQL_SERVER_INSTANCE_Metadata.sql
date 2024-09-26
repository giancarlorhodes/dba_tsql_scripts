


Select @@servername --- meta data at the server level
Select SERVERPROPERTY(N'servername')  -- os level data

-- THE FIX below
-- Drop the old server name
EXEC sp_dropserver 'TESTCBS-DB01\TESTCBSDB01';

-- Add the new server name
EXEC sp_addserver 'CBSDB01\PROD', 'local';

-- step 2. restart the sql sever instances