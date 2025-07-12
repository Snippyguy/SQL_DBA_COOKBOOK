/***************************************************************************************************************************************
Code Description	 : Single SQL Query to Fetch First & Last Record																   *
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

--For Oracle -> ROWID is a oracle feature.
SELECT * FROM [TestDB].[dbo].[Actors] WHERE ROWID = ( SELECT MIN(ROWID) FROM [TestDB].[dbo].[Actors] )
UNION
SELECT * FROM [TestDB].[dbo].[Actors] WHERE ROWID = ( SELECT MAX(ROWID) FROM [TestDB].[dbo].[Actors] );

--Method 1: Using UNION ALL -> It performs two SELECT operations, which may not be optimal for large datasets.
--UNION ALL is faster than UNION as UNION ALL keeps the duplicate whereas UNION removes the duplicate.
SELECT TOP 1 * 
FROM Employee 
ORDER BY PrimaryKey ASC  -- Replace PrimaryKey with the column used to identify order such as Emp_ID.

UNION ALL

SELECT TOP 1 * 
FROM Employee 
ORDER BY PrimaryKey DESC;

--Method 2: Using ROW_NUMBER() -> It is flexible and can be used for complex ordering logic or multi-column ordering.
WITH RankedEmployees AS (
						  SELECT *,
						         ROW_NUMBER() OVER (ORDER BY PrimaryKey ASC) AS RowNumAsc,
						         ROW_NUMBER() OVER (ORDER BY PrimaryKey DESC) AS RowNumDesc
						  FROM Employee
						)
SELECT *
FROM  RankedEmployees
WHERE RowNumAsc = 1 OR RowNumDesc = 1;


--Method 3: Using MIN() and MAX() -> For small tables or when PrimaryKey is indexed, Method 3 is efficient and simple.
SELECT *
FROM  Employee
WHERE PrimaryKey = (SELECT MIN(PrimaryKey) FROM Employee)
   OR PrimaryKey = (SELECT MAX(PrimaryKey) FROM Employee);
