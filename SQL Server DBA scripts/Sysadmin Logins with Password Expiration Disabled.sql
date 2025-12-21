/********************************************************************************************
   Query Name  : Sysadmin Logins with Password Expiration Disabled
   Description : 
       This query returns all SQL Server logins that:
         - Are members of the SYSADMIN fixed server role.
         - Have "Enforce password expiration" DISABLED.

       This helps identify high-privilege accounts that do not follow 
       password rotation policies, which can pose security risks.
*********************************************************************************************/

SELECT  
       sp.name AS LoginName
FROM    sys.sql_logins AS sl
JOIN    sys.server_principals AS sp 
       ON sl.principal_id = sp.principal_id
WHERE   sl.is_expiration_checked = 0     -- Password expiration disabled
AND     IS_SRVROLEMEMBER('sysadmin', sp.name) = 1;
