
--Backup running check
SELECT 
		command, 
		estimated_completion_time,
		total_elapsed_time
FROM sys.dm_exec_requests 
WHERE command = 'BACKUP DATABASE';