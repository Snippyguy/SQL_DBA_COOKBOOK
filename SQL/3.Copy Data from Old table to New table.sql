/***************************************************************************************************************************************
Code Description	 : Copying data from old table to new table														                   *
Author Name			 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website				 : www.snippyguy.com																							   *
License				 : MIT, CC0																										   *
Creation Date		 : 15/11/2024																									   *
Last Modified By 	 : 15/11/2024																									   *
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

--Method 1
SELECT *
INTO	[Your_Instance_Name( or Host_Name)].[Your_Database_Name].[Your_Schema_Name].[Your_New_Table_Name]  --New Table that will be created 
FROM	[Your_Instance_Name( or Host_Name)].[Your_Database_Name].[Your_Schema_Name].[Your_Old_Table_Name]; --Old table, from where you are copying the data

--Example
SELECT *
INTO	[ABC].[AdventureWorks2022].[HumanResources].[BKP_151124_EmployeeDepartmentHistory]  --New Table that will be created
FROM	[ABC].[AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory];			--Old table, from where you are copying the data


--[ABC].[AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory] --> This is called fully qualified name or Three Part Name. 
--This is supported only in On-Prem. Azure doesn't support fully qualified name.
--**To reference an object located in a remote database, the fully qualified object name includes the server name and the database name.**
--Always refer to the objects using a fully qualified name. At the very least, use the schema name followed by the object name.
--schema qualifying or two part names --> [Your_Schema_Name].[Your_Object_Name];

--Fully qualified names are usually preferred, but some considerations apply. I will say it depends a lot on the requirements and a single answer may not suffice all scenarios.
--Note that this is just a compilation binding, not an execution one. So if you execute the same query thousand times, only the first execution will 'hit' the look up time, which means lookup time is less in case of fully qualified names. This also means using fully qualified names will save the compilation overhead (the first time when query is executed).
--The rest will reuse the compiled one, where names are resolved to object references.


--There's a trivial penalty because the query text is longer so there's more bytes to be sent to SQL Server and parsed.
--The penalty is academic, honesty it will not be better or worse because of the prefixes.
--prefix will cause issue if you migrate or rename the DB Name. (Also, in case the database name change is not allowed on production environment & even in testing scenarios (UAT), it happens rarely


--If the new table is already created or exists in the env. and you want to copy the data from old table to new table then -->
INSERT INTO			
				[Your_Instance_Name].[Your_Database_Name].[Your_Schema_Name].[Your_New_Table_Name]  --New Table that is already created or exists in the env.
SELECT * FROM	
				[Your_Instance_Name].[Your_Database_Name].[Your_Schema_Name].[Your_Old_Table_Name]; --Old table, from where you are copying the data


--Method 2 (Not Supported in SQL Server. But supported in oracle & PostgreSQL) 
CREATE TABLE new_table AS SELECT * FROM original_table;

--Please be careful when using this to clone big tables. This can take a lot of time and server resources as it will copy the data also.
--**Note: That new_table inherits ONLY the basic column definitions, null settings and default values of the original_table. It does not inherit indexes and auto_increment definitions.
