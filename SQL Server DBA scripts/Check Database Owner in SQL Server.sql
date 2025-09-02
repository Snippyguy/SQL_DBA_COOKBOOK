
--Check Database Owner in SQL Server

/*
Many times, while working with SQL Server, we need to identify who owns a database.
This is important for security, access management, and troubleshooting permission issues.

This method helps:
	1. DBAs validate ownership for audits 
	2. Developers ensure correct access mapping 
	3. Teams troubleshoot login/permission mismatches 
*/

--SELECT SUSER_SNAME(owner_sid) AS DatabaseOwner
--FROM sys.databases
--WHERE name = DB_NAME();

SELECT 
    name AS DatabaseName,
    FORMAT(create_date, 'dd MMMM yyyy hh:mm:ss tt') AS CreationDate,
    SUSER_SNAME(owner_sid) AS DatabaseOwner
FROM sys.databases
ORDER BY create_date;
