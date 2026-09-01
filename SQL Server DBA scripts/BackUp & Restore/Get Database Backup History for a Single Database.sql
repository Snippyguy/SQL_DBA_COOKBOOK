/***************************************************************************************************************************************
Code Description	 : Get Database Backup History for a Single Database									        		           *
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

USE AdventureWorks2022;
GO

-- Get Backup History for required database
SELECT   TOP 100 s.Database_Name,
                 m.Physical_Device_Name,
                 CAST (CAST (s.backup_size / 1000000 AS INT) AS VARCHAR (14)) + ' ' + 'MB' AS BackupSize,
                 CAST (DATEDIFF(second, s.backup_start_date, s.backup_finish_date) AS VARCHAR (4)) + ' ' + 'Seconds' AS TimeTaken,
                 s.Backup_Start_Date,
                 s.Backup_Finish_Date,
                 CAST (s.first_lsn AS VARCHAR (50)) AS first_lsn,
                 CAST (s.last_lsn AS VARCHAR (50)) AS last_lsn,
                 CASE s.[type] 
                                WHEN 'D' THEN 'Full' 
                                WHEN 'I' THEN 'Differential' 
                                WHEN 'L' THEN 'Transaction Log' 
                                END AS BackupType,
                 s.Server_Name,
                 s.Recovery_Model
FROM     msdb.dbo.backupset AS s
         INNER JOIN
         msdb.dbo.backupmediafamily AS m
         ON s.media_set_id = m.media_set_id
WHERE    s.database_name = DB_NAME() -- Remove this line for all the database
ORDER BY backup_start_date DESC, backup_finish_date;

/*
SELECT   TOP 100 s.Database_Name,
                 m.Physical_Device_Name,
                 CAST (CAST (s.backup_size / 1000000 AS BIGINT) AS VARCHAR (20)) + ' MB' AS BackupSize,
                 -- Execution time: Months Days HH:MM:SS
                 CAST (DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date) / 2592000 AS VARCHAR (10)) + ' Month(s) ' + CAST ((DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date) % 2592000) / 86400 AS VARCHAR (10)) + ' Day(s) ' + RIGHT('00' + CAST ((DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date) % 86400) / 3600 AS VARCHAR (2)), 2) + ':' + RIGHT('00' + CAST ((DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date) % 3600) / 60 AS VARCHAR (2)), 2) + ':' + RIGHT('00' + CAST (DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date) % 60 AS VARCHAR (2)), 2) AS TimeTaken,
                 s.Backup_Start_Date,
                 s.Backup_Finish_Date,
                 CAST (s.first_lsn AS VARCHAR (50)) AS first_lsn,
                 CAST (s.last_lsn AS VARCHAR (50)) AS last_lsn,
                 CASE s.[type] 
                                WHEN 'D' THEN 'Full' 
                                WHEN 'I' THEN 'Differential' 
                                WHEN 'L' THEN 'Transaction Log' 
                                END AS BackupType,
                 s.Server_Name,
                 s.Recovery_Model
FROM     msdb.dbo.backupset AS s
         INNER JOIN
         msdb.dbo.backupmediafamily AS m
         ON s.media_set_id = m.media_set_id
WHERE    s.database_name = DB_NAME()
-- Remove the above line for all databases
ORDER BY s.backup_start_date DESC, s.backup_finish_date DESC;
*/