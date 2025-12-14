/***********************************************************************************************
 Root Blocker Detection Script
 -----------------------------------------------------------------------------------------------
 Description:
   Identifies the *root blocker* in SQL Server — the session at the top of the blocking chain 
   that is blocking others but itself is not being blocked.
***********************************************************************************************/

-----------------------------------------
-- CTE 1: Sessions that are blocked
-----------------------------------------
WITH Blockers AS
(
    SELECT
        session_id,
        blocking_session_id,
        wait_type,
        wait_time,
        last_wait_type,
        wait_resource
    FROM sys.dm_exec_requests
    WHERE blocking_session_id <> 0
),

-----------------------------------------
-- CTE 2: Root Blockers = sessions that
--        block others but are NOT blocked
-----------------------------------------
RootBlockers AS
(
    SELECT DISTINCT
        b.blocking_session_id AS session_id
    FROM Blockers b
    LEFT JOIN Blockers b2
           ON b.blocking_session_id = b2.session_id
    WHERE b2.session_id IS NULL   -- not blocked by anyone
)

-----------------------------------------
-- FINAL: Show Details of Root Blocker
-----------------------------------------
SELECT
    s.session_id,
    s.host_name,
    s.login_name,
    s.status,
    s.cpu_time,
    s.memory_usage,
    s.total_elapsed_time,
    s.program_name,
    r.wait_type,
    r.wait_time AS wait_time_ms,
    r.last_wait_type,
    r.wait_resource,
    txt.text AS running_query,
    ib.event_info AS input_buffer
FROM sys.dm_exec_sessions s
JOIN sys.dm_exec_requests r 
     ON s.session_id = r.session_id
JOIN RootBlockers rb 
     ON rb.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) txt
OUTER APPLY sys.dm_exec_input_buffer(s.session_id, NULL) ib;
