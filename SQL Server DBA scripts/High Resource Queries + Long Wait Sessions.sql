/********************************************************************************************
   Script Name : High Resource Queries + Long Wait Sessions
   Description :
       This script contains two parts:

       1) High Average Resource Queries
          ----------------------------------------
          Shows queries with high average elapsed time, CPU time, wait time,
          logical reads and writes. Helps identify expensive queries.

       2) Long-Wait Active Sessions
          ----------------------------------------
          Shows current sessions waiting longer than 500 ms.

*********************************************************************************************/


/********************************************************************************************
   PART 1 : High Average CPU / Elapsed / Wait Queries
*********************************************************************************************/

SELECT  
      t.text AS QueryText,
      qs.total_elapsed_time / qs.execution_count        AS Avg_Elapsed_Time_ms,
      qs.total_worker_time / qs.execution_count         AS Avg_CPU_Time_ms,
      (qs.total_elapsed_time - qs.total_worker_time) 
            / qs.execution_count                        AS Avg_Wait_Time_ms,
      qs.total_logical_reads / qs.execution_count       AS Avg_Logical_Reads,
      qs.total_logical_writes / qs.execution_count      AS Avg_Writes,
      qs.total_elapsed_time                             AS Cumulative_Elapsed_Time_ms,
      qs.execution_count                                AS ExecutionCount
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS t
WHERE 
      (qs.total_elapsed_time - qs.total_worker_time) * 1.0 
      / qs.total_elapsed_time   > 0.2          -- > 20% wait contribution
ORDER BY 
      qs.total_elapsed_time / qs.execution_count DESC;


 /********************************************************************************************
    PART 2 : Sessions Waiting Over 500 ms
*********************************************************************************************/

SELECT  
      r.session_id,
      r.wait_type,
      r.wait_time AS Wait_Time_ms,
      r.status,
      s.login_name,
      DB_NAME(r.database_id) AS DatabaseName
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s 
      ON r.session_id = s.session_id
WHERE 
      r.wait_time > 500     -- waits longer than 0.5 seconds
      AND s.is_user_process = 1
ORDER BY r.wait_time DESC;
