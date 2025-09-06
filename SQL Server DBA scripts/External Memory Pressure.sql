
--My SQL Server Experiencing External Memory Pressure?

--Notes:
-- Accessing sys.traces is itself recorded in the default trace, which may trigger alerts in your organization's security monitoring tools (if in place).
-- The default trace consists of only 5 files of 20MB each, and is overwritten over time. 

--Caveats:
-- This script may fail in the following cases:
-- If the default trace file name contains more than one underscore (_) character.
-- If any trace file is corrupted or inaccessible.

--Script:
------------------------------------
/*Total and free physical memory*/
SELECT total_physical_memory_kb / 1024 [Total_MB]
 ,available_physical_memory_kb / 1024 [Free_MB]
 ,system_memory_state_desc [Memory State]
FROM sys.dm_os_sys_memory;

/*"max server memory" configuration parameter*/
SELECT name
 ,value_in_use
FROM sys.configurations
WHERE configuration_id = 1544;

/*Target (next) and Total (current) memory consumption*/
SELECT counter_name
 ,cntr_value / 1024 [MB]
FROM sys.dm_os_performance_counters
WHERE counter_name LIKE N'T%Se%Me%';

/*Server memory changes*/
SELECT te.name
 ,ft.SPID
 ,ft.StartTime
 ,ft.IntegerData [Memory_MB]
FROM sys.traces st
CROSS APPLY::fn_trace_gettable(left(st.path, len(st.path) - charindex('_', reverse(st.path))) + right(st.path, 4), st.max_files) ft
INNER JOIN sys.trace_events AS te ON ft.EventClass = te.trace_event_id
WHERE te.name LIKE N'Server Memory Change'
 AND st.is_default = 1
 AND st.STATUS = 1
ORDER BY ft.StartTime DESC;