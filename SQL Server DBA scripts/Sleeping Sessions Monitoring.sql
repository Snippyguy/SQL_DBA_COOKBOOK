/*=========================================================
  Query Name : Sleeping Sessions Monitoring
  Purpose    : Identify sleeping sessions, their source,
               login details, last activity time, and
               detect excessive session accumulation.
=========================================================*/

-- Quick Session Overview
EXEC sp_who2;
GO

/*---------------------------------------------------------
  Detailed Sleeping Sessions Information
---------------------------------------------------------*/
SELECT
    session_id,
    login_name,
    host_name,
    status,
    last_request_start_time,
    last_request_end_time,
    program_name,
    login_time,
    open_transaction_count
FROM sys.dm_exec_sessions
WHERE status = 'sleeping'
  AND session_id <> @@SPID
  AND is_user_process = 1
ORDER BY last_request_end_time DESC;
GO

/*---------------------------------------------------------
  Count Sleeping Sessions by Login and Host
---------------------------------------------------------*/
SELECT
    login_name,
    host_name,
    COUNT(*) AS SessionCount
FROM sys.dm_exec_sessions
WHERE is_user_process = 1
  AND status = 'sleeping'
GROUP BY
    login_name,
    host_name
ORDER BY SessionCount DESC;
GO

/*---------------------------------------------------------
  Long-Running Idle Sessions
  (Idle for more than 30 minutes)
---------------------------------------------------------*/
SELECT
    session_id,
    login_name,
    host_name,
    program_name,
    status,
    last_request_end_time,
    DATEDIFF
    (
        MINUTE,
        last_request_end_time,
        GETDATE()
    ) AS IdleMinutes
FROM sys.dm_exec_sessions
WHERE status = 'sleeping'
  AND is_user_process = 1
  AND last_request_end_time IS NOT NULL
  AND DATEDIFF
      (
          MINUTE,
          last_request_end_time,
          GETDATE()
      ) > 30
ORDER BY IdleMinutes DESC;
GO