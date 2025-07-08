/***************************************************************************************************************************************
Code Description:	  DDL,DML,DCL,TCL,DQL SYNTAX CHEATSHEET																			   *
Author Name:		  Sayan Dey					  																					   *
Company Name:		  Snippyguy																										   *
Website:		      www.snippyguy.com																								   *
License:			  MIT, CC0																										   *
Creation Date:		  16/11/2024																									   *
Last Modified By: 	  16/11/2024																									   *
Last Modification:	  Initial Creation  																							   *
Modification History: 	 																											   *
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
* You may alter this code for your own *Commercial* & *non-commercial* purposes. 													   *
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

--Server	  -> Computer which has server program installed on it. Servers have millions of clients.
--Client	  -> Computer which has client program installed on it.
--Data		  -> Small, distinct, raw, unprocessed fact that doesn't convey any meaning but describe quantity, quality and that can be recorded or stored called as data. 
--Information -> Group of processed data that collectively carries a logical meaning. It depends on the data.
--Metadata	  -> Data about data. It gives information about other data.
--Database	  -> An organized collection of structured information or inter-related data. Also called as "DB".
--DBMS		  -> Also called as Database Management System. It is a software which is used to manage the database.
--RDBMS       -> Also called as Relational Database Management System. it is a type of DBMS.
--				 It is based on the relational model of E.F.Codd. RDBMS stores data in the form of collection of tables.
--				 Data is stored in a table that can be linked to other dataset or table based on shared information or relation hence the name "Relational".
--SQL		  -> Structured Query Language, used ti maintain, manage, Create & manipulate the data in a database. Became the ANSI standard in 1986 & ISO standard in 1987.
--				 It is a "Declarative Language".
--Keywords	  -> These are the reserved words. Ex: SELECT, FROM, WHERE, GROUP BY etc.

--Table/Relation		 -> Table is a collection of records and its information at a single view. 
--						    An organized data in the form of rows and columns is said to be a table.
--						    Everything in a "relational database" stored in the form of relations.
--					        The organized collection of data into relational table is known as logical view of the DB.
--Schema		         -> Overall design of a database called as Schema. It is a "Skeleton" structure if a DB, Its represent the logical view.
--Row/Record/Tuple		 -> Row of a table is called as Tuple or record. It is the Horizontal entity. It stores the specific information of each entry in the table.
--Column/Attribute/Field -> Column of a table is called as attribute or field. It is the vertical entity. It contains all info associated with a specific field in a table.
--Data items/Cell		 -> Smallest unit or the atomic unit which is the individual data items. It is stored at the intersections of row and column.
--Degree		         -> Total number of columns.
--Cardinality		     -> Total number of rows. If the cardinality is 0 then it is called a empty table.
--Domain		         -> Possible value each attribute can contain.


--<----------Degree of the below table is 5---------->
--****************************************************
--|  Column1 | Column2 | Column3 | Column4 | Column5 | --> Attributes/Fields
--****************************************************
--| Data	 | Data	   | Data	 | Data	   | Data	 | --> Row1 ---|
--****************************************************             |--> There are two rows in the table. So, Cardinality of the table is 2.
--| Data	 | Data	   | Data	 | Data	   | Data	 | --> Row2 ---|
--****************************************************


--NOTE:
--		1. SQL is not case sensitive.
--		2. Statement of SQL are dependent on text lines. We can use a single SQL statement one one line or on multiple lines.

--BEST PRACTICES:
--					1. You should write "KEYWORDS" in "Uppercase".
--					2. Use multiple lines for code readability.
--					3. Use comments & indentations for code readability.

--USE SPECIFIC DATABASE
USE [DATABASE_NAME]
GO

--Example
USE [AdventureWorks2022]
GO

--GO SYNTAX :-
--"GO" keyword is only supported in SQL Server. You can execute without using "GO" keyword also.
--GO is not a Transact-SQL statement, it is a utility command that requires no permissions. It can be executed by any user. More Specifically it is a "Batch Separator.
--The "GO" keyword is only recognized by SQL Server tools like SQLCMD and SSMS, not by the SQL language itself.
--Its primary function is to indicate to the SQL Server tool that the current batch of T-SQL commands should be sent to the database for execution.
--SQL Server utilities interpret GO as a signal that they should send the current batch of Transact-SQL statements to an instance of SQL Server. The current batch of statements is composed of all statements entered since the last GO, or since the start of the ad hoc session or script if this is the first GO.
--If you're working with other databases like MySQL, PostgreSQL, Oracle, etc., you won't encounter a "GO" keyword with the same functionality.
--**Do not use a semicolon as a statement terminator after GO.**


GO [count]  --COUNT IS A POSITIVE INTEGER. The batch preceding GO will execute the specified number of times.


--DDL COMMANDS	-> DATA DEFINITION LANGUAGE --> By default Auto Committed. It is used to define the database structure. To create the skeleton of a DB.
--1.Create 		-> To create DB objects.
--2.Alter		-> To alter existing DB objects structure.
--3.Rename		-> To rename a DB object.
--4.Drop		-> To delete a DB object.
--5.Truncate	-> To remove records from tables.
--6.Comment		-> To pass a comment.

--CREATE DATABASE
CREATE DATABASE [YOUR_DATABASE_NAME]
GO


--There is two types of Database
--1) System Database -> That are installed during the SQL server installation and used to manage SQL Server.These are important databases for DATABASE ADMINISTRATORS (DBA).
--                  a) MasterDB			  -> Main repository that holds all the system information, logins etc.
--                  b) ResourceDB		  -> System objects are stored here. Read-Only Database.
--                  c) TempDB			  -> Global resource that stores temporary tables, variables, store procedures etc.
--                  d) ModelDB			  -> Template of other database.
--                  d) MSDB				  -> Mainly used by SQL server agent, service broker, DB mail. Stores job history, backup history, log shipping history etc.
--                  e) ReportServer		  -> It is installed when you installed SSRS.
--                  f) ReportServerTempDB -> It is installed when you installed SSRS.
--                  g) Distribution		  -> It is installed when you configure Replication.
--2) User Database   -> When user create any database that is called User database.


----CREATE TABLE
CREATE TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] --FULLY QUALIFIED NAME --dbo is the default schema if schema name is not specified. 
(
	<COLUMN_NAME1> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME2> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME3> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME4> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME5> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME6> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME7> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK],
	<COLUMN_NAME8> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [CONSTRAINT constraint_name] FOREIGN KEY REFERENCES [SCHEMA_NAME].[TABLE_NAME](COLUMN_NAME_OF_REFERENCE_TABLE),
	.
	.
	.
	<COLUMN_NAMEn> [DATA_TYPE] [LENGTH] [NULL/NOT NULL] [ CONSTRAINT constraint_name ] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK]
)
ON   [PRIMARY]
GO

--[ABC].[AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory] --> This is called fully qualified name or Three Part Name. 
--This is supported only in On-Prem. Azure doesn't support fully qualified name.
--**To reference an object located in a remote database, the fully qualified object name includes the server name and the database name.**
--Always refer to the objects using a fully qualified name. At the very least, use the schema name followed by the object name.
--schema qualifying or two part names --> [Your_Schema_Name].[Your_Object_Name];
--Space is not allowed in column name.
--To give space in column name you have to use []

CREATE TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] --FULLY QUALIFIED NAME --dbo is the default schema if schema name is not specified
(
	<COLUMN_NAME1> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	<COLUMN_NAME2> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	<COLUMN_NAME3> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	<COLUMN_NAME4> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	<COLUMN_NAME5> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	<COLUMN_NAME6> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	<COLUMN_NAME7> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	.
	.
	.
	<COLUMN_NAMEn> [DATA_TYPE] [LENGTH] [NULL/NOT NULL],
	[CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK] (COLUMN_NAME(S)),
	[CONSTRAINT constraint_name] [PRIMARY KEY/UNIQUE KEY/DEFAULT/CHECK] (COLUMN_NAME(S)),
	[CONSTRAINT constraint_name] FOREIGN KEY (COLUMN_NAME_OF_THIS_TABLE) REFERENCES [SCHEMA_NAME].[TABLE_NAME](COLUMN_NAME_OF_REFERENCE_TABLE)
)
ON   [PRIMARY]
GO


--Example
CREATE TABLE [TestDB].[dbo].[Employees]
(
	Emp_ID			INT				NOT NULL CONSTRAINT EMP_ID_PK PRIMARY KEY, 
	First_Name		nvarchar(255)	NOT NULL,
	Last_Name		nvarchar(255)	NULL,
	Age				INT				CHECK (Age >= 20),
	Address			nvarchar(255)   NULL,
	Creation_Date	DATE			DEFAULT GETDATE()
) GO


--ALTER STATEMENT
--ALTER STATEMENT is used for:-
--								1. To Add Column(s).
--								2. To Add Constraint(s).
--								3. To Drop Column(s).
--								4. To Drop Constraint(s).
--								5. To Modify/Alter Datatype of column(s).
--								5. To Modify/Alter Length of column(s).
--								6. To Rename column.


--1.ALTER TABLE TO ADD A COLUMN
ALTER TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]
ADD			<COLUMN_NAME> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL]
GO

--2.ALTER TABLE TO ADD MULTIPLE COLUMNS 
ALTER TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]
ADD			(<COLUMN_NAME1> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL], --You can repeat ADD keyword, but don't have to.
             <COLUMN_NAME2> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL],
             <COLUMN_NAME3> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL],
			 .
			 .
			 .
			 <COLUMN_NAMEn> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL]
			)
GO

--3.ALTER TABLE TO DROP A SINGLE COLUMN 
ALTER TABLE  [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
DROP  COLUMN COLUMN_NAME
GO  

--4.ALTER TABLE TO DROP MULTIPLE COLUMNS 
ALTER TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
DROP  (
		COLUMN_NAME1, 
		COLUMN_NAME2, 
		COLUMN_NAME3, ...,
		COLUMN_NAMEn)
GO

--5.ALTER TABLE TO RENAME COLUMN
ALTER TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] RENAME COLUMN old_name TO new_name; --**Note: SQL Server doesn't support "RENAME" keyword


EXEC sp_rename 'Schema_Name'.'Table_Name'.'Old_Column_Name', 'New_Column_Name','COLUMN'
GO

--Example
EXEC sp_rename 'dbo.ErrorLog.ErrorTime', 'ErrorDateTime', 'COLUMN'
GO

--6.ALTER TABLE ADD A CONSTRAINTS
ALTER TABLE      [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
ADD   CONSTRAINT [constraint_name] [PRIMARY KEY/UNIQUE KEY/CHECK] (COLUMN_NAME)

GO

--7.ALTER TABLE ADD MULTIPLE CONSTRAINTS
ALTER TABLE      [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
ADD	  CONSTRAINT [constraint_name] [PRIMARY KEY/UNIQUE KEY/CHECK] (COLUMN_NAME),
	  CONSTRAINT [constraint_name] [PRIMARY KEY/UNIQUE KEY/CHECK] (COLUMN_NAME),
	  CONSTRAINT [constraint_name] [PRIMARY KEY/UNIQUE KEY/CHECK] (COLUMN_NAME),
	  CONSTRAINT [constraint_name] [PRIMARY KEY/UNIQUE KEY/CHECK] (COLUMN_NAME),..,
	  CONSTRAINT [constraint_name] [PRIMARY KEY/UNIQUE KEY/CHECK] (COLUMN_NAME)
GO

--8.ALTER TABLE DROP A CONSTRAINTS
ALTER TABLE      [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
DROP  CONSTRAINT [constraint_name]
GO

--9.ALTER TABLE DROP MULTIPLE CONSTRAINTS
ALTER TABLE      [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]
DROP  CONSTRAINT constraint_name1, 
				 constraint_name2, 
				 constraint_name3
GO

--10.ALTER TABLE - ALTER/MODIFY DATATYPE & LENGTH
--**Note: SQL Server doesn't support "Modify" keyword instead "Modify" you have to use "Alter" keyword. 

ALTER TABLE         [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]
ALTER/MODIFY COLUMN <COLUMN_NAME1> [DATA_TYPE] [LENGTH]
GO

--ALTER TABLE MODIFY Column statement in SQL: 
--The MODIFY keyword is used for changing the column definition of the existing table. 
--We can modify one or more existing column's data type, size, default value and nullability.  


--For Single Column
ALTER  TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
MODIFY/ALTER <COLUMN_NAME> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL]
GO

--For Multiple Column
ALTER TABLE  [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
MODIFY/ALTER (<COLUMN_NAME1> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL],
             <COLUMN_NAME2> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL],
             <COLUMN_NAME3> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL],
			 .
			 .
			 .
			 <COLUMN_NAMEn> [DATA_TYPE] [LENGTH] [DEFAULT default_valuel] [NULL/NOT NULL]
			)
GO


--RENAME DATABASE NAME
EXEC sp_renamedb 'currentdb_name', 'newdb_name';


--RENAME TABLE NAME
EXEC sp_rename 'Schema_Name.old_table_name', 'new_table_name';


--RENAME TABLE old_table_name TO new_table_name; --> Not supported in SQL Server. Supported in MySQL.


--DROP DATABASE
DROP DATABASE [YOUR_DATABASE_NAME] --AUTO COMMIT, EXECUTE WITH CAUTION.
GO


--DROP TABLE
DROP TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]     --DDL, AUTO COMMIT, DELETE DATA & STRUCTURE, FASTER EXECUTION, EXECUTE WITH CAUTION.
GO

--TRUNCATE TABLE
TRUNCATE TABLE [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] --DDL, AUTO COMMIT, DELETE DATA BUT HOLD THE TABLE STRUCTURE, FASTER EXECUTION THAN DELETE, EXECUTE WITH CAUTION.
GO

--Comments --> Two types of comments are there. Single Line Comment & Multi Line Comment

--Single Line Comment -> Single line comments start with -- (the line will not be executed & we can use it inline also, in between any words or line). Example:
-- SELECT * FROM Customers;
SELECT * FROM Customers -- WHERE City='Berlin';


--Multi Line Comment -> Multi-line comments start with /* and end with */. Any text between /* and */ will be ignored. Example:
/*SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Categories;*/

SELECT CustomerName, /*City,*/ Country FROM Customers;


--DML COMMANDS -> DATA MANIPULATION LANGUAGE --> By default Auto Committed in SQL Server. So, execute with caution. In other DBMS like Oracle those are not auto committed. It is used for manipulating the data in a DB.
--1.INSERT	   -> To insert data into a table.
--2.UPDATE     -> To update existing records in a table.
--3.DELETE	   -> To delete unwanted records from a table.


--DELETE TABLE
DELETE FROM [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] WHERE (CONDITIONS) --DML, AUTO COMMIT IN SQL SERVER, DELETE SPECIFIC DATA BUT HOLD THE TABLE STRUCTURE, ROW BY ROW OPERATION, EXECUTE WITH CAUTION.
GO

DELETE FROM [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]; --DML, AUTO COMMIT IN SQL SERVER, DELETE ENTIRE DATA IF WHERE CONDITION NOT SPECIFIED, HOLD THE TABLE STRUCTURE, ROW BY ROW OPERATION, EXECUTE WITH CAUTION.
GO


--INSERT DATA IN A TABLE
--METHOD 1: INSERT DATA IN ALL THE COLUMNS OF A TABLE BY SPECIFYING COLUMN NAMES. COLUMN ORDER IS NOT MANDATORY HERE.
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
			(COLUMN1, COLUMN2, COLUMN3,....,COLUMNn)  
VALUES		(VALUE1, VALUE2, VALUE3,.....,VALUEn)
GO  

--METHOD 2: INSERT DATA IN SPECIFIC COLUMNS OF A TABLE. WE HAVE TO SPECIFY COLUMN NAMES IN THIS METHOD.
--          If we miss any column then that column will contains NULL value and if that column has default constraint then that value will be inserted.
--			If a column has not null constraint and we don't want to insert the in that column this operation will throw an error.
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
			(COLUMN1, COLUMN2, COLUMN3)  
VALUES		(VALUE1, VALUE2, VALUE3)
GO 

--METHOD 3: INSERT DATA IN ALL COLUMNS OF A TABLE. WE DON'T NEED TO SPECIFY COLUMN NAMES IN THIS METHOD. 
--          BUT USING THIS METHOD WE CAN'T INSERT DATA FOR SPECIFIC NUMBER OF COLUMNS, WE HAVE TO INSERT DATA FOR ALL FIELDS. HERE COLUMN ORDER IS MANDATORY.
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]
VALUES		(VALUE1, VALUE2, VALUE3,.....,VALUEn)
GO

--MULTIPLE INSERT INTO
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME]
VALUES		(VALUE1, VALUE2, VALUE3,.....,VALUEn),
            (VALUE1, VALUE2, VALUE3,.....,VALUEn),
			(VALUE1, VALUE2, VALUE3,.....,VALUEn),
			(VALUE1, VALUE2, VALUE3,.....,VALUEn),
			(VALUE1, VALUE2, VALUE3,.....,VALUEn)
GO
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
			(COLUMN1, COLUMN2, COLUMN3,....,COLUMNn)  
VALUES		(VALUE1, VALUE2, VALUE3,.....,VALUEn),
            (VALUE1, VALUE2, VALUE3,.....,VALUEn),
			(VALUE1, VALUE2, VALUE3,.....,VALUEn),
			(VALUE1, VALUE2, VALUE3,.....,VALUEn),
			(VALUE1, VALUE2, VALUE3,.....,VALUEn)
GO
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
			(COLUMN1, COLUMN2, COLUMN3)  
VALUES		(VALUE1, VALUE2, VALUE3),
			(VALUE1, VALUE2, VALUE3),
			(VALUE1, VALUE2, VALUE3),
			(VALUE1, VALUE2, VALUE3),
			(VALUE1, VALUE2, VALUE3)
GO 

--Copy all column's data from one table to another table.
--The INSERT INTO SELECT statement copies data from one table and inserts it into another table. The existing records in the target table are unaffected.
--The INSERT INTO SELECT statement requires that the data types and the number of columns in source and target tables should match
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TARGET_TABLE_NAME]  
			(COLUMN1, COLUMN2, COLUMN3,....,COLUMNn)
SELECT		 COLUMN1, COLUMN2, COLUMN3,....,COLUMNn
FROM		[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[SOURCE_TABLE_NAME]
WHERE		[condition(s)]
GO  

--Copy all column's data from one table to another table: If target and source table structure is exactly same we don't have to write columns name 
INSERT INTO		[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TARGET_TABLE_NAME] 
SELECT * FROM	[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[SOURCE_TABLE_NAME]
GO

--Copy all column's specific data from one table to another table: If target and source table structure is exactly same we don't have to write columns name 
INSERT INTO		[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TARGET_TABLE_NAME] 
SELECT * FROM	[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[SOURCE_TABLE_NAME]
WHERE			[condition(s)]
GO

--Copy only some columns from one table into another table:
INSERT INTO [SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TARGET_TABLE_NAME]  
			(column1, column2, column3, ...)
SELECT		 column1, column2, column3, ...
FROM		[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[SOURCE_TABLE_NAME]
WHERE		[conditions]
GO

--We can insert new rows by using multiple tables.
INSERT INTO employee_addresses
SELECT employee_id, first_name, last_name, city || ' - ' || street address AS address
FROM employees
JOIN departments USING (department_id) 
JOIN locations USING (location_id)
GO

--UPDATE A COLUMN OF A TABLE
UPDATE TABLE	[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
SET				[COLUMN_NAME] = "VALUE"
WHERE			[CONDITIONS];

--UPDATE MULTIPLE COLUMNS OF A TABLE
UPDATE TABLE	[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
SET				[COLUMN_NAME1] = "VALUE1" , [COLUMN_NAME2] = "VALUE2", [COLUMN_NAME3] = "VALUE3",...,[COLUMN_NAMEn] = "VALUEn"
WHERE			[CONDITIONS];

--UPDATE STATEMENT OMITTING WHERE CLAUSE
--ALL RECORDS WILL BE UPDATED
UPDATE TABLE	[SERVER_NAME].[DATABASE_NAME].[SCHEMA_NAME].[TABLE_NAME] 
SET				[COLUMN_NAME1] = "VALUE1" , [COLUMN_NAME2] = "VALUE2", [COLUMN_NAME3] = "VALUE3",...,[COLUMN_NAMEn] = "VALUEn";


--Difference among Drop, Truncate & Delete

--Point 1) 
--			Drop & Truncate are DDL Command so by default it is auto committed.
--			Delete is a DML Command so, by default it is not auto committed in other DBMS(s) but by default it is auto committed in SQL Server.
--Point 2) 
--			Drop will drop the entire table data as well as table structure in one go.												  (**remove the table structure)
--			Truncate will delete all data of a table in one go but it holds the table structure. Table structure will remain same.    (**Doesn't remove the table structure)
--			Delete is used to delete one or multiple tuples of a table. It is row by row operation. Table structure will remain same. (**Doesn't remove the table structure)
--Point 3) 
--			In Drop, don't need to specify WHERE clause. 
--			In Truncate, don't need to specify WHERE clause.
--			In Delete, we can pass/specify WHERE clause.
--Point 4) 
--			Drop is the fastest operation among these three. 
--			Truncate is comparatively faster than Delete but slower than Drop. (**Locks all the row at once)
--			Delete is the slowest operation among these three.				   (**Locks one row at a time)
--Point 5) 
--			Drop removes the space allocated for the table from memory. 		   (** Integrity constraints get removed)
--			Truncate doesn't remove the space allocated for the table from memory. (** Integrity constraints remains the same)
--			Delete doesn't remove the space allocated for the table from memory.   (** Integrity constraints remains the same)


--DQL COMMANDS	-> DATA QUERY LANGUAGE
--1. SELECT		-> To select any data from table(s).

--Select all data from a table
SELECT	*
FROM	[AdventureWorks2022].[HumanResources].[Employee]
GO

--or
SELECT [BusinessEntityID]
      ,[NationalIDNumber]
      ,[LoginID]
      ,[OrganizationNode]
      ,[OrganizationLevel]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
FROM   [AdventureWorks2022].[HumanResources].[Employee]
GO

--Select specific data from a table
SELECT [BusinessEntityID]
      ,[NationalIDNumber]
      ,[LoginID]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
FROM   [AdventureWorks2022].[HumanResources].[Employee]
GO


--DCL COMMANDS -> DATA CONTROL LANGUAGE. It controls the access permissions.
--1. GRANT	   -> To give access/permission to user(s).
--2. REVOKE	   -> To withdraw access/permission from user(s).


--TCL COMMANDS	    -> TRANSACTION CONTROL LANGUAGE. It controls the transaction.
--BEGIN			    -> To mark the starting point of an explicit, local transaction. USED in SQL Server
--START TRANSACTION -> To mark the starting point of an explicit, local transaction. USED in MYSQL. Syntax: START TRANSACTION transaction_name
--COMMIT 		    -> To commit the running transaction.
--ROLLBACK		    -> To rollback the current transaction.
--SAVEPOINT 	    -> To save a point, so that next time it will start from here. Used in ORACLE, MYSQL. Syntax: SAVEPOINT savepoint_name
--SAVE			    -> To save a point, so that next time it will start from here. USED in SQL Server
--SET TRANSACTION   -> To specify the characteristics of the transaction.


--Begin a explicit transaction -> Marks the starting point of an explicit, local transaction. Explicit transactions start with the BEGIN TRANSACTION statement and end with the COMMIT or ROLLBACK statement.
--Inside "Begin" DML/DDL(s) are not auto committed.
BEGIN		TRAN / TRANSACTION							--You can use either "TRAN" or "TRANSACTION"
			[TRANSACTION_NAME / @tran_name_variable]	--This Argument is Optional. This is used to assigned a name to the transaction. 
														--transaction_name must conform to the rules for identifiers, but identifiers longer than 32 characters aren't allowed. 
														--Use transaction names only on the outermost pair of nested BEGIN...COMMIT or BEGIN...ROLLBACK statements. 
														--transaction_name is always case sensitive, even when the instance of SQL Server isn't case sensitive. 
														--@tran_name_variable: The name of a user-defined variable containing a valid transaction name. The variable must be declared with a char, varchar, nchar, or nvarchar data type. 
														--If more than 32 characters are passed to the variable, only the first 32 characters are used. The remaining characters are truncated.
			[WITH MARK ['description'] ]				--This Argument is Optional. The WITH MARK option causes the transaction name to be placed in the transaction log. WE HAVE TO SPECIFY TRANSACTION NAME.
														--Specifies that the transaction is marked in the log. description is a string that describes the mark. 
														--A description longer than 128 characters is truncated to 128 characters before being stored in the msdb.dbo.logmarkhistory table.
														--If WITH MARK is used, a transaction name must be specified. WITH MARK allows for restoring a transaction log to a named mark.
;

--Example 1:
BEGIN TRANSACTION;
DELETE 
FROM	HumanResources.JobCandidate
WHERE	JobCandidateID = 13;
COMMIT; --COMMIT TRAN --COMMIT TRANSACTION

--Example 2:
CREATE TABLE ValueTable (id INT);
BEGIN TRANSACTION T1;
    INSERT INTO ValueTable VALUES(1);
    INSERT INTO ValueTable VALUES(2);
COMMIT T1;

--Example 3:
DECLARE @TranName VARCHAR(20);
SELECT @TranName = 'MyTransaction';

BEGIN TRANSACTION @TranName;
USE AdventureWorks2022;
DELETE FROM AdventureWorks2022.HumanResources.JobCandidate
    WHERE JobCandidateID = 13;

COMMIT TRANSACTION @TranName;
GO

--Example 4:
BEGIN TRANSACTION CandidateDelete
    WITH MARK N'Deleting a Job Candidate';
GO
USE AdventureWorks2022;
GO
DELETE FROM AdventureWorks2022.HumanResources.JobCandidate
    WHERE JobCandidateID = 13;
GO
COMMIT TRANSACTION CandidateDelete;
GO

--Commit a transaction -> Marks the end of a successful implicit or explicit transaction.
COMMIT		TRAN / TRANSACTION 
			[TRANSACTION_NAME / @tran_name_variable] 
			[ WITH  DELAYED_DURABILITY =  OFF / ON]; --Option that requests this transaction should be committed with delayed durability. The request is ignored if the database was altered with DELAYED_DURABILITY = DISABLED or DELAYED_DURABILITY = FORCED.

--See aboves examples(BEGIN section) for better understanding.

COMMIT [ WORK ]  
;
--This statement functions identically to COMMIT TRANSACTION, except COMMIT TRANSACTION accepts a user-defined transaction name. 
--This COMMIT syntax, with or without specifying the optional keyword WORK, is compatible with SQL-92.

--Rollback a transaction -> Rolls back a user-specified transaction to the beginning of the transaction.
--This statement rolls back an explicit or implicit transaction to the beginning of the transaction, or to a savepoint inside the transaction. 
--You can use ROLLBACK TRANSACTION to erase all data modifications made from the start of the transaction or to a savepoint. 
--It also frees resources held by the transaction.
--Rolling back a transaction doesn't include changes made to local variables or table variables. These changes aren't erased by this statement.

ROLLBACK	TRAN / TRANSACTION 
			[TRANSACTION_NAME / @tran_name_variable| savepoint_name | @savepoint_variable ];

--savepoint_name:		savepoint_name from a SAVE TRANSACTION statement. savepoint_name must conform to the rules for identifiers. 
--						Use savepoint_name when a conditional rollback should affect only part of the transaction.
--@savepoint_variable:	The name of a user-defined variable containing a valid savepoint name. The variable must be declared with a char, varchar, nchar, or nvarchar data type.

--Example 1:
BEGIN TRANSACTION;
DELETE 
FROM	HumanResources.JobCandidate
WHERE	JobCandidateID = 13;
ROLLBACK; --ROLLBACK TRAN --ROLLBACK TRANSACTION

--Example 2:
CREATE TABLE ValueTable (id INT);
BEGIN TRANSACTION T1;
    INSERT INTO ValueTable VALUES(1);
    INSERT INTO ValueTable VALUES(2);
ROLLBACK T1;

--Example 3:
DECLARE @TranName VARCHAR(20);
SELECT @TranName = 'MyTransaction';

BEGIN TRANSACTION @TranName;
USE AdventureWorks2022;
DELETE FROM AdventureWorks2022.HumanResources.JobCandidate
    WHERE JobCandidateID = 13;

ROLLBACK TRANSACTION @TranName;
GO

--Example 4:
BEGIN TRANSACTION CandidateDelete
    WITH MARK N'Deleting a Job Candidate';
GO
USE AdventureWorks2022;
GO
DELETE FROM AdventureWorks2022.HumanResources.JobCandidate
    WHERE JobCandidateID = 13;
GO
ROLLBACK TRANSACTION CandidateDelete;
GO

ROLLBACK TO SAVEPOINT SAVEPOINT_NAME; --Used in Oracle & MYSQL

ROLLBACK [ WORK ]  
;  

--This statement functions identically to ROLLBACK TRANSACTION except that ROLLBACK TRANSACTION accepts a user-defined transaction name. 
--With or without specifying the optional WORK keyword, this ROLLBACK syntax is ISO-compatible.
--When nesting transactions, ROLLBACK WORK always rolls back to the outermost BEGIN TRANSACTION statement and decrements the @@TRANCOUNT system function to 0.

--Save a Transaction -> Sets a savepoint within a transaction.
--A user can set a savepoint, or marker, within a transaction. The savepoint defines a location to which a transaction can return if part of the transaction is conditionally canceled. 
--If a transaction is rolled back to a savepoint, it must proceed to completion with more Transact-SQL statements if needed and a COMMIT TRANSACTION statement, or it must be canceled altogether by rolling the transaction back to its beginning. 
--To cancel an entire transaction, use the form ROLLBACK TRANSACTION transaction_name. All the statements or procedures of the transaction are undone.
--Duplicate savepoint names are allowed in a transaction, but a ROLLBACK TRANSACTION statement that specifies the savepoint name will only roll the transaction back to the most recent SAVE TRANSACTION using that name.
--A ROLLBACK TRANSACTION statement specifying a savepoint_name releases any locks that are acquired beyond the savepoint, with the exception of escalations and conversions. 
--These locks are not released, and they are not converted back to their previous lock mode.

SAVE TRANSACTION is not supported in distributed transactions started either explicitly with BEGIN DISTRIBUTED TRANSACTION or escalated from a local transaction.
SAVE TRAN / TRANSACTION 
	[savepoint_name | @savepoint_variable]; 

--Example - Copied from https://learn.microsoft.com/en-us/sql/t-sql/language-elements/save-transaction-transact-sql?view=sql-server-ver16
USE AdventureWorks2022;  
GO  
IF EXISTS (SELECT name FROM sys.objects  
           WHERE name = N'SaveTranExample')  
    DROP PROCEDURE SaveTranExample;  
GO  
CREATE PROCEDURE SaveTranExample  
    @InputCandidateID INT  
AS  
    -- Detect whether the procedure was called  
    -- from an active transaction and save  
    -- that for later use.  
    -- In the procedure, @TranCounter = 0  
    -- means there was no active transaction  
    -- and the procedure started one.  
    -- @TranCounter > 0 means an active  
    -- transaction was started before the   
    -- procedure was called.  
    DECLARE @TranCounter INT;  
    SET @TranCounter = @@TRANCOUNT;  
    IF @TranCounter > 0  
        -- Procedure called when there is  
        -- an active transaction.  
        -- Create a savepoint to be able  
        -- to roll back only the work done  
        -- in the procedure if there is an  
        -- error.  
        SAVE TRANSACTION ProcedureSave;  
    ELSE  
        -- Procedure must start its own  
        -- transaction.  
        BEGIN TRANSACTION;  
    -- Modify database.  
    BEGIN TRY  
        DELETE HumanResources.JobCandidate  
            WHERE JobCandidateID = @InputCandidateID;  
        -- Get here if no errors; must commit  
        -- any transaction started in the  
        -- procedure, but not commit a transaction  
        -- started before the transaction was called.  
        IF @TranCounter = 0  
            -- @TranCounter = 0 means no transaction was  
            -- started before the procedure was called.  
            -- The procedure must commit the transaction  
            -- it started.  
            COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        -- An error occurred; must determine  
        -- which type of rollback will roll  
        -- back only the work done in the  
        -- procedure.  
        IF @TranCounter = 0  
            -- Transaction started in procedure.  
            -- Roll back complete transaction.  
            ROLLBACK TRANSACTION;  
        ELSE  
            -- Transaction started before procedure  
            -- called, do not roll back modifications  
            -- made before the procedure was called.  
            IF XACT_STATE() <> -1  
                -- If the transaction is still valid, just  
                -- roll back to the savepoint set at the  
                -- start of the stored procedure.  
                ROLLBACK TRANSACTION ProcedureSave;  
                -- If the transaction is uncommitable, a  
                -- rollback to the savepoint is not allowed  
                -- because the savepoint rollback writes to  
                -- the log. Just return to the caller, which  
                -- should roll back the outer transaction.  
  
        -- After the appropriate rollback, echo error  
        -- information to the caller.  
        DECLARE @ErrorMessage NVARCHAR(4000);  
        DECLARE @ErrorSeverity INT;  
        DECLARE @ErrorState INT;  
  
        SELECT @ErrorMessage = ERROR_MESSAGE();  
        SELECT @ErrorSeverity = ERROR_SEVERITY();  
        SELECT @ErrorState = ERROR_STATE();  
  
        RAISERROR (@ErrorMessage, -- Message text.  
                   @ErrorSeverity, -- Severity.  
                   @ErrorState -- State.  
                   );  
    END CATCH  
GO

SET TRANSACTION [ READ WRITE | READ ONLY ]; --Used in Oracle & MYSQL.

--SET statement : https://learn.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql?view=sql-server-ver16
--CTAS stands for "Create Table As Select". --> This syntax is not supported in SQL Server. We can use it in Oracle.
--Create a Table using another table (AS SELECT STATEMENT) ->CTAS
--If we create a new table using an old table, the new table will be filled with the existing value from the old table. The basic syntax for creating a table with the other table is:
CREATE TABLE table_name [(column1, column2)] AS  
SELECT column1, column2, ...   
FROM old_table_name WHERE condition;  


--A table can be copied with all its table structure and its data.
CREATE TABLE [HumanResources].[Employee_Copy] AS SELECT * FROM [HumanResources].[Employee];


--A table's structure can be copied without any data.
CREATE TABLE employees_copy AS (SELECT * FROM employees WHERE 1=2);


--A table can be created by copying some specific data from another table.
CREATE TABLE employees_copy AS (SELECT * FROM employees WHERE job_id = 'IT_PROG');


--A table can be created from another table, using only some of the columns.
CREATE TABLE employees_copy AS SELECT first_name, last_name, salary FROM employees;


--Column names can be defined differently from the SELECT list while creating a   table.
CREATE TABLE employees_copy (name, surname, annual salary) AS SELECT first_name, last_name, 12*salary FROM employees;


--The number of specified columns must match with the number    of columns in the SELECT list. Otherwise, it returns an error.
CREATE TABLE employees_copy (name, surname) AS SELECT first_name, last_name, 12*salary FROM employees;


--**Important: While creating a table from a SELECT query, the only constraints that are inherited are the NOT NULL constraints other than this constraint we have to add other constraints explicitly. 


--Reference Links
--1. https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver16
--2. https://www.w3schools.com/sql/
--3. https://www.javatpoint.com/sql-tutorial
