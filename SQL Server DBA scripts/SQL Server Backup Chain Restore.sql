
--SQL Server Backup Chain Restore

/*
As a DBA, backup and restore operations are part of our daily routine. 
But when it comes to point-in-time recovery, migration planning, or adding a large database to an Availability Group (AG) using the "join-only" option, things can get tricky.

Here’s a script I found online and customized for my use. 
It’s been incredibly helpful in generating the restore sequence using the backup chain—Full, Differential, and Transaction Log backups.

What This Script Does:
    1. Lists all backups for the current database.
    2. Identifies the type of backup (Full, Diff, Log).
    3. Generates the restore command for each backup file.
    4. Includes time taken for each backup.
    5. Optionally shows LSN info to troubleshoot restore errors.

Tips for Usage:
    1. Run this query on the source server in the target database.
    2. Use the WHERE clause to filter by date/time or backup type.
    3. All restore commands use WITH NORECOVERY so you can control when to bring the database online.
*/

SELECT 
    s.database_name,

    CASE s.[type] 
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Transaction Log' 
    END AS BackupType,

    CASE s.[type] 
        WHEN 'D' THEN 
            'RESTORE DATABASE [' + s.database_name + '] FROM DISK = ''' + m.physical_device_name + ''' WITH REPLACE, NORECOVERY, STATS = 10;'
        WHEN 'I' THEN 
            'RESTORE DATABASE [' + s.database_name + '] FROM DISK = ''' + m.physical_device_name + ''' WITH REPLACE, NORECOVERY, STATS = 10;'
        WHEN 'L' THEN 
            'RESTORE LOG [' + s.database_name + '] FROM DISK = ''' + m.physical_device_name + ''' WITH NORECOVERY, STATS = 10;'
    END AS [Query to Restore],

    CAST(DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date) AS VARCHAR(10)) + ' Seconds' AS TimeTaken,

    s.backup_start_date,

    s.recovery_model

    -- Uncomment below lines for LSN troubleshooting
    -- ,CAST(s.first_lsn AS VARCHAR(50)) AS first_lsn
    -- ,s.checkpoint_lsn
    -- ,s.database_backup_lsn AS [Reference for Diff Backup]
    -- ,CAST(s.last_lsn AS VARCHAR(50)) AS last_lsn

FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m 
    ON s.media_set_id = m.media_set_id
WHERE s.database_name = DB_NAME()
ORDER BY s.backup_start_date DESC;
