--Monitoring what user sessions are connected using specific applications (e.g., with "Information" in name).
--Understanding how many sessions are sleeping vs. active.
--Troubleshooting session bloat or identifying client machines contributing high session counts.
SELECT
		host_name	AS HostName,
		status		AS Status,
		COUNT(*)	AS StatusCount
FROM sys.dm_exec_sessions
WHERE is_user_process = 1
AND program_name LIKE '%Information%'
GROUP BY
		host_name,
		status
ORDER BY 3 DESC
