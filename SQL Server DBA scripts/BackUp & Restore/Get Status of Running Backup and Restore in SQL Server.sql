/***************************************************************************************************************************************
Code Description	 : Get Status of Running Backup and Restore in SQL Server												           *
Author Name		 	 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		     	 : www.snippyguy.com																							   *
LinkedIn			 : https://www.linkedin.com/in/snippyguy/																		   *																						
GitHub				 : https://github.com/Snippyguy																					   *
Tableau Public		 : https://public.tableau.com/app/profile/snippyguy/vizzes														   * 
License			 	 : MIT, CC0																										   *
Creation Date		 : 01/09/2026																									   *
Last Modified By 	 : 01/09/2026																									   *
Last Modification	 : Initial Creation  																							   *
Modification History : 	 																											   *
***************************************************************************************************************************************/

/***************************************************************************************************************************************
*                                                Copyright (C) 2026 Sayan Dey														   *
*                                                All rights reserved. 																   *
* 																																	   *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files     *
* (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do   *
* so, subject to the following conditions:																							   *
*																																	   *
*																																	   *
* You may alter this code for your own * Commercial* & *non-commercial* purposes. 													   *
* You may republish altered code as long as you include this copyright and give due credit. 										   *
* 																																	   *
* 																																	   *
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.	   *
*																																	   *
*																																	   *
* THE SOFTWARE (CODE AND INFORMATION) IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED *
* TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 		   *
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.										   *
*																																	   *
* 																																	   *
***************************************************************************************************************************************/

/*
If the backup or restore is running from a SQL Agent job or maybe someone kicked off the process from another machine, you can use DMV sys.dm_exec_requests to find the progress. 

If you wanted someone who is not a member of sysadmin role to check the backup or restore progress using this script, you can provide permission to them using the below command:
GRANT VIEW SERVER STATE TO [Login_name] 

SQL Restore Stuck at 100%:
I would like to touch base upon one aspect of SQL Server which you will encounter while restoring databases. Sometimes the restore appears stuck at 100% or around 99.99%. 
For very large databases, (i.e. TB size), it may even take several hours for the recovery to complete. 
To understand the restore completion percentage, we need to understand the different phases that a restore goes through.

The three phases are Data Copy phase, Redo phase and Undo phase.

While you may see the restore is 100% complete it’s actually only the Data Copy phase that is complete and then SQL proceeds to subsequent phases before the recovery is totally complete.
In the Redo phase, all the committed transactions present in the transaction log when the database was being backed up are rolled forward.
In the Undo phase, all the uncommitted transactions in the transaction log while the database was being backed up are rolled back.

**If the database is being restored with NORECOVERY, the Undo phase is skipped.**

Unfortunately, SQL Server does not show the progress during the Redo and Undo phases as it does in the Data Copy phase. 
So, depending upon the activity in the database at the time it was getting backed up will decide the overall total recovery time.
*/

SELECT r.session_id AS [Session ID],
       db_name      = db_name(r.database_id),
       r.command AS [Command],
       SUBSTRING(
        st.text,
        (r.statement_start_offset / 2) + 1,
        CASE
            WHEN r.statement_end_offset = -1
                THEN LEN(st.text)
            ELSE
                (r.statement_end_offset - r.statement_start_offset) / 2
        END
    ) AS [Query Text],
       r.status  AS [Status],
       CONVERT (NUMERIC (6, 2), r.percent_complete) AS [Percent Complete],
       GETDATE() AS [Current Time],
       CONVERT (VARCHAR (20), DATEADD(ms, r.estimated_completion_time, GetDate()), 20) AS [Estimated Completion Time],
       CONVERT (NUMERIC (32, 2), r.total_elapsed_time / 1000.0 / 60.0) AS [Elapsed Min],
       CONVERT (NUMERIC (32, 2), r.estimated_completion_time / 1000.0 / 60.0) AS [Estimated Min],
       CONVERT (NUMERIC (32, 2), r.estimated_completion_time / 1000.0 / 60.0 / 60.0) AS [Estimated Hours]
FROM   sys.dm_exec_requests AS r WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE  command LIKE 'RESTORE%'
       OR command LIKE 'BACKUP%';
--WHERE  command IN ('BACKUP DATABASE', 'BACKUP LOG', 'RESTORE DATABASE', 'RESTORE LOG');


USE master
GO
SELECT 
    req.session_id, 
    database_name = db_name(req.database_id),
    req.status,
    req.blocking_session_id, 
    req.command,
    [sql_text] = Substring(txt.TEXT, (req.statement_start_offset / 2) + 1, (
                (
                    CASE req.statement_end_offset
                        WHEN - 1 THEN Datalength(txt.TEXT)
                        ELSE req.statement_end_offset
                    END - req.statement_start_offset
                    ) / 2
                ) + 1),
    req.percent_complete,
    req.start_time,
    cpu_time_sec = req.cpu_time / 1000,
    granted_query_memory_mb = CONVERT(NUMERIC(8, 2), req.granted_query_memory / 128.),
    req.reads,
    req.logical_reads,
    req.writes,
    eta_completion_time = DATEADD(ms, req.[estimated_completion_time], GETDATE()),
    elapsed_min = CONVERT(NUMERIC(6, 2), req.[total_elapsed_time] / 1000.0 / 60.0),
    remaning_eta_min = CONVERT(NUMERIC(6, 2), req.[estimated_completion_time] / 1000.0 / 60.0),
    eta_hours = CONVERT(NUMERIC(6, 2), req.[estimated_completion_time] / 1000.0 / 60.0/ 60.0),
    wait_type,
    wait_time_sec = wait_time/1000, 
    wait_resource
FROM sys.dm_exec_requests as req WITH(NOLOCK)
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) as txt 
WHERE req.session_id>50
    AND command IN ('BACKUP DATABASE', 'BACKUP LOG', 'RESTORE DATABASE', 'RESTORE LOG')


