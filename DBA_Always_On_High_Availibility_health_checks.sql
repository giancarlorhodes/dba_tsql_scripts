/*
===================================================================================
-- Script: Always On Availability Groups Monitoring Queries
-- Author: Giancarlo Rhodes
-- Date: 9/13/2024
-- Description:
   This script contains a set of useful T-SQL queries to monitor the health, 
   synchronization status, and performance of SQL Server Always On Availability Groups.
   
   Query #1: View Availability Group and Replica Roles
      - Provides the name of the Availability Group and each replica's role (Primary/Secondary).
      - Includes information about the synchronization health and availability mode.
   
   Query #2: Check Database Synchronization Status
      - Displays the synchronization status of each database in the Availability Group.
      - Shows whether the database is synchronized, not synchronizing, or synchronizing, 
        and whether it is a commit participant or not.

   Query #3: View Replica Operational Health
      - Provides detailed operational information about each database replica in the 
        Availability Group, including synchronization state, log send, and redo queue sizes.
      - Helps monitor key metrics related to database synchronization performance.
      
   Query #4: View Latency Between Primary and Secondary Replicas
      - Checks for latency between primary and secondary replicas by displaying the log send 
        and redo queue sizes in KB and their respective rates.
      
   Query #5: Check Failover Readiness
      - Monitors the failover readiness of the Availability Group by checking the 
        synchronization state and health of each database in the secondary replicas.

===================================================================================
*/



USE master;
SELECT 
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name AS ServerName,
    CASE ars.role
        WHEN 1 THEN 'PRIMARY'
        WHEN 2 THEN 'SECONDARY'
    END AS Role,
    ars.synchronization_health_desc AS SynchronizationHealth
FROM 
    sys.availability_groups ag
JOIN 
    sys.availability_replicas ar 
    ON ag.group_id = ar.group_id
JOIN 
    sys.dm_hadr_availability_replica_states ars 
    ON ar.replica_id = ars.replica_id
ORDER BY 
    Role;


-- 1.   View Availability Group Status
--   This query provides an overview of the health and status of the Availability Groups and replicas.

SELECT 
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name AS ServerName,
    CASE ars.role
        WHEN 1 THEN 'PRIMARY'
        WHEN 2 THEN 'SECONDARY'
    END AS Role,
    ars.operational_state_desc AS OperationalState,
    ars.connected_state_desc AS ConnectedState,
    ars.synchronization_health_desc AS SynchronizationHealth,
    ar.availability_mode_desc AS AvailabilityMode,
    ar.failover_mode_desc AS FailoverMode
FROM 
    sys.availability_groups ag
JOIN 
    sys.availability_replicas ar 
    ON ag.group_id = ar.group_id
JOIN 
    sys.dm_hadr_availability_replica_states ars 
    ON ar.replica_id = ars.replica_id
ORDER BY 
    Role;


---   2. Check Database Synchronization Status
--   This query helps to monitor the synchronization status of databases across the availability replicas.


Use mdctables;
SELECT 
    dbcs.database_name AS DatabaseName,
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name AS ReplicaServerName,
    CASE drs.synchronization_state
        WHEN 0 THEN 'Not Synchronizing'
        WHEN 1 THEN 'Synchronizing'
        WHEN 2 THEN 'Synchronized'
    END AS SynchronizationState,
    drs.synchronization_health_desc AS SynchronizationHealth,
    drs.is_commit_participant AS CommitParticipant,
    drs.is_suspended AS IsSuspended
FROM 
    sys.availability_databases_cluster dbcs
JOIN 
    sys.dm_hadr_database_replica_states drs 
    ON dbcs.group_database_id = drs.group_database_id
JOIN 
    sys.availability_groups ag 
    ON dbcs.group_id = ag.group_id
JOIN 
    sys.availability_replicas ar 
    ON drs.replica_id = ar.replica_id
ORDER BY 
    dbcs.database_name;


---   3. View Replica Operational Health
--   This query gives detailed information on the health of each replica, such as synchronization state, last send/redo times, etc.

SELECT 
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name AS ReplicaServerName,
    dbcs.database_name AS DatabaseName,
    drs.synchronization_state_desc AS SynchronizationState,
    drs.synchronization_health_desc AS SynchronizationHealth,
    drs.last_sent_time,
    drs.last_redone_time,
    drs.redo_queue_size,
    drs.log_send_queue_size
FROM 
    sys.dm_hadr_database_replica_states drs
JOIN 
    sys.availability_databases_cluster dbcs 
    ON drs.group_database_id = dbcs.group_database_id
JOIN 
    sys.availability_groups ag 
    ON dbcs.group_id = ag.group_id
JOIN 
    sys.availability_replicas ar 
    ON drs.replica_id = ar.replica_id
ORDER BY 
    dbcs.database_name;



	---    4. View Latency Between Primary and Secondary Replicas
--   This query helps to check for any latency issues between the primary and secondary replicas by showing the log send and redo queue sizes.

SELECT 
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name AS ServerName,
    dbrs.database_id,
    db.name AS DatabaseName,
    dbrs.log_send_queue_size AS LogSendQueueSizeInKB,
    dbrs.redo_queue_size AS RedoQueueSizeInKB,
    dbrs.redo_rate AS RedoRateKBPerSec,
    dbrs.log_send_rate AS LogSendRateKBPerSec
FROM 
    sys.dm_hadr_database_replica_states dbrs
JOIN 
    sys.availability_databases_cluster db 
    ON dbrs.group_database_id = db.group_database_id
JOIN 
    sys.availability_groups ag 
    ON db.group_id = ag.group_id
JOIN 
    sys.availability_replicas ar 
    ON ar.replica_id = dbrs.replica_id
ORDER BY 
    dbrs.log_send_queue_size DESC;



