/****** Script for SelectTopNRows command from SSMS  ******/


--Understanding the Relationships Between Deadlocks, Blocking, and Long-Running Queries
--Deadlocks, blocking, and long-running queries are all interconnected performance issues in SQL Server. They can influence each other, 
--meaning that one issue can lead to another or make an existing issue worse. Here’s how they relate:


--Blocking and Long-Running Queries
--🔗 Relationship:
--Long-running queries can cause blocking.
--If a query holds locks for too long, it prevents other queries from accessing the same resource, leading to blocking.
--Blocking can make a query appear long-running.
--A query might not be slow on its own but could be waiting on a blocked resource.
--📌 Example:
--🔴 Scenario: A transaction updates a row in Orders but does not commit immediately. Another query needs the same row but is blocked until the first query finishes.

--sql
--Copy
--Edit
--BEGIN TRAN;
--UPDATE Orders SET Status = 'Shipped' WHERE OrderID = 123; 
---- (No COMMIT yet, causing blocking)
--🟢 Solution:

--Identify and optimize the long-running transaction.
--Reduce lock duration (e.g., commit as soon as possible).
--Use READ COMMITTED SNAPSHOT isolation level if appropriate.




--Blocking and Deadlocks
--🔗 Relationship:
--All deadlocks start as blocking.
--Blocking occurs when Query A locks a resource, and Query B waits for it.
--A deadlock happens when two (or more) queries are blocking each other in a cycle.
--Unlike blocking (which eventually resolves when the first query completes), deadlocks require SQL Server to forcefully kill one of the queries.
--📌 Example:
--🔴 Scenario:

--Transaction A locks Table1 and tries to update Table2.
--Transaction B locks Table2 and tries to update Table1.
--Both transactions are now waiting for each other to release locks—a deadlock occurs!
--sql
--Copy
--Edit
---- Transaction A
--BEGIN TRAN;
--UPDATE Table1 SET Col1 = 1 WHERE ID = 1;
--WAITFOR DELAY '00:00:05'; -- Simulate delay
--UPDATE Table2 SET Col2 = 2 WHERE ID = 2;
--COMMIT;
--sql
--Copy
--Edit
---- Transaction B
--BEGIN TRAN;
--UPDATE Table2 SET Col2 = 2 WHERE ID = 2;
--WAITFOR DELAY '00:00:05';
--UPDATE Table1 SET Col1 = 1 WHERE ID = 1;
--COMMIT;
--🟢 Solution:

--Ensure queries access tables in the same order to prevent circular dependencies.
--Minimize transaction duration and lock time.
--Use deadlock priority or retry logic in applications.



--3️⃣ Deadlocks and Long-Running Queries
--🔗 Relationship:
--Long-running queries increase the chance of deadlocks.
--If a transaction holds locks for a long time, other queries that need those locks might get stuck in a deadlock cycle.
--📌 Example:
--🔴 Scenario:
--A long-running query reads a large dataset while another transaction tries to update the same table. This increases the chance of a deadlock because multiple transactions hold conflicting locks for too long.

--sql
--Copy
--Edit
--SELECT * FROM LargeTable WHERE Col1 > 1000; -- (Takes 30 seconds)
--sql
--Copy
--Edit
--UPDATE LargeTable SET Col1 = Col1 + 1 WHERE Col1 > 1000; -- (Blocked)
--🟢 Solution:

--Optimize slow queries (indexing, avoiding table scans).
--Reduce transaction time and use lock-free strategies if possible.
--Use snapshot isolation levels to avoid unnecessary locking.





-- Big-Picture Summary Table
--Issue					Root Cause												Relationship to Other Issues																										Prevention & Fixes
--Blocking				One query locks a resource, and another waits			Can lead to deadlocks if two queries block each other. Can cause long-running queries if blocked processes accumulate.				Reduce transaction duration, add proper indexing, enable READ COMMITTED SNAPSHOT if applicable
--Deadlocks				Two or more queries block each other in a cycle			Caused by blocking when processes hold locks too long. More likely with long-running queries.										Ensure consistent ordering of table updates, reduce lock time, handle deadlocks with retry logic
--Long-Running Queries	Poor indexing, inefficient queries, excessive locking	Causes blocking if it holds locks too long. Increases deadlock risk if multiple queries get stuck waiting.							Optimize queries, use query tuning (indexes, execution plans), break queries into smaller parts

--🔑 Final Takeaways
--✔ Long-running queries → Cause blocking
--✔ Blocking queries → Can escalate into deadlocks
--✔ Deadlocks → Happen when blocked queries wait on each other in a cycle

--🟢 Fixing one issue (e.g., query optimization) often reduces the other two!
--Let me know if you need detailed scripts for monitoring or fixing these! 🚀




/***   LONG RUNNING QUERIES ************************************************************************************************

1. locate by using Redgate 

Process ID:	97
Process name:	Microsoft Office 2010
Database:	HNTXMP
Host:	IT-31045
User:	YYY\XXXXXX

2. optional if interested, locate user info MMMtables

***************************************************************************************************************************/


SELECT r.session_id, r.start_time, r.status, r.wait_type, r.wait_time, 
       r.cpu_time, r.total_elapsed_time, r.reads, r.writes, r.command,
       r.blocking_session_id, s.program_name, s.host_name, s.login_name, 
       t.text AS sql_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.total_elapsed_time > 60000 -- 60 seconds (adjust as needed)
ORDER BY r.total_elapsed_time DESC;



KILL 71;
KILL 99; 
KILL 53;


--Killing Long-Running SELECT Queries in SQL Server
--By default, SELECT queries don't hold locks like UPDATE or DELETE, but they can cause blocking if they scan massive tables, 
--use poor indexing, or have long-running joins. Here's how to find and kill problematic SELECT statements.





/***   BLOCKING  ************************************************************************************************/


SELECT r.session_id, r.blocking_session_id, r.status, r.wait_type, r.wait_time, 
       r.cpu_time, r.total_elapsed_time, s.login_name, t.text AS sql_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)  t 
--WHERE s.login_name = 'YYY\XXXXXX'
ORDER BY r.total_elapsed_time DESC;


KILL 68;

--- all sessions
SELECT r.session_id, r.blocking_session_id, r.status, r.wait_type, r.wait_time, 
       r.cpu_time, r.total_elapsed_time, s.login_name, t.text AS sql_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
--WHERE r.status = 'running'
ORDER BY r.total_elapsed_time DESC;



SELECT s.session_id, s.login_name, s.status, s.host_name, s.program_name, 
       s.cpu_time, s.memory_usage, s.total_elapsed_time, r.blocking_session_id, 
       r.wait_type, r.wait_time, t.text AS sql_text
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t
ORDER BY s.session_id, s.login_name;


KILL 52;


/*******************************          DEADLOCKS **********************************************************/

--If No Deadlocks Appear
--Check if the system_health session is running:
SELECT * FROM sys.dm_xe_sessions WHERE name = 'system_health';


--If no results, start it manually:
ALTER EVENT SESSION [system_health] ON SERVER STATE = START;


--1. Check for Active Deadlocks
--Run the following query to see if there are currently active deadlocks:
SELECT 
    r1.session_id AS BlockingSession,
    r2.session_id AS BlockedSession,
    r2.wait_type,
    r2.wait_time,
    r2.wait_resource,
    r2.status
FROM sys.dm_exec_requests r1
JOIN sys.dm_exec_requests r2 ON r1.session_id = r2.blocking_session_id;



--2. Check Recent Deadlocks in the Error Log
--Since xp_readerrorlog did not return deadlocks, try filtering with EXEC sp_readerrorlog instead:


EXEC sp_readerrorlog 0, 1, N'deadlock';
--If this still returns no rows, deadlocks might not be recorded in the error logs.




-- -- If the result is 0, then there are no deadlocks recorded recently. You can force a deadlock
-- (as described in my previous message) to check if data starts showing up again.
WITH Deadlocks AS (
    SELECT 
        CAST(target_data AS XML) AS DeadlockGraph
    FROM sys.dm_xe_session_targets AS xt
    JOIN sys.dm_xe_sessions AS xs ON xs.address = xt.event_session_address
    WHERE xs.name = 'system_health'
    AND xt.target_name = 'ring_buffer'
)
SELECT COUNT(*) AS DeadlockCount
FROM Deadlocks
CROSS APPLY DeadlockGraph.nodes('//RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData(XEvent);
