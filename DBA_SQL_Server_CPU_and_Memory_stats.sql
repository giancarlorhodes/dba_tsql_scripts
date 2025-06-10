
/*
========================================================================================
-- SQL Server CPU and Memory stats
-- Author: Giancarlo Rhodes
-- Date: 9/13/2024
-- Description: SQL Server CPU and Memory stats

Query to retrieve SQL Server instance information, including CPU and memory details, 
and maximum server memory setting. 

Columns:
- instance_name: The name of the SQL Server instance.
- cpu_count: The total number of logical CPUs available to SQL Server.
- hyperthread_ratio: The ratio of logical processors to physical cores.
- affinity_type_desc: Describes the CPU affinity setting (AUTO or MANUAL).
- physical_memory_mb: Total physical memory on the server, converted from kilobytes (KB) to megabytes (MB).
- available_physical_memory_mb_to_OS: The amount of physical memory available to the operating system, converted from KB to MB.
- committed_memory_mb: Total committed memory for SQL Server, converted from KB to MB.
- sqlserver_start_time: The time when SQL Server was last started.
- virtual_machine_type_desc: Description of the virtual machine type, if applicable.
- max_server_memory_mb: The maximum amount of memory SQL Server is allowed to use, in megabytes (MB).
*/


SELECT 
    @@SERVERNAME AS instance_name,  -- SQL Server instance name
    cpu_count,
    hyperthread_ratio,
    affinity_type_desc,
    physical_memory_kb / 1024 AS physical_memory_mb, -- Convert physical memory to MB
    (SELECT available_physical_memory_kb / 1024 FROM sys.dm_os_sys_memory) AS available_physical_memory_mb_to_OS, -- Convert available physical memory to MB
    (SELECT committed_kb / 1024 FROM sys.dm_os_sys_memory) AS committed_memory_mb, -- Convert committed memory to MB
    sqlserver_start_time,
    virtual_machine_type_desc,
    CAST((SELECT value_in_use FROM sys.configurations WHERE name = 'max server memory (MB)') AS INT) AS max_server_memory_mb -- Explicit conversion to INT
FROM sys.dm_os_sys_info;



SELECT

	@@SERVERNAME AS Server_Name,  -- SQL Server instance name as Server_Name,
	-- SERVERPROPERTY('InstanceName') AS 'Instance_Name',
    SERVERPROPERTY('ProductVersion') AS 'SQL_Server_Version',
    SERVERPROPERTY('ProductLevel') AS 'SQL_Server_Edition',
    SERVERPROPERTY('Edition') AS 'SQL_Server_Edition_Detail',
    SERVERPROPERTY('EngineEdition') AS 'SQL_Server_Engine_Edition',
    cpu_count AS 'Number_of_Cores'

FROM sys.dm_os_sys_info;



