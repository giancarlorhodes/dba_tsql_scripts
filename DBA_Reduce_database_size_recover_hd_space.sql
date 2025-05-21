

SELECT 
    DB_NAME(database_id) AS DatabaseName,
    SUM(size) * 8 / 1024 / 1024 AS SizeGB
FROM sys.master_files
GROUP BY database_id
ORDER BY SizeGB DESC;



--- RAPTOR BEAST ----- DELETES  


USE Raptor;
Disable TRIGGER [dbo].[tr_tblExpenditure_After_UD] ON dbo.[tblExpenditure];
 
  SELECT COUNT(*) FROM tblExpenditure_Audit;
  Select COUNT(*) from tblExpenditure where ExpFY in (2022) and ExpRecId = 'ST';
  Select COUNT(*) from tblExpenditure where ExpFY not in (2021,2022,2023,2024,2025);



   DELETE FROM   tblExpenditure_Audit;
  -- DELETE FROM  tblExpenditure where ExpFY in (2022) and ExpRecId = 'ST'; -- too much


   
   DELETE FROM tblExpenditure 
			WHERE ExpAutoSeq IN (
    SELECT TOP (20000000) ExpAutoSeq 
    FROM tblExpenditure where ExpFY in (2022) and ExpRecId = 'ST'
    ORDER BY ExpAutoSeq ASC -- Adjust ordering as needed
);



   
DELETE FROM  tblExpenditure where ExpFY not in (2021,2022,2023,2024,2025);



    ENABLE TRIGGER [dbo].[tr_tblExpenditure_After_UD] ON dbo.[tblExpenditure];


--  Step 1: Set Database to SIMPLE Recovery Mode
ALTER DATABASE Raptor SET RECOVERY SIMPLE;


DBCC SQLPERF(LOGSPACE);


--- get the log file transactions reduced. 
USE Raptor
DBCC SHRINKFILE (Raptor_log, 1000); -- 1000 MB is just an example, adjust as needed






-- Step 1: Check the Free Space in the Database
EXEC sp_spaceused;

--Step 1: Shrink the Database Data File (Use with Caution)
DBCC SHRINKDATABASE (Raptor, 20); -- Shrink the database, keeping 20% free space

--- Step 3: Rebuild Indexes to Fix Fragmentation
EXEC sp_MSforeachtable 'ALTER INDEX ALL ON ? REBUILD';


--  Step 4: Check Space Again
EXEC sp_spaceused;


