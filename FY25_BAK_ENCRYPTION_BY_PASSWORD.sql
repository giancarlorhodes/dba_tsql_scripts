






--USE master;
-- CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'y0V>5-JDs*(q*3^yMEV<';


-- 1. Create the Master Key (only once per instance, if not already created)
-- This is only required once per SQL Server instance.
-- If a DMK (Database Master Key) already exists, skip this step.

USE master;
-- YourStrongPassword
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'y0V>5-JDs*(q*3^yMEV<'; ---  you want this in a secure location


-- 2. Create and Export the Certificate
CREATE CERTIFICATE BackupCert  
WITH SUBJECT = 'Backup Encryption Certificate';

BACKUP CERTIFICATE BackupCert  
TO FILE = 'D:\Backup\BackupCert.cer'  
WITH PRIVATE KEY  
(FILE = 'D:\Backup\BackupCertKey.pvk', 
--AnotherStrongPassword
ENCRYPTION BY PASSWORD = 'd;PWjEd/$Vw]Q`*xQ9u');    --- you  want this in a secure location


-- 4. Perform an Encrypted Backup
BACKUP DATABASE FowlReport_Oracle  
TO DISK = 'D:\Backup\FowlReport_Oracle_Encrypted_03042025.bak'  --- you will need a .cer, .pvk, and passwords to decyrpt/restore
WITH ENCRYPTION  
(ALGORITHM = AES_256, SERVER CERTIFICATE = BackupCert);


--Processed 440 pages for database 'FowlReport_Oracle', file 'FowlReport_Oracle' on file 1.
--Processed 1 pages for database 'FowlReport_Oracle', file 'FowlReport_Oracle_log' on file 1.
--BACKUP DATABASE successfully processed 441 pages in 0.147 seconds (23.394 MB/sec).

--Completion time: 2025-03-04T11:56:13.3602404-06:00



--Restore Process Recap (on a different server)
-- 1. Copy the certificate (.cer), private key (.pvk), and password securely to the new server.

-- 2. Restore the Certificate Before Restoring the Database:
CREATE CERTIFICATE BackupCert  
FROM FILE = 'C:\Backups\BackupCert.cer'  
WITH PRIVATE KEY  
(FILE = 'C:\Backups\BackupCertKey.pvk',   
DECRYPTION BY PASSWORD = 'AnotherStrongPassword');



-- Is the DMK in the master database??
-- 3. Restore the Database from the Encrypted Backup:
RESTORE DATABASE YourDatabase  
FROM DISK = 'C:\Backups\YourDatabase_Encrypted.bak';
--This setup ensures only authorized Enterprise DBAs can restore encrypted backups, enhancing security.


--ERROR IF YOU DON'T SET THIS UP ON THE DESTINATION SERVER
-- WHILE CONNECTING TO THE BAK FILE
--TITLE: Microsoft SQL Server Management Studio
--------------------------------

--An exception occurred while executing a Transact-SQL statement or batch. (Microsoft.SqlServer.ConnectionInfo)

--------------------------------
--ADDITIONAL INFORMATION:

--Cannot find server certificate with thumbprint '0x2984372361700B45385AB6A2C8034AFB6AE13C99'.
--RESTORE HEADERONLY is terminating abnormally. (Microsoft SQL Server, Error: 33111)

--For help, click: https://docs.microsoft.com/sql/relational-databases/errors-events/mssqlserver-33111-database-engine-error



