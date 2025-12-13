/********************************************************************************************
   Query Name  : SQL Server Workload / Active Requests Monitoring
   Description :
       This query returns active workloads currently executing on SQL Server.
       It includes:
         - CPU time
         - Elapsed time
         - Wait type, wait time, wait resource
         - Blocking information
         - Query text (exact statement running)
         - Memory grants
         - IO statistics
         - Hash, sql_handle, and other useful metadata

       Use this query during performance troubleshooting to identify slow queries,
       blocking chains, long-running sessions, and high CPU consumers.
*********************************************************************************************/

SELECT  
       DB_NAME(req.database_id) AS DatabaseName,
       req.cpu_time AS CPU_Time_MS,
       req.total_elapsed_time AS Total_Elapsed_Time_MS,
       req.total_elapsed_time / 1000.0 AS TotalElapsedTime_Seconds,
       req.wait_time / 1000.0 AS WaitTime_Seconds,
       req.session_id,
       req.blocking_session_id,
       req.status,
       req.wait_type,
       req.wait_time,
       req.wait_resource,
       SUBSTRING(
           st.text,
           (qs.statement_start_offset/2) + 1,
           (
               CASE 
                   WHEN qs.statement_end_offset = -1 
                        THEN DATALENGTH(st.text)
                   ELSE (qs.statement_end_offset - qs.statement_start_offset)/2
               END
           ) + 1
       ) AS StatementText,
       GETDATE() AS PollingDateTime,
       s.open_transaction_count,
       qs.query_hash,
       req.sql_handle,
       req.granted_query_memory,
       req.reads,
       req.logical_reads,
       req.writes,
       req.cpu_time AS CPU_Time_Total
FROM sys.dm_exec_requests AS req
LEFT JOIN sys.dm_exec_query_stats AS qs 
       ON req.sql_handle = qs.sql_handle
LEFT JOIN sys.dm_exec_sessions AS s
       ON req.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS st
WHERE req.session_id >= 50   -- Exclude system sessions
ORDER BY req.wait_time DESC;

