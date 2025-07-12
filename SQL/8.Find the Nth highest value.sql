/***************************************************************************************************************************************
Code Description	 : Find the Nth highest value																					   *
Author Name			 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website				 : www.snippyguy.com																							   *
License				 : MIT, CC0																										   *
Creation Date		 : 18/11/2024																									   *
Last Modified By 	 : 18/11/2024																									   *
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

--For large datasets, methods using window functions like ROW_NUMBER(), RANK(), or DENSE_RANK() tend to be more efficient than using subqueries or OFFSET-FETCH with DISTINCT.
--If you have tied values and you want them to be ranked similarly, use DENSE_RANK() or RANK().

--METHOD 1 ->
WITH RankedValues AS (
						SELECT  salary, 
								ROW_NUMBER() OVER (ORDER BY salary DESC) AS RowNum
						FROM    Employee
					)
SELECT salary
FROM RankedValues
WHERE RowNum = N; --Replace N with your desired value

--METHOD 2 ->
WITH RankedValues AS (
						SELECT  salary, 
								RANK() OVER (ORDER BY salary DESC) AS RowNum --RANK() works similarly to ROW_NUMBER(), but it assigns the same rank to tied values.
						FROM    Employee
					)
SELECT salary
FROM RankedValues
WHERE RowNum = N; --Replace N with your desired value

--METHOD 3 ->
WITH RankedValues AS (
						SELECT  salary, 
								DENSE_RANK() OVER (ORDER BY salary DESC) AS RowNum --DENSE_RANK() is similar to RANK(), but it does not skip rank numbers for tied values.
																				   --It assigns ranks to distinct salary values and returns the Nth highest salary by filtering on the rank.
						FROM    Employee
					)
SELECT salary
FROM RankedValues
WHERE RowNum = N; --Replace N with your desired value

--Example
SELECT * FROM (
				SELECT [Continent],[Country],[Capital],[Population],[Total area], DENSE_RANK() 
				OVER (ORDER BY [Population] DESC) AS 'POPULATION_RANK'
				FROM [TestDB].[dbo].[Asia]
			  )
AS TEMP
WHERE POPULATION_RANK = 3

--METHOD 4 -> Efficient for fetching rows with specific offsets, but works best when data is pre-sorted.
SELECT TOP 1 salary
FROM Employee
ORDER BY salary DESC
OFFSET N-1 ROWS			--OFFSET N-1 ROWS skips the first N-1 rows.
FETCH NEXT 1 ROWS ONLY; --FETCH NEXT 1 ROWS ONLY retrieves the next row after skipping, effectively giving you the Nth highest value.

--METHOD 5 ->
SELECT TOP 1 salary
FROM (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
) AS DistinctSalaries
ORDER BY salary DESC
OFFSET N-1 ROWS FETCH NEXT 1 ROWS ONLY;

--METHOD 6 ->
SELECT MAX(salary) AS NthHighestSalary
FROM Employee e1
WHERE (
    SELECT COUNT(DISTINCT salary)
    FROM Employee e2
    WHERE e2.salary > e1.salary
) = N-1; --When this count equals N-1, the outer query selects the MAX(salary), which will be the Nth highest.


--Using MAX -> BEST FOR FINDING 2ND HIGHEST VALUES
SELECT MAX([Population]) 
FROM   [TestDB].[dbo].[Asia] 
WHERE  [Population] < (
						SELECT MAX([Population]) 
						FROM   [TestDB].[dbo].[Asia]
					  )

--USING LIMIT -> Used in MySQL
SELECT DISTINCT([Population]) FROM [TestDB].[dbo].[Asia] ORDER BY [Population] DESC LIMIT 1,1 --OFFSET,ROWCOUNT --OFFSET N-1

--USING WITHOUT LIMIT
SELECT DISTINCT ([Population]) 
FROM   [TestDB].[dbo].[Asia] A 
WHERE 3-1 = (
			  SELECT COUNT( DISTINCT([Population])) 
			  FROM   [TestDB].[dbo].[Asia] B  
			  WHERE B.[Population] > A.[Population]
			)

--USING NOT IN or <> -> ONLY USEFUL FOR 2ND HIGHEST
SELECT MAX([Population]) 
FROM   [TestDB].[dbo].[Asia] 
WHERE  [Population] NOT IN (
							 SELECT MAX([Population]) 
							 FROM   [TestDB].[dbo].[Asia]
						   )

