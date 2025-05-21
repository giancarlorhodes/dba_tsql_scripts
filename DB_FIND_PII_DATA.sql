
--In a SQL Server database, fields that contain Tier 1 Personally Identifiable Information (PII) should be encrypted to 
--protect sensitive data. Tier 1 PII refers to information that, if exposed, could lead to identity theft, fraud, or significant privacy violations.

--Fields That Should Be Encrypted (Tier 1 PII):
--Full Name (if combined with other sensitive data)
--Social Security Number (SSN)
--Driver’s License Number / State ID
--Passport Number
--Financial Account Numbers (e.g., bank account numbers, routing numbers)
--Credit/Debit Card Numbers (PCI DSS compliance requires encryption)
--Health Information (e.g., medical records, diagnosis, treatment history)
--Biometric Data (e.g., fingerprints, retina scans, voice recognition)
--Personal Taxpayer Identification Number (TIN)
--Cryptographic Private Keys / Security Tokens
--Insurance Policy Numbers (if used for identification)
--Full Date of Birth (if combined with name or other sensitive data)


-- V1 
-- script examines all columns in all DBs for PII sounding names
EXEC sp_msforeachDB 'USE [?]
SELECT db_name() as [DB], 
object_name(o.object_id) AS [Object], 
c.name AS [Column]
FROM sys.columns c join sys.objects o ON c.object_id = o.object_id 
WHERE o.type IN (''U'',''V'') /* tables and views */
AND (c.name like ''%mail%''
OR c.name like ''%first%name%''
OR c.name like ''%last%name%''
OR c.name like ''%birth%''
OR c.name like ''%sex%''
OR c.name like ''%address%''
OR c.name like ''%phone%''
OR c.name like ''%social%''
OR c.name like ''%ssn%''
OR c.name like ''%gender%'')
AND db_name() NOT IN (''msdb'',''tempdb'',''master'')'



-- V2 
-- script examines all columns in all DBs for PII sounding names
EXEC sp_msforeachDB 'USE [?]
SELECT db_name() as [DB], 
object_name(o.object_id) AS [Object], 
c.name AS [Column]
FROM sys.columns c join sys.objects o ON c.object_id = o.object_id 
WHERE o.type IN (''U'',''V'') /* tables and views */
AND 
(

c.name like ''%dln%''
OR c.name like ''%license%''
OR c.name like ''%drvlic%''
OR c.name like ''%licnum%''
OR c.name like ''%drv_lic%''
OR c.name like ''%dl_number%''
OR c.name like ''%dlnum%''
OR c.name like ''%stateid%''
OR c.name like ''%driverslic%''
OR c.name like ''%driverid%''

OR c.name like ''%ssn%''
OR c.name like ''%ssnnumber%''
OR c.name like ''%social%security%''
OR c.name like ''%socsec%''
OR c.name like ''%soc_sec_num%''

OR c.name like ''%birth%''
OR c.name like ''%bdate%''
OR c.name like ''%dob%''
OR c.name like ''%bday%''
OR c.name like ''%brthdy%''

)
AND db_name() NOT IN (''msdb'',''tempdb'',''master'')'



-- shows if the database is encrypted or not.
SELECT name, is_encrypted 
FROM sys.databases 
--WHERE name = 'master';


-- SDE2
--SELECT SSNAGPERA FROM Forestry.MOFITS_GIS_STAND_DATA

---- SDETEST2  
--USE GIS_OnE
--SELECT  DOB FROM OnE.MO_EVENTS_PARTICIPANTS_GEOCODED