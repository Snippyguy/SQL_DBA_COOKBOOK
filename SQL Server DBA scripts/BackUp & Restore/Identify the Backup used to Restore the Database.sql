/***************************************************************************************************************************************
Code Description	 : Identify the Backup used to Restore the Database																   *
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
The question was “How do I know which backup was used to restore the database given there are two backups and they are from two different servers?”  
Well to understand the answer to this question I would like to break this article it in two phases.

Phase 1: How can we identify the backup file which was used to restore a database if the backup was from the same server?
Answer: Here we will need to exploit the history tables in MSDB. We will need to join the “msdb.dbo.restorehistory” and “msdb.dbo.backupmediafamily” tables. 
		This will give us the answer to our query.
*/

select r.restore_history_id , r.restore_date,r.restore_type,r.replace,r.recovery,b.backup_set_id, b.database_name,m.physical_device_name 
from backupset b join backupmediafamily m on b.media_set_id=m.media_set_id
join restorehistory r on r.backup_set_id=b.backup_set_id

/*
Now we know the backup that was used to restore the database. 
The scenario takes a complete different turn when the historytables have been cleared because of maintenance jobs or the backup files are not from the same server. 
This brings us to the Phase 2 of my article

Phase2. How can we identify the backup file that was used to restore a database if the backup was from the different server or the history tables have been cleared?
Answer: The history tables only help if the backupset data is from the same server where you want to restore. 
		The reason being is the backupset information that we are joining with the restore history here is only relevant when the backup of the database is taken on the same server. 
		Otherwise the backupset will not have the information about the backupset.

To approach the solution we will use an undocumented command: DBCC DBINFO (“DBNAME”). 
This will give us a lot of information related to the database including the dbi_dbbackupLSN and the dbi_checkptLSN.  
LSN is the Log Sequence number which helps SQL Server to maintain the chain of the restoration process. 
*/

DBCC DBINFO ('AdventureWorks2022') WITH TABLERESULTS

/*
The dbi_dbbackupLSN is the last LSN of the backup file and dbi_checkptLSN is the checkpoint LSN for the backup file that was used to restore the database. 
Now that we have the information of the LSN of the Backupset from which we require all we need to do is to identify the LSN’s of the backup set that we have. 
We can get the LSN information of the backup file using the restore headeronly command.

The backup header will have a lot of information related to the backup file. 
It will have the server name, database version, first LSN, last LSN, checkpoint LSN and lot of information which are useful information in a lot of scenarios. 
Here we will try to match the LastLSN with the dbiBackupLSN and the CheckPointLSN to dbi_checkptLSN  to identify the backup which was used to restore the database.
*/

RESTORE HEADERONLY FROM DISK = 'D:\SQLBackups\Adventureworks2022\Adventureworks2022.BAK'