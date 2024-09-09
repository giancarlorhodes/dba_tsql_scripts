/*
--- Author: Giancarlo Rhodes
--- Create Data:  9/3/2024
-------------------------------------------------------------------------------------------
-- SQL Server Job and Stored Procedure Information Queries
-- 
-- Query 1: Find Stored Procedure by Name Across All Databases
--     This query searches for a specific stored procedure across all databases on the SQL Server.
--     It returns the database name, schema name, procedure name, and the definition of the stored procedure if found.
--     Useful when the exact database containing the procedure is unknown.
-- 
-- Query 2: Retrieve Detailed Information About SQL Server Jobs
--     This query retrieves comprehensive information about all SQL Server jobs, including job names, 
--     descriptions, schedules, last run status, and run history.
--     It helps in monitoring and managing SQL Server jobs by providing insights into job configurations and executions.
-- 
-- Query 3: Check if a Stored Procedure is Part of a Job Step
--     This query checks whether a specific stored procedure is used in any step of SQL Server jobs.
--     It returns the job name, step ID, step name, the T-SQL command in the step, the database context, 
--     and whether the job and the step are enabled or disabled.
--     This is useful for understanding dependencies and ensuring that critical procedures are correctly integrated into jobs.
-------------------------------------------------------------------------------------------
*/




--    Query 1: Find Stored Procedure by Name Across All Databases
DECLARE @ProcedureName NVARCHAR(128) = 'usp_WDST_KillBoard';

CREATE TABLE #ProcedureSearchResults (
    DatabaseName NVARCHAR(128),
    SchemaName NVARCHAR(128),
    ProcedureName NVARCHAR(128),
    ProcedureDefinition NVARCHAR(MAX)
);

DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL += 'USE [' + name + ']; 
    INSERT INTO #ProcedureSearchResults (DatabaseName, SchemaName, ProcedureName, ProcedureDefinition)
    SELECT 
        ''' + name + ''' AS DatabaseName, 
        SCHEMA_NAME(p.schema_id) AS SchemaName, 
        p.name AS ProcedureName, 
        OBJECT_DEFINITION(p.object_id) AS ProcedureDefinition
    FROM sys.procedures p 
    WHERE p.name = @ProcedureName;'
FROM sys.databases
WHERE state_desc = 'ONLINE';

EXEC sp_executesql @SQL, N'@ProcedureName NVARCHAR(128)', @ProcedureName = @ProcedureName;

SELECT * FROM #ProcedureSearchResults;

DROP TABLE #ProcedureSearchResults;





--Query 2: Retrieve Detailed Information About SQL Server Jobs
USE msdb;
GO

SELECT 
    jobs.job_id,
    jobs.name AS JobName,
    jobs.enabled AS IsEnabled,
    jobs.description AS JobDescription,
    jobs.date_created AS DateCreated,
    jobs.date_modified AS DateModified,
    schedules.name AS ScheduleName,
    schedules.freq_type AS ScheduleFrequencyType,
    schedules.freq_interval AS ScheduleFrequencyInterval,
    schedules.freq_subday_type AS ScheduleSubdayType,
    schedules.freq_subday_interval AS ScheduleSubdayInterval,
    schedules.active_start_date AS ScheduleStartDate,
    schedules.active_end_date AS ScheduleEndDate,
    schedules.active_start_time AS ScheduleStartTime,
    schedules.active_end_time AS ScheduleEndTime,
    CASE 
        WHEN jobhistory.run_status = 0 THEN 'Failed'
        WHEN jobhistory.run_status = 1 THEN 'Succeeded'
        WHEN jobhistory.run_status = 2 THEN 'Retry'
        WHEN jobhistory.run_status = 3 THEN 'Canceled'
        WHEN jobhistory.run_status = 4 THEN 'In Progress'
        ELSE 'Unknown'
    END AS LastRunStatus,
    jobhistory.run_date AS LastRunDate,
    jobhistory.run_time AS LastRunTime,
    jobhistory.run_duration AS LastRunDuration
FROM 
    msdb.dbo.sysjobs jobs
LEFT JOIN 
    msdb.dbo.sysjobschedules jobschedules ON jobs.job_id = jobschedules.job_id
LEFT JOIN 
    msdb.dbo.sysschedules schedules ON jobschedules.schedule_id = schedules.schedule_id
LEFT JOIN 
    msdb.dbo.sysjobhistory jobhistory ON jobs.job_id = jobhistory.job_id
    AND jobhistory.instance_id = (SELECT MAX(instance_id) FROM msdb.dbo.sysjobhistory WHERE job_id = jobs.job_id)
ORDER BY 
    jobs.name;


-- QUERY # 3   
--This query will now provide you with the status of both the job 
--and the specific step where the stored procedure is used.
--

USE msdb;
GO

DECLARE @ProcedureName NVARCHAR(128) = 'usp_WDST_KillBoard'; -- Replace with your stored procedure name

SELECT 
    j.name AS JobName,
	 CASE 
        WHEN j.enabled = 1 THEN 'Enabled'
        ELSE 'Disabled'
	END AS JobStatus,
    s.step_id AS StepID,
    s.step_name AS StepName,
    s.command AS StepCommand,
    s.database_name AS DatabaseName
FROM 
    msdb.dbo.sysjobs j
INNER JOIN 
    msdb.dbo.sysjobsteps s ON j.job_id = s.job_id
WHERE 
    s.command LIKE '%' + @ProcedureName + '%'
ORDER BY 
    j.name, s.step_id;

