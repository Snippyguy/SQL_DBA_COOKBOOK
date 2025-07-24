/*
You don’t need a special auditing solution to track who and when created, altered, or dropped objects, including entire databases. 
If something was dropped in your environment - whether it's a table or even a database - this script can help you find out who did it and when.

The script uses the default trace, which is enabled and running by default and contains a lot of useful information.

The default trace logs data into 5 files of 20 MB each, rotating over time.
So, if you need this type of audit on a permanent basis, consider either configuring a dedicated auditing process or regularly saving the collected trace data to a table.

Note:
Accessing sys.traces is logged in the default trace itself.
If your company uses security monitoring tools, this access might trigger alerts. Keep that in mind!
*/

--To check if the default trace is enabled and running:

IF EXISTS (SELECT 1 FROM sys.traces WHERE is_default = 1 AND status = 1)
 PRINT 'Default trace is enabled and running.'
ELSE
 PRINT 'Default trace is disabled or stopped.'

 --script that helps identify who and when created, altered, or dropped objects, including entire databases.
 WITH otype (id,typename)
AS (
 SELECT 16964, 'Database' UNION ALL
 SELECT 8277, 'Table' UNION ALL
 SELECT 8278, 'View' UNION ALL
 SELECT 22601, 'Index' UNION ALL
 SELECT 21587, 'Statistics'
/*
 more types here:
 --https://lnkd.in/e4hQhyNt
 */
 )
SELECT DISTINCT ft.StartTime
				,ft.SPID
				,ft.LoginName
				,ft.ApplicationName
				,ft.ClientProcessID
				,ft.Hostname
				,te.name [Event]
				,ft.DatabaseName
				,isnull(ft.ObjectName, N'--->') [ObjectName]
				,isnull(o.typename, convert(VARCHAR(10), ft.ObjectType)) [ObjectType]
FROM sys.traces st
CROSS APPLY::fn_trace_gettable(left(st.path, len(st.path) - charindex('_', reverse(st.path))) + right(st.path, 4), st.max_files) ft
INNER JOIN sys.trace_events te ON ft.EventClass = te.trace_event_id
LEFT JOIN otype o ON o.id = ft.ObjectType
WHERE te.name LIKE 'Object%'
 AND st.is_default = 1
 AND st.STATUS = 1
ORDER BY ft.StartTime DESC;