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





/***   LONG RUNNING QUERIES ************************************************************************************************

1. locate by using Redgate 

Process ID:	97
Process name:	Microsoft Office 2010
Database:	HNTXMP
Host:	IT-31045
User:	YYY\XXXXXX

2. optional if interested, locate user info MMMtables

***************************************************************************************************************************/


SELECT r.session_id, r.blocking_session_id, r.status, r.wait_type, r.wait_time, 
       r.cpu_time, r.total_elapsed_time, s.login_name, t.text AS sql_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)  t 
WHERE s.login_name = 'YYY\XXXXXX'
ORDER BY r.total_elapsed_time DESC;


KILL 97;

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
ORDER BY login_name, s.session_id;





