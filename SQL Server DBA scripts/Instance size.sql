--Instance size

SELECT 
		CONVERT (DECIMAL (10,2), (SUM(size * 8.00)/1824.00/1024.00 /1024.00)) As UsedSpaceTB 
FROM master.sys.master_files;