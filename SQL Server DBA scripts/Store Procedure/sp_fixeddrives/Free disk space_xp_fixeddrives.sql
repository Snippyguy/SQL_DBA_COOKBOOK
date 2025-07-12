--Built-in SQL Server system stored procedure xp_fixeddrives returns a simple list of drive letters and the available free space (in megabytes) on each drive. 
--It's typically used for quick disk space checks.
--It only shows local logical drives (not mount points).
--It does not show total size, volume name, or used space.
--It uses the SQL Server service account’s permissions, so limited access can affect results.
--No parameters are accepted.
--Not created manually — it is compiled into the SQL Server engine.
--Resides in master database, but you cannot see or modify the code.
--It is essentially a wrapper to a native DLL in SQL Server's binary files (like xpsql.dll).

EXEC master..xp_fixeddrives
EXEC xp_fixeddrives

--*******************************************************************************************
--Property						Description
--*******************************************************************************************
--Type							Extended stored procedure
--Database Context				Typically runs from the master database
--Physical Location				Internally implemented in a DLL (e.g., xpsql.dll) loaded by SQL Server
--Object Type (sys.objects)		Does not appear like a regular procedure in sys.objects
--Execution Context				Can be executed from any database, but usually from master
--Permissions					Requires membership in the sysadmin fixed server role
--Visibility					You can find a reference in master.sys.all_objects, but not source code