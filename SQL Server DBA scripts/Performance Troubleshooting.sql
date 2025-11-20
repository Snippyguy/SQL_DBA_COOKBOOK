--Performance Troubleshooting

--Find the Most Expensive Queries (Top Resource Consumers)
SELECT TOP 10 
    qs.total_elapsed_time / qs.execution_count AS [AvgExecTime],
    qs.execution_count,
    qs.total_logical_reads,
    qs.total_worker_time / qs.execution_count AS [AvgCPUTime],
    SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(qt.text)
          ELSE qs.statement_end_offset END
          - qs.statement_start_offset)/2)+1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY [AvgExecTime] DESC;

--Check Current Blocking Sessions
SELECT 
    blocking_session_id AS Blocker,
    session_id AS Blocked,
    wait_type, wait_time, wait_resource,
    DB_NAME(database_id) AS DatabaseName,
    TEXT AS BlockedQuery
FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE blocking_session_id <> 0;

--Identify Queries Currently Running
SELECT 
    r.session_id, 
    r.status, 
    r.command, 
    t.text AS QueryText,
    r.cpu_time, 
    r.total_elapsed_time,
    DB_NAME(r.database_id) AS DatabaseName
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
ORDER BY r.total_elapsed_time DESC;

--Detect Missing Indexes
SELECT 
    mid.statement AS TableName,
    migs.avg_total_user_cost * migs.avg_user_impact AS ImprovementPotential,
    'CREATE INDEX IX_' + OBJECT_NAME(mid.object_id) + '_' + 
    REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns,''),', ','_'),'[',''),']','') + 
    ' ON ' + mid.statement + 
    '(' + ISNULL(mid.equality_columns,'') + 
    CASE WHEN mid.inequality_columns IS NULL THEN '' ELSE ',' + mid.inequality_columns END + ')' +
    ISNULL(' INCLUDE (' + mid.included_columns + ')','') AS CreateIndexStatement
FROM sys.dm_db_missing_index_groups mig
JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
ORDER BY ImprovementPotential DESC;

--Find Queries with High I/O Reads
SELECT TOP 10 
    (total_logical_reads + total_physical_reads) / execution_count AS AvgReads,
    execution_count,
    total_logical_reads, 
    total_physical_reads,
    SUBSTRING(qt.text, qs.statement_start_offset/2,
        (CASE WHEN qs.statement_end_offset = -1 THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
         ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY AvgReads DESC;

--Check CPU Usage by Queries
SELECT TOP 10 
    total_worker_time/1000 AS TotalCPUms,
    execution_count,
    (total_worker_time/execution_count)/1000 AS AvgCPUms,
    SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(qt.text)
          ELSE qs.statement_end_offset END
          - qs.statement_start_offset)/2)+1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY AvgCPUms DESC;

--Check SQL Server Wait Types
SELECT 
    wait_type, 
    waiting_tasks_count AS WaitCount,
    wait_time_ms / 1000 AS WaitTimeSec,
    (wait_time_ms / waiting_tasks_count) AS AvgWaitMs
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    'SLEEP_TASK','BROKER_EVENTHANDLER','SQLTRACE_BUFFER_FLUSH','LAZYWRITER_SLEEP',
    'XE_DISPATCHER_WAIT','FT_IFTS_SCHEDULER_IDLE_WAIT','BROKER_TO_FLUSH')
AND waiting_tasks_count>0
ORDER BY WaitTimeSec DESC;

--Find Long-Running Jobs in SQL Agent
SELECT 
    sj.name AS JobName,
    run_status = CASE h.run_status 
        WHEN 0 THEN 'Failed' 
        WHEN 1 THEN 'Succeeded' 
        WHEN 2 THEN 'Retry' 
        WHEN 3 THEN 'Cancelled' 
        ELSE 'Unknown' END,
    msdb.dbo.agent_datetime(run_date, run_time) AS RunDateTime,
    (run_duration/10000*3600 + (run_duration%10000)/100*60 + run_duration%100) AS DurationSeconds
FROM msdb.dbo.sysjobs sj
JOIN msdb.dbo.sysjobhistory h ON sj.job_id = h.job_id
WHERE h.run_date >= CONVERT(INT, CONVERT(VARCHAR, GETDATE(), 112))
ORDER BY DurationSeconds DESC;

--Monitor TempDB Usage
SELECT 
    SUM(user_object_reserved_page_count)*8 AS UserObjectsKB,
    SUM(internal_object_reserved_page_count)*8 AS InternalObjectsKB,
    SUM(version_store_reserved_page_count)*8 AS VersionStoreKB,
    SUM(unallocated_extent_page_count)*8 AS FreeSpaceKB
FROM sys.dm_db_file_space_usage;

--Identify Missing or Stale Statistics.
SELECT 
    OBJECT_NAME(s.object_id) AS TableName,
    s.name AS StatName,
    STATS_DATE(s.object_id, s.stats_id) AS LastUpdated,
    sp.rows AS Row_Count
FROM sys.stats s
JOIN sys.sysindexes sp ON s.object_id = sp.id
WHERE STATS_DATE(s.object_id, s.stats_id) < DATEADD(day, -7, GETDATE())
ORDER BY LastUpdated;

--We should update tables stats regularly. For updating tables statistics, we can use the below SQL query.
--EXEC sp_updatestats;

--Monitor SQL Server Memory Usage
SELECT 
    physical_memory_in_use_kb/1024 AS SQLMemoryMB,
    locked_page_allocations_kb/1024 AS LockedPagesMB,
    total_virtual_address_space_kb/1024 AS TotalVASMB,
    process_physical_memory_low, 
    process_virtual_memory_low
FROM sys.dm_os_process_memory;