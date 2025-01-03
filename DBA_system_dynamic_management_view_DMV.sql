-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/system-dynamic-management-views?view=sql-server-ver16

--DVM - dynamic management views

-- returns space usage info for each file in the database -- USE BLAH 
SELECT * FROM sys.dm_db_file_space_usage;


SELECT * FROM sys.dm_exec_connections;


SELECT DB_NAME(database_id) AS DatabaseName,
	OBJECT_NAME(object_id) AS ObjectName, *
	FROM sys.dm_db_index_usage_stats;



-- DBCC
-- https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-transact-sql?view=sql-server-ver16
USE Raptor;

DBCC CHECKDB;

-- database must be in single user mode
DBCC CHECKDB('Raptor', REPAIR_ALLOW_DATA_LOSS);
