


Select @@servername --- meta data at the server level
Select SERVERPROPERTY(N'servername')  -- os level data

-- THE FIX below
-- Drop the old server name
--EXEC sp_dropserver 'OldServerName';

-- Add the new server name
--EXEC sp_addserver 'NewServerName', 'local';

-- step 2. restart the sql sever instances