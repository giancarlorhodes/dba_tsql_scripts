


/*
=============================================
AUTHOR: Giancarlo Rhodes
CREATE DATE: 8/26/2024
    SQL Script to Retrieve Database Info
    -----------------------------------------
    This script retrieves the following details 
    for each database on the SQL Server:
    
    1. Database Name
    2. Creation Date (in a readable format)
    3. Database Owner (username)
    4. Owner SID (in decimal format)
    5. Database Size (in MB)
    6. Recovery Model (e.g., FULL, SIMPLE, BULK_LOGGED)
    
    The size is calculated by summing up the size 
    of all files in each database.
=============================================
*/

SELECT 
    d.name AS DatabaseName,
    CONVERT(VARCHAR, create_date, 100) AS CreationDate,
    SUSER_SNAME(owner_sid) AS DatabaseOwner,
    CAST(owner_sid AS BIGINT) AS OwnerSID_Decimal,
    (SUM(size * 8) / 1024) AS DatabaseSizeMB,
    recovery_model_desc AS RecoveryModel
FROM 
    sys.databases d
JOIN 
    sys.master_files f
ON 
    d.database_id = f.database_id
GROUP BY 
    d.name, create_date, owner_sid, recovery_model_desc
ORDER BY 
     (SUM(size * 8) / 1024) desc, d.name;


