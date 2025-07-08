/***************************************************************************************************************************************
Code Description	 : ALTER A COLUMN FROM NULL TO NOT NULL IF COLUMN CONTAINS NULL TUPLES/RECORDS									   *
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

--Create Table for testing
CREATE TABLE DBO.EMP_NULL(
							EMP_ID			INT			PRIMARY KEY,
							F_NAME			VARCHAR(50)	NOT NULL,
							L_NAME			VARCHAR(50) NOT NULL,
							AGE				INT			,
							DEPARTMENT_ID	INT			
)


--Insert data into the table for testing
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (101, 'TOM',     'DEY',      20, 1000)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (102, 'JERRY',   'DAS',      25, 1002)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (103, 'RAM',     'BASU',     30, 1005)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME)					   VALUES (104, 'SAM',     'GHOSH')
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (105, 'BOB',	   'BOSE',      22, 1001)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (106, 'DOREMON', 'CHATERJEE', 26, 1004)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, DEPARTMENT_ID)	   VALUES (107, 'NABITA',  'BANERJEE',  1000)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (108, 'JACK',    'ADHIKARY',  40, 1002)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME, AGE, DEPARTMENT_ID)  VALUES (109, 'BEAN',    'SINGH',     35, 1005)
INSERT INTO DBO.EMP_NULL (EMP_ID, F_NAME, L_NAME)					   VALUES (110, 'OSCAR',   'WILD')

--See the inserted data
SELECT * FROM DBO.EMP_NULL

ALTER TABLE DBO.EMP_NULL ALTER COLUMN DEPARTMENT_ID INT NOT NULL; -- THIS WILL GIVE AN ERROR AS AGE COLUMN CONTAINS NULL VALUES

--TO ALTER A COLUMN FROM NULL TO NOT NULL IF COLUMN CONTAINS NULL TUPLES/RECORDS

--STEP 1   -> Update NULL Values to a Default Value(e.g., 0)
UPDATE	DBO.EMP_NULL 
SET		AGE = 0 
WHERE	AGE IS NULL; --UPDATE NULL VALUES TO ZERO. Can become slow on large tables if many NULL rows need to be scanned or deleted due to potential locking and logging.

--Or use Conditional Update,
UPDATE DBO.EMP_NULL
SET AGE = CASE 
                   WHEN AGE IS NULL THEN 0
                   ELSE AGE
                 END;

--Or use ISNULL or COALESCE During Update
UPDATE DBO.EMP_NULL
SET AGE = ISNULL(AGE, 0);

--STEP 2 -> Then Alter
ALTER TABLE  DBO.EMP_NULL 
ALTER COLUMN AGE INT NOT NULL;

--DROP TABLE DBO.EMP_NULL
