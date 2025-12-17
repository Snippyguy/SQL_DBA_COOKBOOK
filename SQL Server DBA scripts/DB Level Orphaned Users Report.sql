/********************************************************************************************
   Query Name  : Orphaned Database Users Report
   Description : 
       This query identifies *orphaned users* in the SQL Server database.
       Orphaned users are database-level principals that do not have a 
       corresponding login at the server level.

       The script checks:
         1. Database users of type SQL user (U), Windows group/user (G)
            whose SID does NOT exist in sys.server_principals.
         2. SQL users (type = 'S') with valid SIDs but without a matching 
            server-level login resolved through SUSER_SNAME(SID).

       Use this to troubleshoot user login issues or after restoring a 
       database from another server.

*********************************************************************************************/
USE [DBA_ADMIN]
GO

SELECT  
       name AS LoginName,
       type_desc AS UserType
FROM    sys.database_principals
WHERE   type IN ('U', 'G')   -- SQL user, Windows user/group
AND     sid NOT IN (SELECT sid FROM sys.server_principals)

UNION ALL

SELECT  
       name AS LoginName,
       type_desc AS UserType
FROM    sys.database_principals
WHERE   type = 'S'           -- SQL user
AND     sid IS NOT NULL
AND     sid <> 0x0           -- Exclude 'dbo' and system accounts
AND     LEN(sid) <= 16       -- Valid SQL user SID length
AND     SUSER_SNAME(sid) IS NULL   -- No matching server login
ORDER BY LoginName;
