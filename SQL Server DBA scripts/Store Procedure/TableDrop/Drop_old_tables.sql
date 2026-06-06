USE [TESTDB_1];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/***************************************************************************************************************************************
* Code Description	    : This stored procedure identifies and drops old backup/staging tables created on or before the configured     *
*                         cutoff date (last day of the previous month minus one day).  The procedure dynamically fetches tables based  * 
*                         on predefined naming patterns from system catalog views, logs the identified tables for verification,        *
*                         database using dynamic DROP TABLE statements. and permanently removes them from the Database.                *
*                         This cleanup activity helps in maintaining database storage, reducing unnecessary object accumulation, and   *
*                         improving operational manageability.                                                                         *
* Author Name		    : Sayan Dey					  																				   *
* Company Name		    :               																							   *
* Website		        : 						                        															   *																						
* Creation Date		    : 13/12/2025																								   *
* Reviewer Name         :                                                                                                              *
* Review Date           :                                                                                                              *
* Last Modified By 	    : 13/12/2025																								   *
* Last Modification	    : Initial Creation  																						   *
* Implementation CR     :                                                                                                              *
*                                                   Modification History	 														   *
*                                           --------------------------------------                                                     *
*    CR NUMBER               IMPLEMENTATION DATE                                            DESCRIPTION                                *
*-----------------      ---------------------------             ------------------------------------------------------------------     *
*                                                               Initial creation of stored procedure to identify and drop obsolete     *
*                                                               backup and staging tables based on configured retention criteria. The  *
*                                                               procedure dynamically fetches eligible tables using predefined naming  *
*                                                               conventions and creation date filters, logs the identified objects for * 
*                                                               verification,and permanently removes them from the database to optimize*  
*                                                               storage utilization and maintain database housekeeping standards.      *                                                                                                                  *
***************************************************************************************************************************************/

CREATE OR ALTER PROCEDURE dbo.Drop_Old_BackupTables
AS
BEGIN
    SET NOCOUNT ON;

    -- Last day of previous month - 1 day
    DECLARE @CutoffDate DATE = DATEADD(DAY, -1, EOMONTH(GETDATE(), -1));

    DECLARE @SQL NVARCHAR(MAX) = N'';

    PRINT 'Cutoff Date : ' + CONVERT(VARCHAR(10), @CutoffDate, 120);

    -- Store matching tables in temp table
    IF OBJECT_ID('tempdb..#BackupTables') IS NOT NULL
        DROP TABLE #BackupTables;

    SELECT
        t.name AS TableName,
        s.name AS SchemaName,
        t.create_date
    INTO #BackupTables
    FROM sys.tables t
    INNER JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    WHERE
    (
           t.name LIKE 'Enter Your Table name Here'
        OR t.name LIKE 'Enter Your Table name Here'
        OR t.name LIKE 'Enter Your Table name Here'
        OR t.name LIKE 'Enter Your Table name Here'
    )
    AND CAST(t.create_date AS DATE) <= @CutoffDate;

    -- Generate DROP statements
    SELECT @SQL =
        STRING_AGG(
            'DROP TABLE '
            + QUOTENAME(SchemaName)
            + '.'
            + QUOTENAME(TableName),
            ';' + CHAR(13)
        )
    FROM #BackupTables;

    -- Preview tables
    PRINT 'Tables identified for deletion :';

    SELECT
        SchemaName,
        TableName,
        create_date
    FROM #BackupTables
    ORDER BY create_date;

    -- Execute DROP
    IF @SQL IS NOT NULL AND LEN(@SQL) > 0
    BEGIN
        PRINT 'Executing DROP statements...';

        PRINT @SQL;

        EXEC sp_executesql @SQL;

        PRINT 'Old tables dropped successfully.';
    END
    ELSE
    BEGIN
        PRINT 'No tables found older than cutoff date.';
    END

END;
GO