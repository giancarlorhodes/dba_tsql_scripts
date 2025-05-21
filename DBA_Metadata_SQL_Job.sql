


USE msdb;
GO

-- Declare the job name variable
DECLARE @JobName NVARCHAR(255) = 'jb_Delete_Data_GeotabAdapterDb';

-- =================================
-- Job Information (General Details)
-- =================================
SELECT 
    j.job_id,                           -- Unique identifier for the job
    j.name AS JobName,                  -- Job name
    j.enabled AS IsEnabled,             -- Whether the job is enabled (1 = Yes, 0 = No)
    j.description,                       -- Job description
    j.date_created,                      -- Job creation date
    j.date_modified,                     -- Last modification date
    j.owner_sid,                         -- Security identifier (SID) of the owner
    sp.name AS JobOwner                  -- Name of the job owner
FROM dbo.sysjobs j
LEFT JOIN sys.server_principals sp ON j.owner_sid = sp.sid
WHERE j.name = @JobName; -- Filter by job name

-- =================================
-- Job Steps (Execution Instructions)
-- =================================
SELECT 
    j.name AS JobName,                   -- Job name
    js.step_id,                          -- Step number in the job
    js.step_name,                        -- Step name
    js.command,                          -- SQL command or script executed in the step
    js.database_name,                    -- Database context
    js.subsystem,                        -- Type of step (T-SQL, CmdExec, PowerShell, etc.)
    js.on_success_action,                -- Action taken on success (Continue, Quit, etc.)
    js.on_fail_action                    -- Action taken on failure
FROM dbo.sysjobsteps js
JOIN dbo.sysjobs j ON js.job_id = j.job_id
WHERE j.name = @JobName; -- Filter by job name

-- =======================
-- Job Schedules (Timing)
-- =======================
SELECT 
    j.name AS JobName,                   -- Job name
    s.name AS ScheduleName,              -- Schedule name
    s.enabled AS IsScheduleEnabled,      -- Whether the schedule is active (1 = Yes, 0 = No)
    s.freq_type,                         -- Frequency type (Daily, Weekly, Monthly, etc.)
    s.freq_interval,                     -- Frequency interval (e.g., every 3 days)
    s.freq_subday_type,                  -- Subday type (Minutes, Hours, etc.)
    s.freq_subday_interval,              -- Subday interval count
    s.active_start_date,                 -- Start date (YYYYMMDD)
    s.active_end_date,                   -- End date (YYYYMMDD)
    s.active_start_time,                 -- Start time (HHMMSS)
    s.active_end_time                    -- End time (HHMMSS)
FROM dbo.sysjobschedules js
JOIN dbo.sysjobs j ON js.job_id = j.job_id
JOIN dbo.sysschedules s ON js.schedule_id = s.schedule_id
WHERE j.name = @JobName; -- Filter by job name

-- ===========================
-- Job Execution History
-- ===========================
SELECT 
    j.name AS JobName,                   -- Job name
    h.run_status,                        -- Job status (0 = Failed, 1 = Succeeded, 2 = Retry, 3 = Canceled, 4 = In Progress)
    h.run_date,                          -- Execution date (YYYYMMDD format)
    h.run_time,                          -- Execution time (HHMMSS format)
    h.run_duration,                      -- Duration in seconds
    h.operator_id_emailed,               -- Operator ID (if notified via email)
    h.operator_id_netsent,               -- Operator ID (if notified via network)
    h.operator_id_paged,                 -- Operator ID (if notified via pager)
    h.retries_attempted                  -- Number of retry attempts before success or failure
FROM dbo.sysjobhistory h
JOIN dbo.sysjobs j ON h.job_id = j.job_id
WHERE j.name = @JobName; -- Filter by job name

-- ======================================
-- Job Security & Permissions Information
-- ======================================
SELECT 
    sp.name AS PrincipalName,            -- User or role with permissions
    sp.type_desc AS PrincipalType,       -- Type of user (SQL login, Windows login, etc.)
    p.permission_name,                   -- Permission granted (SQLAgentOperatorRole, SQLAgentReaderRole, etc.)
    p.state_desc AS PermissionState      -- Whether permission is granted, denied, or revoked
FROM sys.database_permissions p
JOIN sys.server_principals sp ON p.grantee_principal_id = sp.principal_id
WHERE p.class_desc = 'SERVER' 
AND (p.major_id = 0 OR p.major_id IS NULL)  -- Filtering to include only server-level permissions
AND p.permission_name IN ('SQLAgentOperatorRole', 'SQLAgentReaderRole', 'SQLAgentUserRole'); -- Checking for SQL Agent roles

GO
