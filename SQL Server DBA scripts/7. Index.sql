/***************************************************************************************************************************************
Code Description	 : INDEX                            																		       *
Author Name		 	 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		     	 : www.snippyguy.com																							   *
License			 	 : MIT, CC0																										   *
Creation Date		 : 04/02/2024																									   *
Last Modified By 	 : 04/02/2024																									   *
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

-- Create a clustered index
/*
DATA SORTED AS PER KEY COLUMN
IT WILL NOT TAKE ANY ADDITIOANL DISK SPACE 
DATA REMAINS IN THE LEAF NODE
CLUSTERED INDEX WILL AUTOMATICALLY CREATED AGAINST PRIMARY KEY
ONE TABLE ONLY HAS ONE CLUSTERED INDEX
*/
CREATE CLUSTERED INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name] (column_name);
GO

-- Create a nonclustered index  
/*
It will take additional disk space for sorting data 
Leaf node contains pointer
One table has multiple NON CLUSTERED INDEX
*/
CREATE NONCLUSTERED INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name] (column_name);   
GO

-- Create an Unique index  
/*A unique index guarantees that the index key contains no duplicate values and therefore every row in the table is in some way unique. 
There are no significant differences between creating a UNIQUE constraint and creating a unique index that is independent of a constraint. 
Data validation occurs in the same manner.
When you create a unique index, you can set an option to ignore duplicate keys. 
If this option is set to Yes and you attempt to create duplicate keys by adding data that affects multiple rows (with the INSERT statement), the row containing a duplicate is not added. 
If it is set to No, the entire insert operation fails and all the data is rolled back.

You cannot create a unique index on a single column if that column contains NULL in more than one row. 
Similarly, you cannot create a unique index on multiple columns if the combination of columns contains NULL in more than one row. 
These are treated as duplicate values for indexing purposes.
*/
CREATE UNIQUE NONCLUSTERED INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name] (KEY_column_name) 
INCLUDE (nonkey_column_name(s))
WITH (IGNORE_DUP_KEY = OFF);
GO

--Create filtered indexes
/*
A filtered index is an optimized disk-based rowstore nonclustered index especially suited to cover queries that select from a well-defined subset of data. 
It uses a filter predicate to index a portion of rows in the table. 
A well-designed filtered index can improve query performance and reduce index maintenance and storage costs compared with full-table indexes.
*/
CREATE NONCLUSTERED INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name] (column_name)
WHERE condition;   
GO

--Create composite indexes
CREATE NONCLUSTERED INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name] (column_name1, column_name2 );   
GO

--Drop an Index
DROP INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name];   
GO  

--To modify index columns
--To add, remove, or change the position of an index column, you must drop and recreate the index.

--Disables an index  
ALTER INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name]  
DISABLE;

--To disable all indexes on a table
ALTER INDEX ALL ON [instanc_name].[databse_name].[schema_name].[table_name] 
DISABLE; 

/*
Nonclustered Index Action			When both the clustered and nonclustered indexes are disabled.	When the clustered index is enabled and the nonclustered index is in either state.
---------------------------			--------------------------------------------------------------	----------------------------------------------------------------------------------
ALTER INDEX REBUILD.				The action fails.												The action succeeds.
DROP INDEX.							The action succeeds.											The action succeeds.
CREATE INDEX WITH DROP_EXISTING.	The action fails.												The action succeeds.
*/

--To enable a disabled index using ALTER INDEX
ALTER INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name]  
REBUILD;   
GO 

--To enable a disabled index using CREATE INDEX
CREATE INDEX [index_name] ON [instanc_name].[databse_name].[schema_name].[table_name]  
(Column_names)  
WITH (DROP_EXISTING = ON);  
GO 

--To enable a disabled index using DBCC DBREINDEX 
DBCC DBREINDEX ("[databse_name].[schema_name].[table_name]", [index_name]);  
GO  

--To enable all indexes on a table using ALTER INDEX
ALTER INDEX ALL ON [instanc_name].[databse_name].[schema_name].[table_name]  
REBUILD;  
GO  

--To enable all indexes on a table using DBCC DBREINDEX
DBCC DBREINDEX ("[databse_name].[schema_name].[table_name]", " ");  
GO  

--Rename an Index
EXEC sp_rename N'schema_name.table_name.old_index_name', N'new_index_name', N'INDEX';   
GO

--Alter an Index & SET options
ALTER INDEX ALL ON [schema_name].[table_name]
REBUILD WITH 
   (
       FILLFACTOR = 80
       , SORT_IN_TEMPDB = ON
       , STATISTICS_NORECOMPUTE = ON
   )
;

--Index DMV
SELECT * FROM sys.indexes;

--To see the properties of all the indexes in a table
SELECT	  i.name AS index_name
		, i.type_desc
		, i.is_unique
		, ds.type_desc AS filegroup_or_partition_scheme
		, ds.name AS filegroup_or_partition_scheme_name
		, i.ignore_dup_key
		, i.is_primary_key
		, i.is_unique_constraint
		, i.fill_factor
		, i.is_padded
		, i.is_disabled
		, i.allow_row_locks
		, i.allow_page_locks
		, i.has_filter
		, i.filter_definition
FROM sys.indexes AS i
INNER JOIN sys.data_spaces AS ds
      ON i.data_space_id = ds.data_space_id
WHERE is_hypothetical = 0 AND i.index_id <> 0
AND i.object_id = OBJECT_ID('[schema_name].[table_name]')
;

--The following query uses the missing index DMVs to generate CREATE INDEX statements.
SELECT TOP 20
    CONVERT (varchar(30), getdate(), 126) AS runtime,
    CONVERT (decimal (28, 1), 
        migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) 
        ) AS estimated_improvement,
    'CREATE INDEX missing_index_' + 
        CONVERT (varchar, mig.index_group_handle) + '_' + 
        CONVERT (varchar, mid.index_handle) + ' ON ' + 
        mid.statement + ' (' + ISNULL (mid.equality_columns, '') + 
        CASE
            WHEN mid.equality_columns IS NOT NULL
            AND mid.inequality_columns IS NOT NULL THEN ','
            ELSE ''
        END + ISNULL (mid.inequality_columns, '') + ')' + 
        ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement
FROM sys.dm_db_missing_index_groups mig
JOIN sys.dm_db_missing_index_group_stats migs ON 
    migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON 
    mig.index_handle = mid.index_handle
ORDER BY estimated_improvement DESC;
GO

--The following query retrieves the top 20 query plans containing missing index requests from query store based on a rough estimate of total logical reads for the query. 
--The data is limited to query executions within the past 48 hours.
SELECT TOP 20
    qsq.query_id,
    SUM(qrs.count_executions) * AVG(qrs.avg_logical_io_reads) as est_logical_reads,
    SUM(qrs.count_executions) AS sum_executions,
    AVG(qrs.avg_logical_io_reads) AS avg_avg_logical_io_reads,
    SUM(qsq.count_compiles) AS sum_compiles,
    (SELECT TOP 1 qsqt.query_sql_text FROM sys.query_store_query_text qsqt
        WHERE qsqt.query_text_id = MAX(qsq.query_text_id)) AS query_text,    
    TRY_CONVERT(XML, (SELECT TOP 1 qsp2.query_plan from sys.query_store_plan qsp2
        WHERE qsp2.query_id=qsq.query_id
        ORDER BY qsp2.plan_id DESC)) AS query_plan
FROM sys.query_store_query qsq
JOIN sys.query_store_plan qsp on qsq.query_id=qsp.query_id
CROSS APPLY (SELECT TRY_CONVERT(XML, qsp.query_plan) AS query_plan_xml) AS qpx
JOIN sys.query_store_runtime_stats qrs on 
    qsp.plan_id = qrs.plan_id
JOIN sys.query_store_runtime_stats_interval qsrsi on 
    qrs.runtime_stats_interval_id=qsrsi.runtime_stats_interval_id
WHERE    
    qsp.query_plan like N'%<MissingIndexes>%'
    and qsrsi.start_time >= DATEADD(HH, -48, SYSDATETIME())
GROUP BY qsq.query_id, qsq.query_hash
ORDER BY est_logical_reads DESC;
GO

--Check the fragmentation and page density of a rowstore index
SELECT OBJECT_SCHEMA_NAME(ips.object_id) AS schema_name,
       OBJECT_NAME(ips.object_id) AS object_name,
       i.name AS index_name,
       i.type_desc AS index_type,
       ips.avg_fragmentation_in_percent,
       ips.avg_page_space_used_in_percent,
       ips.page_count,
       ips.alloc_unit_type_desc
FROM sys.dm_db_index_physical_stats(DB_ID(), default, default, default, 'SAMPLED') AS ips
INNER JOIN sys.indexes AS i 
ON ips.object_id = i.object_id
   AND
   ips.index_id = i.index_id
ORDER BY page_count DESC;

--if avg_fragmentation_in_percent >5 & <30 then reorganize
--if avg_fragmentation_in_percent >30 then rebuild

--Check the fragmentation of a columnstore index
SELECT OBJECT_SCHEMA_NAME(i.object_id) AS schema_name,
       OBJECT_NAME(i.object_id) AS object_name,
       i.name AS index_name,
       i.type_desc AS index_type,
       100.0 * (ISNULL(SUM(rgs.deleted_rows), 0)) / NULLIF(SUM(rgs.total_rows), 0) AS avg_fragmentation_in_percent
FROM sys.indexes AS i
INNER JOIN sys.dm_db_column_store_row_group_physical_stats AS rgs
ON i.object_id = rgs.object_id
   AND
   i.index_id = rgs.index_id
WHERE rgs.state_desc = 'COMPRESSED'
GROUP BY i.object_id, i.index_id, i.name, i.type_desc
ORDER BY schema_name, object_name, index_name, index_type;

--Reorganize an index
ALTER INDEX [index_name]
    ON [schema_name].[table_name]
    REORGANIZE;

--Reorganize all index
ALTER INDEX ALL [schema_name].[table_name]
   REORGANIZE;

--Rebuild an index
ALTER INDEX [index_name]
    ON [schema_name].[table_name]
    REBUILD;

---Rebuild all index
ALTER INDEX ALL ON [schema_name].[table_name]
REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = ON,
              STATISTICS_NORECOMPUTE = ON)
;

-- Find the average fragmentation percentage of all indexes
-- in the HumanResources.Employee table.
SELECT a.index_id, name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(N'AdventureWorks2012'),
OBJECT_ID(N'HumanResources.Employee'), NULL, NULL, NULL) AS a
JOIN sys.indexes AS b
ON a.object_id = b.object_id AND a.index_id = b.index_id;
GO

--Query for REBUILD/REORGANIZE Indexes
--30%> Rebuild
--5%=> Reorganize
--5%< do nothing

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent,
'ALTER INDEX ' + QUOTENAME(ind.name)  + ' ON ' +QUOTENAME(object_name(ind.object_id)) + 
CASE    WHEN indexstats.avg_fragmentation_in_percent>30 THEN ' REBUILD ' 
        WHEN indexstats.avg_fragmentation_in_percent>=5 THEN ' REORGANIZE '
        ELSE NULL END as [SQLQuery]  -- if <5 not required, so no query needed
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind ON ind.object_id = indexstats.object_id 
    AND ind.index_id = indexstats.index_id 
WHERE 
--indexstats.avg_fragmentation_in_percent , e.g. >10, you can specify any number in percent 
ind.Name is not null 
ORDER BY indexstats.avg_fragmentation_in_percent DESC

--or
--http://www.foliotek.com/devblog/sql-server-optimization-with-index-rebuilding 
IF OBJECT_ID('tempdb..#work_to_do') IS NOT NULL 
        DROP TABLE tempdb..#work_to_do

BEGIN TRY
--BEGIN TRAN

use yourdbname

-- Ensure a USE  statement has been executed first.

    SET NOCOUNT ON;

    DECLARE @objectid INT;
    DECLARE @indexid INT;
    DECLARE @partitioncount BIGINT;
    DECLARE @schemaname NVARCHAR(130);
    DECLARE @objectname NVARCHAR(130);
    DECLARE @indexname NVARCHAR(130);
    DECLARE @partitionnum BIGINT;
    DECLARE @partitions BIGINT;
    DECLARE @frag FLOAT;
    DECLARE @pagecount INT;
    DECLARE @command NVARCHAR(4000);

    DECLARE @page_count_minimum SMALLINT
    SET @page_count_minimum = 50

    DECLARE @fragmentation_minimum FLOAT
    SET @fragmentation_minimum = 30.0

-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function
-- and convert object and index IDs to names.

    SELECT  object_id AS objectid ,
            index_id AS indexid ,
            partition_number AS partitionnum ,
            avg_fragmentation_in_percent AS frag ,
            page_count AS page_count
    INTO    #work_to_do
    FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL,
                                           'LIMITED')
    WHERE   avg_fragmentation_in_percent > @fragmentation_minimum
            AND index_id > 0
            AND page_count > @page_count_minimum;

IF CURSOR_STATUS('global', 'partitions') >= -1
BEGIN
 PRINT 'partitions CURSOR DELETED' ;
    CLOSE partitions
    DEALLOCATE partitions
END
-- Declare the cursor for the list of partitions to be processed.
    DECLARE partitions CURSOR LOCAL
    FOR
        SELECT  *
        FROM    #work_to_do;

-- Open the cursor.
    OPEN partitions;

-- Loop through the partitions.
    WHILE ( 1 = 1 )
        BEGIN;
            FETCH NEXT
FROM partitions
INTO @objectid, @indexid, @partitionnum, @frag, @pagecount;

            IF @@FETCH_STATUS < 0
                BREAK;

            SELECT  @objectname = QUOTENAME(o.name) ,
                    @schemaname = QUOTENAME(s.name)
            FROM    sys.objects AS o
                    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
            WHERE   o.object_id = @objectid;

            SELECT  @indexname = QUOTENAME(name)
            FROM    sys.indexes
            WHERE   object_id = @objectid
                    AND index_id = @indexid;

            SELECT  @partitioncount = COUNT(*)
            FROM    sys.partitions
            WHERE   object_id = @objectid
                    AND index_id = @indexid;

            SET @command = N'ALTER INDEX ' + @indexname + N' ON '
                + @schemaname + N'.' + @objectname + N' REBUILD';

            IF @partitioncount > 1
                SET @command = @command + N' PARTITION='
                    + CAST(@partitionnum AS NVARCHAR(10));

            EXEC (@command);
            --print (@command); //uncomment for testing

            PRINT N'Rebuilding index ' + @indexname + ' on table '
                + @objectname;
            PRINT N'  Fragmentation: ' + CAST(@frag AS VARCHAR(15));
            PRINT N'  Page Count:    ' + CAST(@pagecount AS VARCHAR(15));
            PRINT N' ';
        END;

-- Close and deallocate the cursor.
    CLOSE partitions;
    DEALLOCATE partitions;

-- Drop the temporary table.
    DROP TABLE #work_to_do;
--COMMIT TRAN

END TRY
BEGIN CATCH
--ROLLBACK TRAN
    PRINT 'ERROR ENCOUNTERED:' + ERROR_MESSAGE()
END CATCH