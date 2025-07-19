
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