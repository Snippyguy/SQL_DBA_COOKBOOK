/***************************************************************************************************************************************
Code Description	 : Backup History Information																				       *
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
The msdb system database is the primary repository for storage of SQL Agent, backup, Service Broker, Database Mail, Log Shipping, restore, and maintenance plan metadata. 
We will be focusing on the handful of system views associated with database backups for this tip:

    •dbo.backupset: provides information concerning the most-granular details of the backup process
    •dbo.backupmediafamily: provides metadata for the physical backup files as they relate to backup sets
    •dbo.backupfile: this system view provides the most-granular information for the physical backup files
*/

--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous Week 
--------------------------------------------------------------------------------- 
SELECT 
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_start_date, 
   msdb.dbo.backupset.backup_finish_date, 
   msdb.dbo.backupset.expiration_date, 
   CASE msdb..backupset.type 
      WHEN 'D' THEN 'Database' 
      WHEN 'L' THEN 'Log' 
      END AS backup_type, 
   msdb.dbo.backupset.backup_size, 
   msdb.dbo.backupmediafamily.logical_device_name, 
   msdb.dbo.backupmediafamily.physical_device_name, 
   msdb.dbo.backupset.name AS backupset_name, 
   msdb.dbo.backupset.description 
FROM 
   msdb.dbo.backupmediafamily 
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE 
   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_finish_date 

------------------------------------------------------------------------------------------- 
--Most Recent Database Backup for Each Database 
------------------------------------------------------------------------------------------- 
SELECT  
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name,  
   MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date 
FROM 
   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
WHERE msdb..backupset.type = 'D' 
GROUP BY 
   msdb.dbo.backupset.database_name  
ORDER BY  
   msdb.dbo.backupset.database_name 

------------------------------------------------------------------------------------------- 
--Most Recent Database Backup for Each Database - Detailed 
------------------------------------------------------------------------------------------- 
SELECT  
   A.[Server],  
   A.last_db_backup_date,  
   B.backup_start_date,  
   B.expiration_date, 
   B.backup_size,  
   B.logical_device_name,  
   B.physical_device_name,   
   B.backupset_name, 
   B.description 
FROM 
   ( 
   SELECT   
      CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
      msdb.dbo.backupset.database_name,  
      MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date 
   FROM 
      msdb.dbo.backupmediafamily  
      INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
   WHERE 
      msdb..backupset.type = 'D' 
   GROUP BY 
      msdb.dbo.backupset.database_name  
   ) AS A 
   LEFT JOIN  
   ( 
   SELECT   
      CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
      msdb.dbo.backupset.database_name,  
      msdb.dbo.backupset.backup_start_date,  
      msdb.dbo.backupset.backup_finish_date, 
      msdb.dbo.backupset.expiration_date, 
      msdb.dbo.backupset.backup_size,  
      msdb.dbo.backupmediafamily.logical_device_name,  
      msdb.dbo.backupmediafamily.physical_device_name,   
      msdb.dbo.backupset.name AS backupset_name, 
      msdb.dbo.backupset.description 
   FROM 
      msdb.dbo.backupmediafamily  
      INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
   WHERE 
      msdb..backupset.type = 'D' 
   ) AS B 
   ON A.[server] = B.[server] AND A.[database_name] = B.[database_name] AND A.[last_db_backup_date] = B.[backup_finish_date] 
ORDER BY  
   A.database_name 

------------------------------------------------------------------------------------------------------------------------------------------

USE msdb;


GO
DECLARE @database_name AS SYSNAME;

SELECT @database_name = N'AdventureWorks2022';

SELECT   bs.server_name,
         bs.user_name,
         database_name       = bs.database_name,
         start_time          = bs.backup_start_date,
         finish_time         = bs.backup_finish_date,
         time_cost_sec       = DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date),
         -- Backup device information
         device_type         = bmf.device_type,
         logical_device_name = bmf.logical_device_name,
         back_file           = bmf.physical_device_name,
         backup_type         = CASE WHEN bs.[type] = 'D' THEN 'Full Backup' WHEN bs.[type] = 'I' THEN 'Differential Database' WHEN bs.[type] = 'L' THEN 'Log' WHEN bs.[type] = 'F' THEN 'File/Filegroup' WHEN bs.[type] = 'G' THEN 'Differential File' WHEN bs.[type] = 'P' THEN 'Partial' WHEN bs.[type] = 'Q' THEN 'Differential Partial' END,
         backup_size_mb      = ROUND(bs.backup_size / 1024.0 / 1024.0, 2),
         compressed_size_mb  = ROUND(bs.compressed_backup_size / 1024.0 / 1024.0, 2),
         bs.first_lsn,
         bs.last_lsn,
         bs.checkpoint_lsn,
         bs.database_backup_lsn,
         bs.software_major_version,
         bs.software_minor_version,
         bs.software_build_version,
         bs.recovery_model,
         bs.collation_name,
         bs.database_version
FROM     msdb.dbo.backupmediafamily AS bmf WITH (NOLOCK)
         INNER JOIN
         msdb.dbo.backupset AS bs WITH (NOLOCK)
         ON bmf.media_set_id = bs.media_set_id
WHERE    bs.database_name = @database_name
ORDER BY bs.backup_start_date DESC;

/*
DeviceType	Meaning
2	        Disk
5	        Tape
7	        Virtual device
9	        Azure Blob Storage
105	        Permanent backup device
*/

/*
Special attention:
If you use the msdb.dbo.sp_delete_database_backuphistory stored procedure to clear the backup history of the database when you delete the database, 
you can no longer get the backup history of the database. For example:

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdventureWorks2022'
GO

To avoid performance degradation in msdb, it is best practice to purge old history using the built-in system stored procedure:
-- Purges backup and restore history records older than 30 days
USE msdb;
GO
EXEC sp_delete_backuphistory @oldest_date = '2026-08-01'; -- Replace with your desired cut-off date
GO
*/