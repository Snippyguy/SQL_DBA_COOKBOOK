/***************************************************************************************************************************************
Code Description	 : LOGINS ADD PERMISSIONS_2																					       *
Author Name		 	 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		     	 : www.snippyguy.com																							   *
License			 	 : MIT, CC0																										   *
Creation Date		 : 20/11/2023																									   *
Last Modified By 	 : 20/11/2023																									   *
Last Modification	 : Initial Creation  																							   *
Modification History : 	 																											   *
***************************************************************************************************************************************/

/***************************************************************************************************************************************
*                                                Copyright (C) 2024 Sayan Dey														   *
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

USE [master]
GO


DECLARE 		@DatabaseName 		NVARCHAR(100)
DECLARE 		@SOL 				NVARCHAR(max)
DECLARE 		@SQL1 				NVARCHAR(max)
DECLARE 		@SQL2 				NVARCHAR(max)
DECLARE 		@SQL3 				VARCHAR(max)
DECLARE 		@User 				VARCHAR(64)
SET 			@User 				[DOMAIN\LOGIN_NAME]

PRINT 'The following user has been selected to have access on all user databases except system databases and log shipped databases: ' +@user

DECLARE Grant_Permission CURSOR LOCAL FOR
SELECT name FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb', 'distribution') 
and [state_desc] = 'ONLINE' and [is_read_only] <> 1 order by name
OPEN Grant_Permission
FETCH NEXT FROM Grant_Permission INTO @DatabaseName
WHILE @@FETCH_STATUS = 0

BEGIN

SELECT @SQL =  'USE '+ '[' + @DatabaseName + ']' +'; 'CREATE USER '+@User+ ' FOR LOGIN' + @User + ';';
PRINT @SQL
--EXEC sp_executesql @SQL

SELECT SQL1 =  'USE '+ '[' + @DatabaseName + ']' +'; 'ALTER ROLE [db_backupoperator] ADD MEMBER' + @User + ';';
PRINT @SQL1
--EXEC sp_executesql @SQL1

SELECT @SQL2 =  'USE '+ '[' + @DatabaseName + ']' +'; 'ALTER ROLE [db_denydatareader] ADD MEMBER' + @User + ';';
PRINT @SQL2
--EXEC sp_executesql @SQL2

SELECT @SQL3 =  'USE '+ '[' + @DatabaseName + ']' +'; 'ALTER ROLE [db_denydatawriter] ADD MEMBER' + @User + ';';
PRINT @SQL3
--EXEC sp_executesql @SQL3

Print '' --This is to give a line space between two databases execute prints.

FETCH NEXT FROM Grant_Permission INTO @DatabaseName

END

CLOSE Grant_Permission
DEALLOCATE Grant_Permission