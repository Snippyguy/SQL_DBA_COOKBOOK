/*=========================================================
  Query Name : I/O Monitoring
  Purpose    : Monitor disk I/O performance, file latency,
               throughput, and identify storage bottlenecks
               at the database file level.

Average             Latency	Storage Health
< 5 ms	            Excellent
5 - 10 ms	        Very Good
10 - 20 ms	        Acceptable
20 - 50 ms	        Performance Concern
> 50 ms	            Critical Investigation Required
=========================================================*/

SELECT
    DB_NAME(vfs.database_id) AS DatabaseName,
    mf.physical_name,
    mf.type_desc AS FileType,

    vfs.num_of_reads,
    vfs.num_of_writes,

    -- Average Read Latency (ms)
    CASE
        WHEN vfs.num_of_reads = 0 THEN 0
        ELSE vfs.io_stall_read_ms / vfs.num_of_reads
    END AS AvgReadLatencyMs,

    -- Average Write Latency (ms)
    CASE
        WHEN vfs.num_of_writes = 0 THEN 0
        ELSE vfs.io_stall_write_ms / vfs.num_of_writes
    END AS AvgWriteLatencyMs,

    -- Average Overall Latency (ms)
    CASE
        WHEN (vfs.num_of_reads + vfs.num_of_writes) = 0 THEN 0
        ELSE vfs.io_stall /
             (vfs.num_of_reads + vfs.num_of_writes)
    END AS AvgTotalLatencyMs,

    -- Throughput (MB)
    CAST
    (
        vfs.num_of_bytes_read / 1048576.0
        AS DECIMAL(18,2)
    ) AS TotalMBRead,

    CAST
    (
        vfs.num_of_bytes_written / 1048576.0
        AS DECIMAL(18,2)
    ) AS TotalMBWritten,

    vfs.io_stall_read_ms,
    vfs.io_stall_write_ms,
    vfs.io_stall AS TotalIOStallMs

FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
INNER JOIN sys.master_files AS mf
    ON vfs.database_id = mf.database_id
   AND vfs.file_id = mf.file_id

ORDER BY AvgTotalLatencyMs DESC;
GO

/*
This version also shows file size and file type for better troubleshooting:

Useful DBA Thresholds
Data files (.mdf/.ndf): Read latency should generally be below 20 ms.
Log files (.ldf): Write latency should ideally be below 5 ms.
Sustained log write latency above 20 ms can impact:
OLTP performance
Availability Groups
Log Shipping
Replication
Backup operations

This query is commonly used during investigations of high I/O waits such as PAGEIOLATCH_*, WRITELOG, IO_COMPLETION, and ASYNC_IO_COMPLETION.
*/

SELECT
    DB_NAME(vfs.database_id) AS DatabaseName,
    mf.name AS LogicalFileName,
    mf.physical_name,
    mf.type_desc AS FileType,

    CAST(mf.size * 8.0 / 1024 AS DECIMAL(18,2)) AS FileSizeMB,

    vfs.num_of_reads,
    vfs.num_of_writes,

    CASE
        WHEN vfs.num_of_reads > 0
        THEN vfs.io_stall_read_ms / vfs.num_of_reads
        ELSE 0
    END AS AvgReadLatencyMs,

    CASE
        WHEN vfs.num_of_writes > 0
        THEN vfs.io_stall_write_ms / vfs.num_of_writes
        ELSE 0
    END AS AvgWriteLatencyMs,

    CAST(vfs.num_of_bytes_read / 1024.0 / 1024 AS DECIMAL(18,2))
        AS TotalReadMB,

    CAST(vfs.num_of_bytes_written / 1024.0 / 1024 AS DECIMAL(18,2))
        AS TotalWrittenMB

FROM sys.dm_io_virtual_file_stats(NULL, NULL) vfs
JOIN sys.master_files mf
    ON vfs.database_id = mf.database_id
   AND vfs.file_id = mf.file_id

ORDER BY AvgWriteLatencyMs DESC,
         AvgReadLatencyMs DESC;
GO