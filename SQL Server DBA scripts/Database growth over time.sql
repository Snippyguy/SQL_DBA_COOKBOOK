
--script that helps visualize database growth over time.

declare @db sysname = N'DBA';
WITH t1
		AS (
			SELECT row_number() OVER (
										PARTITION BY bs.database_name ORDER BY bs.database_name
										,CONVERT(VARCHAR(20), bs.backup_start_date, 112)
									) [id]
					,bs.database_name
					,CONVERT(VARCHAR(20), bs.backup_start_date, 106) [dt]
					,sum(bf.file_size / 1024 / 1024) [DBSizeMB]
					,sum(iif(bf.file_type = 'D', bf.file_size, 0)) / 1024. / 1024. [DataMB]
					,sum(iif(bf.file_type = 'L', bf.file_size, 0)) / 1024. / 1024. [LogMB]
					,max(bs.backup_set_id) [bsid]
					,bs.type
			FROM msdb..backupset bs
			JOIN msdb..backupfile bf ON bs.backup_set_id = bf.backup_set_id
			WHERE bs.database_name = @db
			GROUP BY bs.backup_start_date
			,bs.backup_set_id
			,bs.database_name
			,bs.type
			)
SELECT 
		t1.database_name [Database]
		,t1.dt + ' - ' + t2.dt [Period]
		,t1.type + ' - ' + t2.type [Backups]
		,convert(NUMERIC(10, 1), t2.DBSizeMB - t1.DBSizeMB) [DBGrowthMB]
		,convert(NUMERIC(10, 1), t2.DataMB - t1.DataMB) [DataFileGrowthMB]
		,convert(NUMERIC(10, 1), t2.LogMB - t1.LogMB) [LogFileGrowthMB]
		,convert(NUMERIC(10, 1), t1.DBSizeMB) [FirstSize]
		,convert(NUMERIC(10, 1), t2.DBSizeMB) [LastSize]
FROM t1
JOIN t1 t2 ON t1.database_name = t2.database_name
AND t1.id + 1 = t2.id
WHERE t2.DBSizeMB - t1.DBSizeMB <> 0
ORDER BY t1.bsid DESC

/*
It uses data from the "msdb.dbo.backupfile" table, where SQL Server stores information about a database's data and log files at the time each backup is taken.
To use this script, you just need to have regular backups configured for your databases.

Note: 
- zero resultset means that db files are not growing
- negative growth means a decrease of file size (shrink?)
*/