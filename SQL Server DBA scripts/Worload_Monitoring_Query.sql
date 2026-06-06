/*=========================================================
  Query Name : Workload Query
  Purpose    : Monitor active workload, waits, blocking,
               CPU consumption, I/O statistics, and
               currently executing SQL statements.
=========================================================*/

SELECT
    DB_NAME(r.database_id) AS DatabaseName,
    r.session_id,
    r.blocking_session_id,
    r.status,
    r.wait_type,
    r.wait_time,
    r.wait_time / 1000.0 AS WaitTimeSec,
    r.wait_resource,
    r.cpu_time,
    r.total_elapsed_time,
    r.total_elapsed_time / 1000.0 AS ElapsedTimeSec,
    r.open_transaction_count,
    r.granted_query_memory,
    r.reads,
    r.logical_reads,
    r.writes,
    qs.query_hash,
    r.sql_handle,
    SUBSTRING
    (
        st.text,
        (r.statement_start_offset / 2) + 1,
        (
            (
                CASE r.statement_end_offset
                    WHEN -1 THEN DATALENGTH(st.text)
                    ELSE r.statement_end_offset
                END
                - r.statement_start_offset
            ) / 2
        ) + 1
    ) AS StatementText,
    GETDATE() AS PollingDateTime
FROM sys.dm_exec_requests r
LEFT JOIN sys.dm_exec_query_stats qs
    ON r.sql_handle = qs.sql_handle
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st
WHERE r.session_id >= 50
ORDER BY r.wait_time DESC;