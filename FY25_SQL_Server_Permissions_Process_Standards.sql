/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT [OBJECTID]
--      ,[SAMPLEID]
--      ,[CONSERVATIONID]
--      ,[TELECHECK]
--      ,[COLLECTIONDATE]
--      ,[RESULTS]
--      ,[COUNTY]
--      ,[TOWNSHIP]
--      ,[RANGE]
--      ,[SECTION]
--      ,[SEX]
--      ,[AGE]
--      ,[TelecheckConfirmationNumber]
--  FROM [MoHealth].[cwdjson].[vwCWDResults];


--  SELECT * FROM  [MoHealth].[cwdjson].[vwCWDResults];

  SELECT * FROM [MoHealth].[cwdjson].[vwCWDResultsFast];


--USE Raptor
--GO

--update tblExpenditure
--set FedgrantCode = 'TADM'
--where ExpAutoSeq in (53892029,54086677,54172415,54172416,54252696)

--GO


USE [IAM_Analysis]; -- Replace with the target database name

SELECT 
    sp.name AS LoginName,
    dp.name AS DatabaseUserName,
    dp.type_desc AS UserType,
    STRING_AGG(r.name, ', ') AS Roles -- Aggregates multiple roles into a single string
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
LEFT JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
WHERE dp.type IN ('S', 'U', 'G') -- S = SQL user, U = Windows user, G = Windows group
AND dp.name NOT IN ('guest', 'INFORMATION_SCHEMA', 'sys') -- Exclude system accounts
GROUP BY sp.name, dp.name, dp.type_desc;











