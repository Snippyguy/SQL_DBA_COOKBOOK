/***************************************************************************************************************************************
Code Description	 : SQL Server Up Time (Use Method 1 or 6 for accurate result)													   *
Author Name		 	 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		     	 : www.snippyguy.com																							   *
LinkedIn			 : https://www.linkedin.com/in/snippyguy/																		   *																						
GitHub				 : https://github.com/Snippyguy																					   *
Tableau Public		 : https://public.tableau.com/app/profile/snippyguy/vizzes														   * 
License			 	 : MIT, CC0																										   *
Creation Date		 : 03/09/2025																									   *
Last Modified By 	 : 03/09/2025																									   *
Last Modification	 : Initial Creation  																							   *
Modification History : 	 																											   *
***************************************************************************************************************************************/

/***************************************************************************************************************************************
*                                                Copyright (C) 2025 Sayan Dey														   *
*                                                All rights reserved. 																   *
* 																																	   *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files     *
* (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do   *
* so, subject to the following conditions:																							   *
*																																	   *
*																																	   *
* You may alter this code for your own * Commercial* & *non-commercial* purposes. 													   *
* You may republish altered code as long as you include this copyright and give due credit. 										   *
* 																																	   *
* 																																	   *
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.	   *
*																																	   *
*																																	   *
* THE SOFTWARE (CODE AND INFORMATION) IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED *
* TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 		   *
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.										   *
*																																	   *
* 																																	   *
***************************************************************************************************************************************/

--------------------------------------------------------
-- Method 1: Using sys.dm_os_sys_info (SQL 2008+)
--------------------------------------------------------
--In the SQL Server 2008 and later versions, we can use Sys.dm_os_sys_info DMV to get the SQL Server uptime.
USE master
GO

SELECT 
        @@SERVERNAME AS ServerName,
        sqlserver_start_time AS [SQL Server Start Time],
        DATEDIFF(DAY, sqlserver_start_time, SYSDATETIME()) AS [Uptime (Days)],
        DATEDIFF(MINUTE, sqlserver_start_time, SYSDATETIME()) / 60 % 24 AS [Uptime (Hours)],
        DATEDIFF(SECOND, sqlserver_start_time, SYSDATETIME()) / 60 % 60 AS [Uptime (Minutes)]
FROM sys.dm_os_sys_info;
GO

SELECT 
        sqlserver_start_time AS server_start_time,
        GETDATE() as currdate,
        DATEDIFF(SECOND, sqlserver_start_time, GETDATE()) AS uptime_in_seconds,
        DATEDIFF(MINUTE, sqlserver_start_time, GETDATE()) as uptime_in_minutes,
        FORMAT(DATEDIFF(SECOND, sqlserver_start_time, GETDATE()) / 86400.0, 'N2') AS uptime_in_days FROM
(
    SELECT sqlserver_start_time FROM sys.dm_os_sys_info
) derived;


--------------------------------------------------------
-- Method 2: Using sys.dm_exec_sessions (session_id = 1)
--------------------------------------------------------
-- Uptime in Minutes
--Sometimes resets, so not always reliable.
USE master
GO

SELECT 
        @@SERVERNAME AS ServerName,
        login_time AS [SQL Server Start Time],
        DATEDIFF(MINUTE, login_time, GETDATE()) AS SQLServer_UpTime_Minutes
FROM sys.dm_exec_sessions
WHERE session_id = 1;

-- SQL Server Startup Date/Time
SELECT 
    @@SERVERNAME AS ServerName,
    login_time AS StartUp_DateTime
FROM sys.dm_exec_sessions
WHERE session_id = 1;
GO

-- Uptime as datetime difference (base 1900-01-01)
SELECT 
    @@SERVERNAME AS ServerName,
    GETDATE() - login_time AS SQLServer_UpDateTime_1900_01_01
FROM sys.dm_exec_sessions
WHERE session_id = 1;
GO

-- Uptime in Years, Months, Days, Time
SELECT 
    @@SERVERNAME AS ServerName,
    YEAR(SQLServer_UpTime) - 1900 
        - CASE WHEN MONTH(SQLServer_UpTime) - 1 
                 - CASE WHEN DAY(SQLServer_UpTime) - 1 < 0 THEN 1 ELSE 0 END < 0 
               THEN 1 ELSE 0 END AS Years,
    MONTH(SQLServer_UpTime) - 1 
        - CASE WHEN DAY(SQLServer_UpTime) - 1 < 0 THEN 1 ELSE 0 END AS Months,
    DAY(SQLServer_UpTime) - 1 AS Days,
    SUBSTRING(CONVERT(VARCHAR(25), SQLServer_UpTime, 121), 12, 8) AS Timepart
FROM (
    SELECT 
        GETDATE() - login_time AS SQLServer_UpTime -- starts from 1900-01-01
    FROM sys.dm_exec_sessions
    WHERE session_id = 1
) a;
GO

--------------------------------------------------------
-- Method 3: Uptime in Years, Months, Days, Hours, Minutes
--------------------------------------------------------
SELECT 
    @@SERVERNAME AS ServerName,
    SQLServer_UpTime_YY,
    SQLServer_UpTime_MM,
    SQLServer_UpTime_DD,
    (SQLServer_UpTime_mi % 1440) / 60 AS NoHours,
    (SQLServer_UpTime_mi % 60) AS NoMinutes
FROM (
    SELECT 
        DATEDIFF(YEAR, login_time, GETDATE()) AS SQLServer_UpTime_YY,
        DATEDIFF(MONTH, DATEADD(YEAR, DATEDIFF(YEAR, login_time, GETDATE()), login_time), GETDATE()) AS SQLServer_UpTime_MM,
        DATEDIFF(DAY, DATEADD(MONTH, DATEDIFF(MONTH, DATEADD(YEAR, DATEDIFF(YEAR, login_time, GETDATE()), login_time), GETDATE()), login_time), GETDATE()) AS SQLServer_UpTime_DD,
        DATEDIFF(MINUTE, login_time, GETDATE()) AS SQLServer_UpTime_mi
    FROM sys.dm_exec_sessions
    WHERE session_id = 1
) a;
GO

--------------------------------------------------------
-- Method 4: Using tempdb create_date
--------------------------------------------------------
--This method is not accurate because the user databases and system databases initialize before the TempDB database initializes during the startup process. 
--Sometimes, the user databases and system databases take longer to initialize, so the initialization time of TempDB depends on the time taken to initialize other databases.
USE master
GO

SELECT 
    @@SERVERNAME AS ServerName,
    create_date AS [SQL Server Start Time],
    GETDATE()   AS [Current DateTime],
    RIGHT('0' + CAST(DATEDIFF(SECOND, create_date, GETDATE()) / 3600 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((DATEDIFF(SECOND, create_date, GETDATE()) % 3600) / 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST(DATEDIFF(SECOND, create_date, GETDATE()) % 60 AS VARCHAR), 2) AS [Uptime (HH:MM:SS)]
FROM sys.databases
WHERE name = 'tempdb'; --TempDB is a system database which recreates after each SQL server restart using modelDB template
GO

--------------------------------------------------------
-- Method 5: Using sys.dm_io_virtual_file_stats (sample_ms)
-- Provides Approximate Uptime
--------------------------------------------------------
;WITH cteServerUpTimeInfo AS (
    SELECT 
        dm.sample_ms / 1000.00 AS server_up_time_sec,
        (dm.sample_ms / 1000.00) / 60.00 AS server_up_time_min,
        ((dm.sample_ms / 1000.00) / 60.00) / 60.00 AS server_up_time_hr,
        (((dm.sample_ms / 1000.00) / 60.00) / 60.00) / 24.00 AS server_up_time_day
    FROM sys.dm_io_virtual_file_stats(1,1) AS dm
)
SELECT 
    CAST(server_up_time_min AS DECIMAL(12,2)) AS server_up_time_min,
    CAST(server_up_time_hr AS DECIMAL(12,2))  AS server_up_time_hr,
    CAST(server_up_time_day AS DECIMAL(12,2)) AS server_up_time_day,
    CAST(DATEADD(SECOND, -server_up_time_sec, GETDATE()) AS SMALLDATETIME) AS approx_server_start_datetime,
    CAST(DATEADD(SECOND, -server_up_time_sec, GETUTCDATE()) AS SMALLDATETIME) AS approx_server_start_utc_datetime
FROM cteServerUpTimeInfo;
GO

--------------------------------------------------------
-- Method 6: Using xp_ReadErrorLog (Accurate Method)
--------------------------------------------------------
USE master
GO

EXEC xp_ReadErrorLog 0, 1, N'SQL',N'Starting' 

--------------------------------------------------------
-- Method 7: Using sys.sysprocesses
--Not reliable
--------------------------------------------------------
--In sys.sysprocesses, SPID 1 corresponds to the lazy writer system process.
--Its login_time does not always reflect when SQL Server started — sometimes it refreshes/re-registers, so you see a changing "Started" timestamp.
--That's why your Started column isn't stable.
USE master
GO

SELECT  login_time AS 'Started', 
        DATEDIFF(DAY, login_time, CURRENT_TIMESTAMP) AS 'Uptime in days'
FROM sys.sysprocesses
WHERE spid = 1;
Go

SELECT MIN(login_time) as LastServerRestart1, MIN(last_batch) as LastServerRestart2 
FROM sys.sysprocesses