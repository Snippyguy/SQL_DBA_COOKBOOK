/********************************************************************************************
   Script Name : Fix SQL Server DNS / Hostname Mismatch (Server Rename)
   Description :
       This script resolves issues where SQL Server's internal server name (@@SERVERNAME)
       does not match the actual machine name or DNS hostname.

       Common symptoms:
         - @@SERVERNAME is NULL or incorrect
         - Linked server failures
         - SQL Agent job failures
         - Replication / AlwaysOn errors after VM rename
         - Hostname mismatch after server migration or cloning

       Steps performed:
         1. Check current server name & machine name
         2. Drop incorrect server entry using sp_dropserver
         3. Add correct server name using sp_addserver with 'local'
         4. Restart SQL Server service for changes to take effect

*********************************************************************************************/

-- Step 1: Check current server name, machine name, and hostname
SELECT @@SERVERNAME AS Current_ServerName;
SELECT SERVERPROPERTY('MachineName') AS MachineName;
SELECT HOST_NAME() AS ClientHostName;

-- Step 2: Drop the incorrect server name (use the value returned by @@SERVERNAME)
-- Example:
-- EXEC sp_dropserver 'OLD_SERVER_NAME';

-- Step 3: Add the correct machine name (use MachineName value)
-- Example:
-- EXEC sp_addserver 'CORRECT_MACHINE_NAME', 'local';

-- Step 4: Restart SQL Server Service manually
--          After restart, verify with:
-- SELECT @@SERVERNAME;
