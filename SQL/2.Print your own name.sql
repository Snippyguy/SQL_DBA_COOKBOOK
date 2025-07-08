/***************************************************************************************************************************************
Code Description	 : Print your own name																							   *
Author Name			 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website				 : www.snippyguy.com																							   *
License				 : MIT, CC0																										   *
Creation Date		 : 15/11/2024																									   *
Last Modified By 	 : 15/11/2024																									   *
Last Modification	 : Initial Creation  																							   *
Modification History :  	 																										   *
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
PRINT 'Sayan Dey';

--Method 2
SELECT 'Sayan Dey';
SELECT 'Sayan Dey' Name;	       --In Alias AS keyword is optional
SELECT 'Sayan Dey' AS Name;	       --In this alias you can't pass space.
SELECT 'Sayan Dey' AS 'Full Name'; --If you want your alias to contain one or more spaces then use ''
SELECT 'Sayan Dey' AS "Full Name"; --If you want your alias to contain one or more spaces then use ""
SELECT 'Sayan Dey' AS [Full Name]; --If you want your alias to contain one or more spaces then use []

--Method 3
DECLARE @Msg VARCHAR(50) = 'Sayan Dey';
PRINT   @Msg;

DECLARE @Name NVARCHAR(50) = 'Sayan Dey';
SELECT  @Name AS 'Name';

--Method 4
EXEC('SELECT ''Sayan Dey'' AS Name'); --EXEC executes dynamic SQL statements

--Method 5
RAISERROR('Sayan Dey', 0, 1) WITH NOWAIT;

--'Sayan Dey': This is the message string that will be displayed. In this case, it's just a text string "Sayan Dey".
--0: This is the severity level of the error. Severity levels range from 0 to 25 in SQL Server.
--Levels from 0 to 10 are informational messages and do not indicate an error condition. 
--When you use 0 as the severity level, it essentially means the message is purely informational, similar to PRINT.
--1: This is the state of the error. The state value is a user-defined integer between 0 and 255 that can be used to differentiate between various instances of errors. 
--It is often set to 1 if there is no specific need for differentiation.
--WITH NOWAIT: This option forces the message to be immediately displayed to the output console (like in SSMS) without buffering. 
--Normally, messages might be delayed until a batch of statements completes. 
--WITH NOWAIT ensures you see the message as soon as RAISERROR is executed.

--Method 6
SELECT FORMATMESSAGE('%s', 'Sayan Dey') AS Name;

--FORMATMESSAGE is a SQL Server function that works similarly to printf or string.format in other programming languages. 
--It formats a string using a format specifier and replaces placeholders with provided values.
--%s is a placeholder for a string value. It indicates that a string argument will be inserted in that position in the final message.
