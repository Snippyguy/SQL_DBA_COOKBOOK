
--granting "Control" permission to "public" effectively gives every user in that database db_owner privileges (the highest level of access within a database).

/*custom script*/
USE [AdventureWorks2022]
GO

SELECT	state_desc
		,class_desc
		,permission_name
		,user_name(grantee_principal_id) [grantee]
		,user_name(grantor_principal_id) [grantor]
FROM sys.database_permissions
WHERE permission_name = 'CONTROL'
 AND grantee_principal_id = 0 /*public role*/

/*OR standard procedure*/
EXEC [AdventureWorks2022]..sp_helprotect @username = N'public'