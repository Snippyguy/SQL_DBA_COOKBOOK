/***************************************************************************************************************************************
Code Description	 : Extract Permissions from Database																		       *
Author Name		 	 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		     	 : www.snippyguy.com																							   *
License			 	 : MIT, CC0																										   *
Creation Date		 : 24/11/2023																									   *
Last Modified By 	 : 24/11/2023																									   *
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

DECLARE 	 @USER 	NVARCHAR(200) = NULL

--SET IF FILTER FOR SPECIFIC USER 
--SET @USER = 'Test'

DECLARE		 @sql 	VARCHAR(2048)
			,@sort 	INT

DECLARE tmp CURSOR FOR

/****************************************************/
/*************** DB CONTEXT STATEMENT ***************/
/****************************************************/

SELECT '-- [-- DB CONTEXT --] --' AS [-- SQL STATEMENTS --],
		1 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT 'USE' + SPACE(1) + QUOTENAME(DB_NAME()) AS [-- SQL STATEMENTS --],
		1 AS [-- RESULT ORDER HOLDER --]
UNION 
SELECT '' AS [-- SQL STATEMENTS --],
		2 AS [-- RESULT ORDER HOLDER --]
UNION

/****************************************************/
/***************** DB USER CREATION *****************/
/****************************************************/

SELECT '-- [-- DB USERS --] --' AS [-- SQL STATEMENTS --], 
		3 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT 'IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = ' + SPACE(1) + '''' + [name] + '''' + ') BEGIN CREATE USER ' + SPACE (1)+ QUOTENAME([name]) + ' FOR LOGIN ' + QUOTENAME([name]) + ' WITH DEFAULT_SCHEMA = ' +QUOTENAME([default_schema_name]) + SPACE(1) + 'END; ' AS [-- SQL STATEMENTS --],
		4 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_principals As rm
WHERE [type] IN ('U', 'S', 'G') --windows users, sql users, windows groups 
AND rm.[name] = CASE WHEN @USER IS NULL THEN rm.[name] ELSE @USER END
UNION

/****************************************************/
/**************** DB ROLE PERMISSIONS ***************/
/****************************************************/

SELECT '-- [-- DB ROLES --] --' AS [-- SQL STATEMENTS --], 
		5 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT 'EXEC sp_addrolemember @rolename ='
		+ SPACE(1) + QUOTENAME(USER_NAME(rm.role_principal_id), '''') + ', @membername =' + SPACE(1) + QUOTENAME(USER_NAME(rm.member_principal_id), '''') AS [-- SQL STATEMENTS --],
		6 AS [-- RESULT ORDER HOLDER --]
FROM  sys.database_role_members AS rm 
WHERE USER_NAME(rm.member_principal_id) IN (
												--get user names on the database
												SELECT [name] 
												FROM sys.database_principals rm 
												WHERE [principal_id] > 4 		--0 to 4 are system users/schemas 
												and [type] IN ('G', 'S', 'U') 	--s = SQL user, U = Windows user, G = Windows group 
												AND rm.[name] = CASE WHEN @USER IS NULL THEN rm.[name] ELSE @USER END
											)
--ORDER BY rm.role_principal_id ASC
UNION
SELECT '' AS [-- SOL STATEMENTS --],
		7 AS [-- RESULT ORDER HOLDER --]
UNION

/****************************************************/
/************* OBJECT LEVEL PERMISSIONS *************/
/****************************************************/

SELECT '-- [-- OBJECT LEVEL PERMISSIONS --] --' AS [-- SOL STATEMENTS --],
		8 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
			WHEN perm.state <> 'W' 
			THEN perm.state_desc 
			ELSE 'GRANT'
		END
		+ SPACE(1) + perm.permission_name + SPACE(1) + 'ON ' + QUOTENAME(SCHEMA_NAME(obj.schema_id)) + '.' + QUOTENAME(obj.name) --select, execute, etc on specific objects
		+ CASE
			WHEN cl.column_id IS NULL 
			THEN SPACE(0) 
			ELSE '(' + QUOTENAME(cl.name) + ')'
		END
		+ SPACE(1) + 'TO' + SPACE(1) + QUOTENAME(USER_NAME(usr.principal_id)) COLLATE database_default
		+ CASE
			WHEN perm.state <> 'W' 
			THEN SPACE(0) 
			ELSE SPACE (1) + 'WITH GRANT OPTION'
		END
		AS [-- SQL STATEMENTS --],
		9 AS [-- RESULT ORDER HOLDER --]
FROM 
			sys.database_permissions AS perm
INNER JOIN
			sys.objects AS obj
			ON perm.major_id = obj.[object_id]
INNER JOIN
			sys.database_principals AS usr
			ON perm.grantee_principal_id = usr.principal_id
LEFT JOIN
			sys.columns AS cl
			ON cl.column_id = perm.minor_id 
			AND cl.[object_id] = perm.major_id 
			WHERE usr.name = CASE  
									WHEN @USER IS NULL 
									THEN usr.[name] 
									ELSE @USER 
							END 
			--ORDER BY perm.permission_name ASC, perm.state_desc ASC
UNION
SELECT '' AS [-- SOL STATEMENTS --],
		10 AS [-- RESULT ORDER HOLDER --]
UNION

/****************************************************/
/*************** DB LEVEL PERMISSIONS ***************/
/****************************************************/

SELECT '-- [-- DBB LEVEL PERMISSIONS --] --' AS [-- SQL STATEMENTS --],
		11 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE 
			WHEN perm.state <> 'W' 
			THEN perm.state_desc --W = Grant With Grant Option
			ELSE 'GRANT'
		END
		+ SPACE(1) + perm.permission_name --CONNECT, etc
		+ SPACE(1) + 'TO' + SPACE(1) + '[' + USER_NAME(usr.principal_id) + ']' COLLATE database_default --TO <user name>
		+ CASE
			WHEN perm.state <> 'W' 
			THEN SPACE(0) 
			ELSE SPACE(1) + 'WITH GRANT OPTION'
			END
		AS [-- SQL STATEMENTS --],
		12 AS [-- RESULT ORDER HOLDER --]
FROM 
			sys.database_permissions AS perm
INNER JOIN
			sys.database_principals AS usr
			ON perm.grantee_principal_id = usr.principal_id
			--WHERE usr.name = @01dUser 
			WHERE [perm].[major_id] = 0
			AND [usr].[principal_id]> 4 		--0 to 4 are system users/schemas 
			AND [usr].[type] IN ('G', 'S', 'U') --S SQL user, U Windows user, G Windows group
			AND usr.name = CASE 
								WHEN @USER IS NULL 
								THEN usr.[name] 
								ELSE @USER 
							END 
UNION
SELECT '' AS [-- SOL STATEMENTS --],
		13 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT '-- [-- DB LEVEL SCHEMA PERMISSIONS --] --' AS [-- SOL STATEMENTS --],
		14 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
			WHEN perm.state <> 'W' 
			THEN perm.state_desc --W = Grant With Grant Option 
			ELSE 'GRANT'
		END
		+ SPACE(1) + perm.permission_name --CONNECT,etc 
		+ SPACE(1) + 'ON' + SPACE(1) + class_desc + '::' COLLATE database_default --TO <user name>
		+QUOTENAME(SCHEMA_NAME(major_id))
		+SPACE(1) + 'TO' + SPACE(1) + QUOTENAME(USER_NAME(grantee_principal_id)) COLLATE database_default
		+CASE 
				WHEN perm.state <> 'W' 
				THEN SPACE(0) 
				ELSE SPACE(1) + 'WITH GRANT OPTION'
		END
		AS [-- SQL STATEMENTS --],
		15 AS [-- RESULT ORDER HOLDER --]
FROM
			sys.database_permissions AS perm
INNER JOIN 
			sys.schemas s
			on perm.major_id = s.schema_id
INNER JOIN 
			sys.database_principals dbprin 
			on perm.grantee_principal_id = dbprin.principal_id
WHERE class = 3 --class 3 = schema
AND dbprin.[name] = CASE WHEN @USER IS NULL THEN dbprin.[name] ELSE @USER END
ORDER BY [-- RESULT ORDER HOLDER --]
OPEN tmp
FETCH NEXT FROM tmp INTO @sql, @sort
WHILE @@FETCH_STATUS = 0
BEGIN
		PRINT @sql
		FETCH NEXT FROM tmp INTO @sql, @sort
END
CLOSE tmp
DEALLOCATE tmp