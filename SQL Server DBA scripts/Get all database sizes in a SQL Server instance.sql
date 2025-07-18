
--Get all database sizes in a SQL Server instance

/*
The following query retrieves the following information, one record per database:

Database				– the name of the database
DatabaseState			– the state of the database (duh)
DataFiles				– number of data files (.mdf and .ndf)
DataFilesSizeGB			– the total size of the data file(s) in GB
LogFIles				– number of transaction log files (.ldf) – note: 99% of the time there is no valid reason to have more than one transaction log file per database.
LogFileSizeGB			– the total size of the transaction log file(s) in GB
FILESTREAMContainers	– the number of FILESTREAM containers – at the disk level these are actually directories
FSContainersSizeGB		– the total size of the FILESTREAM container(s) in GB
DatabaseSizeGB			– the total size of the database in GB

You might ask yourself “isn’t the internet full of scripts that do the same thing?”, and the answer is “yes, but there’s a catch”.
In this case the catch being that, although there are some great examples out there, the ones I’ve found rely solely on sys.master_files so they end up omitting FILESTREAM container sizes altogether.

Since FILESTREAM size information is not returned by the system-wide view sys.master_files, but by the database-level view sys.database_files, 
I had to use a temp table and populate it via a cursor with the FILESTREAM info for each database with such containers.
*/

/*Make sure temp table doesn't exist*/
IF OBJECT_ID(N'tempdb.dbo.#FSFiles', N'U') IS NOT NULL
    DROP TABLE #FSFiles;
/*Create temp table*/
CREATE TABLE #FSFiles
  (  [DatabaseID]    [SMALLINT] NULL,
     [FSFilesCount]  [INT] NULL,
     [FSFilesSizeGB] [NUMERIC](15, 3) NULL);

/*Cursor to get FILESTREAM files and their sizes for databases that use FS*/
DECLARE @DBName  NVARCHAR(128),
        @ExecSQL NVARCHAR(MAX); 

DECLARE DBsWithFS CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
SELECT DISTINCT DB_NAME(database_id)
FROM   sys.master_files
WHERE  [type] = 2;

OPEN DBsWithFS; 

FETCH NEXT FROM DBsWithFS INTO @DBName;

WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @ExecSQL = N'USE ['+@DBName+N'];
	  INSERT INTO #FSFiles ([DatabaseID],[FSFilesCount],[FSFilesSizeGB])
	  SELECT DB_ID(),
       COUNT([type]),
       CAST(SUM(CAST([size] AS BIGINT) * 8 / 1024.00 / 1024.00) AS NUMERIC(15, 3)) 
       FROM sys.database_files
	   WHERE  [type] = 2
	   GROUP  BY [type];';
      EXEC (@ExecSQL);
      FETCH NEXT FROM DBsWithFS INTO @DBName;
  END;

CLOSE DBsWithFS;
DEALLOCATE DBsWithFS;

/*Return database files and size info*/
SELECT d.[name]                          AS [Database],
       d.[state_desc]                    AS [DatabaseState],
       SUM(CASE
             WHEN f.[type] = 0 THEN 1
             ELSE 0
           END)                          AS [DataFiles],
       CAST(SUM(CASE
                  WHEN f.[type] = 0 THEN (CAST(f.[size] AS BIGINT) * 8 / 1024.00 / 1024.00 )
                  ELSE 0.00
                END) AS NUMERIC(15, 3))  AS [DataFilesSizeGB],
       SUM(CASE
             WHEN f.[type] = 1 THEN 1
             ELSE 0
           END)                          AS [LogFiles],
       CAST(SUM(CASE
                  WHEN f.[type] = 1 THEN (CAST(f.[size] AS BIGINT) * 8 / 1024.00 / 1024.00 )
                  ELSE 0.00
                END) AS NUMERIC(15, 3))  AS [LogFilesSizeGB],
       ISNULL(fs.FSFilesCount, 0)        AS [FILESTREAMContainers],
       ISNULL(fs.FSFilesSizeGB, 0.000)   AS [FSContainersSizeGB],
       CAST(SUM(CAST(f.[size] AS BIGINT) * 8 / 1024.00 / 1024.00) AS NUMERIC(15, 3))
       + ISNULL(fs.FSFilesSizeGB, 0.000) AS [DatabaseSizeGB]
FROM   sys.master_files AS f
       INNER JOIN sys.databases AS d
               ON f.database_id = d.database_id
       LEFT JOIN #FSFiles AS fs
              ON f.database_id = fs.DatabaseID
GROUP  BY d.[name],
          d.[state_desc],
          fs.FSFilesCount,
          fs.FSFilesSizeGB
ORDER BY [DatabaseSizeGB] DESC;
/*Drop temp table*/
IF OBJECT_ID(N'tempdb.dbo.#FSFiles', N'U') IS NOT NULL
    DROP TABLE #FSFiles;

