/***************************************************************************************************************************************
Code Description	 : LOGINS ADD PERMISSIONS_1 																					   *
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
CREATE LOGIN [DOMAIN\LOGIN_NAME] FROM WINDOWS WITH DEFAULT_DATABASE = [master]
GO 
ALTER SERVER ROLE [dbcreator] ADD MEMBER [DOMAIN\LOGIN_NAME] 
GO
USE [master]
GO 
CREATE USER [DOMAIN\LOGIN_NAME] FOR LOGIN [DOMAIN\LOGIN_NAME]
GO
USE [master]
GO 
ALTER ROLE [db_backupoperator] ADD MEMBER [DOMAIN\LOGIN_NAME] 
GO
USE [master]
GO 
ALTER ROLE [db_datareader] ADD MEMBER [DOMAIN\LOGIN_NAME] 
GO
USE [master]
GO 
GRANT VIEW ANY DEFINITION TO [DOMAIN\LOGIN_NAMES] 
GO
USE [master]
GO
GRANT VIEW SERVER STATE TO [DOMAIN\LOGIN_NAMES] 
GO
USE [model]
GO
CREATE USER [DOMAIN\LOGIN_NAME] FOR LOGIN [DOMAIN\LOGIN_NAMES] 
GO
USE [model]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DOMAIN\LOGIN_NAME]
GO 
USE [model]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [DOMAIN\LOGIN_NAME]
GO
USE [msdb]
GO
CREATE USER [DOMAIN\LOGIN_NAME] FOR LOGIN [DOMAIN\LOGIN_NAME]
GO
USE [msdb]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DOMAIN\LOGIN_NAME]
GO
USE [msdb]
GO
ALTER ROLE [db_datareader] ADD MEMBER [DOMAIN\LOGIN_NAME]
GO
USE [msdb]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [DOMAIN\LOGIN_NAME]
GO