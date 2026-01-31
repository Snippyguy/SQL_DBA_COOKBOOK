/*
This script searches through all SQL Server error logs for a specified string.
This script can be especially useful for those who primarily use SSMS or are limited to it for various reasons. 
PowerShell lovers, of course, have the excellent dbatools toolkit and the appropriate module there (Get-DbaErrorLog).

I usually use this script to analyze:
* AG failover issues (part of a larger script)
* Deadlock events (yes, trace flag 1204 is still in use)
* Configuration changes (RAM, CPU), and more

The script uses the following system stored procedures:
* xp_enumerrorlogs - to get the number of error logs
* xp_fileexist - to check whether a log file exists on disk
* sp_readerrorlog - to read the log files

*/

Script:
----------------------------------
SET NOCOUNT ON

DECLARE @logs TABLE (filenum SMALLINT,dt DATETIME,filesize BIGINT)
DECLARE @result TABLE ([DateTime] DATETIME,ProcessInfo VARCHAR(50),[Message] VARCHAR(512))
DECLARE @exists INT
DECLARE @i SMALLINT
DECLARE @file VARCHAR(512)
DECLARE @current VARCHAR(512)
DECLARE @2find NVARCHAR(512)

/*Put the search words here*/
SELECT @2find=N'SQL Server is now ready'

INSERT INTO @logs (filenum,dt,filesize)
EXEC xp_enumerrorlogs

SELECT @i = @@rowcount - 1

SELECT @current = convert(VARCHAR(512), SERVERPROPERTY('ErrorLogFileName'))

WHILE @i >= 0
BEGIN
 SELECT @file = @current + iif(@i > 0, '.' + convert(VARCHAR(10), @i), '')

 EXEC xp_fileexist @file, @exists OUT

 IF @exists = 1
 BEGIN
 BEGIN TRY
 INSERT INTO @result ([DateTime],ProcessInfo,[Message])
 EXEC sp_readerrorlog @i,1,@2find

 IF @@ROWCOUNT > 0
 PRINT @file
 END TRY

 BEGIN CATCH
 PRINT @file
 PRINT ERROR_MESSAGE()
 END CATCH
 END

 SELECT @i -= 1
END

SELECT * FROM @result ORDER BY 1 DESC