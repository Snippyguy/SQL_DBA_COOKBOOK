/***************************************************************************************************************************************
Code Description	 : Execution & Writing Orders in SQL														                       *
Author Name			 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website				 : www.snippyguy.com																							   *
License				 : MIT, CC0																										   *
Creation Date		 : 30/11/2024																									   *
Last Modified By	 : 30/11/2024																									   *
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

/*SQL order of writing :-
When writing SQL queries, we usually follow a certain order (SQL is known to be written from the inside-out).
However, the SQL engines follow a specific order of execution when compiling queries, which is different from the typical order of writing.
*/

--Writing order is:-
--1. SELECT
--2. TOP
--3. DISTINCT
--4. FROM
--5. JOIN
--6. WHERE
--7. GROUP BY
--8. HAVING
--9. ORDER BY
--10.QUALIFY
--11.LIMIT/OFFSET

/*SQL order of execution :-
The SQL order of execution defines the order in which the clauses of a query are evaluated. 
sometimes called the SQL order of operations. 
The order of execution of SQL Query optimizes the query, reduces the amount of data to be processed, and significantly affects the performance of the Query processing.
The order makes the SQL engine process the queries faster, and efficiently and obtains optimized query results. 
Understanding this SQL query execution order helps to debug the code, write efficient queries, and trace the output of SQL accurately.
In the modern world, SQL query planners can do all sorts of tricks to make queries run more efficiently, but they must always reach the same final answer as a query that is executed per the standard SQL order of execution. */

--Execution order is:-
--1. FROM		  -> Getting data (Define the scope)
--2. JOIN		  -> Getting data (Define the scope)
--3. WHERE		  -> Row Filter
--4. GROUP BY	  -> Group the rows
--5. HAVING		  -> Filtered the grouped rows
--6. SELECT		  -> Return expression
--7. WINDOW
--8. QUALIFY
--9. DISTINCT	  -> Remove duplicates
--10.ORDER BY	  -> Ordering the Data
--11.TOP
--12.LIMIT/OFFSET -> Paging the data (Limiting)

--Example:-

-- #6+7   SELECT DISTINCT department_id                                 
-- #1     FROM employees                                                
-- #2     JOIN orders ON customers.customer_id = orders.customer_id     
-- #3     WHERE salary > 3000                                          
-- #4     GROUP BY department 
-- #5     HAVING AVG(salary) > 5000 
-- #8     ORDER BY department 
-- #9     LIMIT 10 OFFSET 5 
-- #10    OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY; 

/*Common mistakes:- The following are the common mistakes that might hinder your query performance.

*Using Column Aliases in the WHERE Clause: Since the WHERE clause is executed before the SELECT clause, trying to use an alias in WHERE will result in an error. 
										   Understanding that SQL evaluates WHERE before the SELECT clause teaches you that you need to repeat the full expression instead of relying on an alias.

*Using HAVING for Row Filtering Instead of WHERE: The HAVING clause is executed after GROUP BY and is designed for filtering aggregated data. 
												  If you're filtering non-aggregated data, it belongs in the WHERE clause. 
												  Knowing the difference in execution order between WHERE and HAVING helps you determine where each condition should be placed.

*Incorrect Use of Aggregates in SELECT Without GROUP BY: Since GROUP BY is executed before HAVING or SELECT, failing to group your data before applying an aggregate function will lead to incorrect results or errors. 
														 Understanding the execution order clarifies why these two clauses must go together.

*Not Using Aliases Properly in the ORDER BY Clause: Unlike the WHERE clause, the ORDER BY clause is evaluated after SELECT. 
													This allows you to use aliases created in SELECT for sorting, helping you avoid confusion by knowing when aliases are available for use.*/

/*Best practices :- Consider the following best practices to ensure your queries execute as expected.

*Filter Early with WHERE: Since the WHERE clause is executed before GROUP BY and JOIN, applying filters early reduces the number of rows processed by subsequent clauses, improving query performance. 
						  By filtering non-aggregated data as early as possible, you limit the data that needs to be grouped or joined, saving processing time.

*Pre-Aggregate Data Before Joins: Knowing that FROM and JOIN are the first clauses executed, pre-aggregating data using subqueries or common table expressions (CTEs) allows you to shrink the dataset before the join process. 
								  This ensures that fewer rows are processed during the join.

*Optimize ORDER BY with Indexes: Since the ORDER BY clause is one of the last executed steps, ensuring that the sorted columns are indexed will speed up query performance by helping the database handle sorting operations more efficiently.

*Avoid SELECT * in Production Queries: The SELECT clause is executed after filtering, grouping, and aggregating, so specifying only the needed columns minimizes the amount of data retrieved, reducing unnecessary overhead.*/

