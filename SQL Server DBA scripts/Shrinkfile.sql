-- How do I shrink my database?
--Luckily, there's also a really common answer: Don't.

--but what if you really have to?
--Perhaps you just implemented data compression, and have 60% free space in your database.
--Perhaps you just deleted a bunch of old data, and have significant free space in your database.
--There are a handful of scenarios where you have free space in the database, you'll never use it, and you need to shrink. Just don't make a habit of it.

--Steps
--Step 0) Don't shrink
--Step 1) Look at file size

SELECT
     LogicalName = dbf.name
    ,FileType = dbf.type_desc
    ,FilegroupName = fg.name
    ,PhysicalFileLocation = dbf.physical_name
    ,FileSizeMB = CONVERT(DECIMAL(10,2),dbf.size/128.0)
    ,UsedSpaceMB = CONVERT(DECIMAL(10,2),dbf.size/128.0 - ((dbf.size/128.0)
               - CAST(FILEPROPERTY(dbf.name, 'SPACEUSED') AS INT) /128.0))
    ,FreeSpaceMB = CONVERT(DECIMAL(10,2),dbf.size/128.0
           - CAST(FILEPROPERTY(dbf.name, 'SPACEUSED') AS INT)/128.0)
FROM sys.database_files dbf
LEFT JOIN sys.filegroups fg ON dbf.data_space_id = fg.data_space_id
ORDER BY dbf.type DESC, dbf.name;

--If you look at the FreeSpaceMB column in your results, that is the amount of unused space you might potentially be able to reclaim. If it's significant, you might decide to move on and shrink the files.
--Keep in mind that you want set all files for a given filegroup at the same size. When you let file sizes within a filegroup get out of alignment, SQL's proportional fill algorithm won't spread IO evenly across files.

--Step 2) Consider the side effects

--If you shrink the data file, any data located at the *end* of the file needs to be related elsewhere in the file. These operations are logged, so you're going to generate a lot of transaction log usage. Make sure your transaction log is big enough, and make sure you are running transaction log backups frequently enough.
--If your database is being mirrored, or is in an Availability Group, or is log shipping, you might find that your secondary server(s) fall behind during this operation.
--Shrinking is going to create a lot of fragmentation. Depending on your workload, you might have a performance impact during the process.
--Shrinking generates a bunch of IO. If you are already seeing IO issues, that might be exacerbated by shrinking, and you might have performance impact during the process.
--Shrinking is a mostly online process, where data is moved page-by-page to the *front* of the file so that the end of the file can be truncated. I say mostly online because its possible for this operation to cause blocking. I've seen this particularly often in the PRIMARY filegroup. Because of the possibility of this causing blocking, I never let it run unattended, and never during peak business hours.

--Step 3) Shrink files

USE [DatabaseName];
DBCC SHRINKFILE(LogicalName, TargetSize);

--I always use DBCC SHRINKFILE(BOL) when I shrink, never DBCC SHRINKDATABASE. If I am going to shrink a file, I want as much control over the process as possible.
--Using the output from the above SELECT, figure out what you want to use for a target size on your database You'll want to leave some free space in your data file, otherwise it's just going to grow bigger right away.

--Step 4) Review fragmentation
--Congratulations, you've successfully created a ton of physical fragmentation. I know some shops run applications where fragmentation just doesn't cause any problems. If you're one of those shops, then you're done't stop reading.
--If fragmentation does affect your performance, then you already have a regularly scheduled index maintenance job. After shrinking the data file, run that regular index maintenance job to get things squared away.

--Consideration
--Remember: Even if you're running Standard Edition, REORGANIZE is an online operation. Better yet, if you kill it you won't lose your work, it will pick up where it left off the next time.
--You can use DBCC SHRINKFILE and REORGANIZE to do this completely online. If the shrink causes massive fragmentation that impacts production, you can shrink/reorganize/shrink/reorganize in smaller chunks. This will take a really, really long time. But that's a trade-off. There are faster methods, but those will likely involve varying amounts of downtime.
--The easiest solution is to just leave the database half-full and accept that you're using more disk space than you need to. Not shrinking your database at all is always an online operation.

--*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~**~~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~**~~*~*~*~*~*~*~*
--**The method I like to recommend is as follows:
--Create a new filegroup
--Move all affected tables and indexes into the new filegroup using the CREATE INDEX WITH (DROP_EXISTING = ON) ON syntax, to move the tables and remove fragmentation from them at the same time
--Drop the old filegroup that you were going to shrink anyway (or shrink it way down if its the primary filegroup)
--Basically you need to provision some more space before you can shrink the old files, but it's a much cleaner mechanism. Beware that if a table has off-row LOB data, rebuilding will NOT move the LOB data to the new filegroup and there's no good way to do that.
--*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~**~~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~**~~*~*~*~*~*~*~*

--shrink in smaller chunks
USE MYDB						--Put DB Name here
DECLARE @PRNSTR NVARCHAR(MAX)	--Print String
DECLARE @SQLSTR NVARCHAR(MAX)	--SQL Command
DECLARE @FILEID NVARCHAR(MAX)	--FileID to be shrunk
DECLARE @CURSIZE BIGINT			--Current Size
DECLARE @TARSIZE BIGINT			--Target Size
DECLARE @CHNSIZE BIGINT			--Chunk Size
DECLARE @I INT					--Loop Counter


SET @FILEID  ='1'				--Set FileID		N''DB_Data''
SET @CURSIZE =59500				--Set Current Size
SET @TARSIZE =58000				--Set Target Size
SET @CHNSIZE =500				--Set Chunk Size
SET @I       =1
SET @CURSIZE = @CURSIZE-@CHNSIZE
SET @PRNSTR  = 'Shrinking Process Begins for File ID : ' + @FILEID
RAISERROR(@PRNSTR,0,1) WITH NOWAIT
PRINT '*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~**~~*~*~*~*~*~*~*'

WHILE @CURSIZE>=@TARSIZE
		BEGIN
				SET @PRNSTR = 'Loop : '+ CONVERT(NVARCHAR(2),@I)+CHAR(13)+CONVERT(NVARCHAR(MAX),GETDATE(),109) 
				RAISERROR(@PRNSTR,0,1) WITH NOWAIT
				SET @SQLSTR = 'DBCC SHRINKFILE ('+@FILEID+' , '+CONVERT(VARCHAR(MAX),@CURSIZE)+')'
				RAISERROR (@SQLSTR,0,1) WITH NOWAIT
				EXEC SP_EXECUTESQL @STATEMENT= @SQLSTR
				SET @PRNSTR = 'Shrunk till now : ' +convert(nvarchar(max),(@i*@CHNSIZE))+' MB'
				RAISERROR(@PRNSTR,0,1) WITH NOWAIT 
				SET @PRNSTR = '*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~**~~*~*~*~*~*~*~*'
				RAISERROR(@PRNSTR,0,1) WITH NOWAIT
				SET @CURSIZE = @CURSIZE-@CHNSIZE
				SET @I = @I+1
		END
PRINT 'Shrinking Completed for given range size. '

--DB File Details--
SELECT 
		DB_NAME (db_id()) as dbname, 
		FILEGROUP_NAME (groupid) as File_Group_Name, 
		Name as Logical_File_Name,
		FILEID, 
		FileName as File_Path,
		CONVERT (Decimal(15,2), ROUND (a.Size/128.000,2)) [Currently Allocated Space (MB)],
		--CONVERT (Decimal(15,2), ROUND (a.Size/128.000,2)/1024) [Currently Allocated Space (GB)],
		CONVERT (Decimal(15,2), ROUND (FILEPROPERTY(a.Name, 'SpaceUsed')/128.000,2)) AS [Space Used (MB)],
		--CONVERT (Decimal(15,2), ROUND (FILEPROPERTY(a.Name, 'SpaceUsed')/128.000,2)/1024) AS [Space Used (GB)],
		CONVERT (Decimal(15,2), ROUND ((a.Size - FILEPROPERTY(a.Name, 'SpaceUsed'))/128.000,2)) AS [Available Space (MB)],
		--CONVERT (Decimal(15,2), ROUND ((a.Size - FILEPROPERTY(a.Name, 'SpaceUsed'))/128.000,2)/1024) AS [Available Space (GB)],
		CONVERT (Decimal(15,2), ((ROUND (FILEPROPERTY(a.Name, 'SpaceUsed')/128.000,2) / ROUND (a.Size/128.000,2)))) *100 as Used_Pct, 
		CONVERT (Decimal(15,2), ((ROUND ((a.Size-FILEPROPERTY (a.Name, 'SpaceUsed'))/128.000,2) / ROUND(a.Size/128.000,2)))) *100 as Free_Pct,
		CONVERT (Decimal(15,2), (ROUND(a.Size/128.000, 2)/100*20)/1024) as [20% Threshold_size]
FROM dbo.sysfiles a (NOLOCK)

--Space Check--
SELECT
		DISTINCT Volume_mount_point,
		left (volume_mount_point,1) [Disk Mount Point],
		file_system_type [File System Type],
		logical_volume_name as [Logical Drive Name],
		CONVERT (DECIMAL(18,2), total_bytes/1073741824.0) AS [Total Size in GB], --1GB = 1073741824 bytes
		CONVERT (DECIMAL(18,2), available_bytes/1073741824.0) AS [Available Size in GB],
		CONVERT (DECIMAL(18,2), (total_bytes - available_bytes)/1073741824.0) AS [Used Size in GB],
		CAST(CAST(available_bytes AS FLOAT)/ CAST(total_bytes AS FLOAT) AS DECIMAL (18,2)) * 100 AS [Space Free %]
FROM sys.master_files
CROSS APPLY sys.dm_os_volume_stats (database_id, file_id)
where CAST(CAST(available_bytes AS FLOAT)/ CAST (total_bytes AS FLOAT) AS DECIMAL (18,2)) * 100 <15
order by [Disk Mount Point]