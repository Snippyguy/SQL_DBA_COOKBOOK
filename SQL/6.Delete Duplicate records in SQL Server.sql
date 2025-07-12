/***************************************************************************************************************************************
Code Description	 : Delete Duplicate records in SQL Server																		   *
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

--Method 1: Using ROW_NUMBER() with a Common Table Expression (CTE) 
--**Most Efficient and Optimized: Method 1 (Using ROW_NUMBER() with CTE) for its balance of performance, scalability, and ease of implementation.**
--This method identifies duplicates using ROW_NUMBER(), allowing you to delete all but one record within each group of duplicates.
--Cons: Performance can be affected on large datasets without appropriate indexes on the PARTITION BY columns.
--Best for: Moderate to large datasets with occasional deduplication.
WITH CTE AS (
				SELECT  *,
						ROW_NUMBER() OVER (PARTITION BY first_name, last_name, age, salary ORDER BY (SELECT 0)) AS RowNum --ORDER BY (SELECT 0) doesn't actually order the rows meaningfully; it is a placeholder to ensure the syntax is correct for generating row numbers. The ROW_NUMBER() function still needs an ORDER BY clause but since ordering isn't required for deletion, this ensures consistent numbering within the partition.
				FROM Employee
			)
DELETE FROM CTE
WHERE RowNum > 1;

--Method 2: Using SELF JOIN
--Inefficient on large datasets as it requires a self-join, which can lead to high memory and CPU usage due to comparing rows against each other.
--Best for: Small datasets or quick, simple deduplication tasks.
DELETE T1
FROM Employee T1
INNER JOIN Employee T2
ON 
    T1.first_name = T2.first_name
    AND T1.last_name = T2.last_name
    AND T1.age = T2.age
    AND T1.salary = T2.salary
    AND T1.PrimaryKey > T2.PrimaryKey;

--The condition T1.PrimaryKey > T2.PrimaryKey ensures that only one row is retained for each duplicate combination. (PrimaryKey is like Emp_ID column)
--It deletes the row with the higher PrimaryKey value, leaving the one with the lower value. 
--This condition is crucial because it prevents all matching rows from being deleted, which would leave no data behind.
--The PrimaryKey is assumed to be a unique identifier for the table, such as an ID column, which makes it possible to distinguish between two otherwise identical rows.

--Method 3: Using GROUP BY with HAVING COUNT() > 1 and a Subquery
--Cons: Performance can degrade on large datasets due to grouping and aggregation operations. The query becomes slower as the number of duplicates increases.
--Best for: Medium-sized datasets with occasional deduplication.

DELETE FROM Employee
WHERE PrimaryKey NOT IN (
    SELECT MIN(PrimaryKey)
    FROM Employee
    GROUP BY first_name, last_name, age, salary
);

--Method 4: Using DISTINCT into a Temporary Table and TRUNCATE/INSERT Back (*Not a Recommended approach)
--Fast and efficient on large datasets because TRUNCATE is minimally logged compared to DELETE.
--Cons: Risky, as it involves data loss if not backed up. Does not preserve non-duplicate metadata like primary keys or extra columns. Best suited when you can temporarily adjust the table structure.
--Best for: Large datasets when deduplication must be performed quickly.
SELECT DISTINCT first_name, last_name, age, salary
INTO #TempTable
FROM Employee;

TRUNCATE TABLE Employee;

INSERT INTO Employee (first_name, last_name, age, salary)
SELECT first_name, last_name, age, salary
FROM #TempTable;

DROP TABLE #TempTable;

--Method 5: Using a Cursor to Iterate and Delete
--**Less efficient. Avoid using cursors for bulk deduplication due to their poor scalability.
--Pros: Provides granular control over the deletion process.
--Cons: Typically the least efficient method, as cursors are row-by-row operations and tend to be slower compared to set-based operations, especially on large datasets.
--Best for: Scenarios requiring precise, custom deduplication logic.
DECLARE @first_name NVARCHAR(100), @last_name NVARCHAR(100), @age INT, @salary DECIMAL;
DECLARE db_cursor CURSOR FOR
SELECT first_name, last_name, age, salary
FROM Employee
GROUP BY first_name, last_name, age, salary
HAVING COUNT(*) > 1;

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @first_name, @last_name, @age, @salary;

WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE TOP (1) FROM Employee
    WHERE first_name = @first_name AND last_name = @last_name AND age = @age AND salary = @salary;
    FETCH NEXT FROM db_cursor INTO @first_name, @last_name, @age, @salary;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;
