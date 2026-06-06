USE [TESTDB_1]
GO

/****** Object:  StoredProcedure [dbo].[uSp_TableRenameActivity]    Script Date: 27-05-2026 11:05:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/***************************************************************************************************************************************
* Code Description	    : This stored procedure archives specified staging tables by renaming them with a date-stamped _BKP_yyyymmdd   *
*                         suffix, renames all their constraints and indexes accordingly, and then recreates fresh empty tables with the* 
*                         original names and original primary keys and indexes ready for new data.									   *										                               *
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
*                                                               Initial creation of stored procedure to archive staging tables by      *
*                                                               renaming existing tables with date-based backup suffix, renaming       *
*                                                               all associated constraints and indexes, and recreating fresh empty     *
*                                                               tables with the original structure and indexing for continued data     *
*                                                               ingestion.                                                             *
***************************************************************************************************************************************/

/*CREATE   PROCEDURE [dbo].[uSp_TableRenameActivity]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @dt CHAR(8) = CONVERT(CHAR(8), GETDATE(), 112);
    DECLARE @schema SYSNAME = 'dbo';

    DECLARE @tables TABLE (TName SYSNAME);
    INSERT INTO @tables VALUES
    ('Enter Your Table name Here'),
    ('Enter Your Table name Here''),
    ('Enter Your Table name Here'');

    DECLARE
        @tbl SYSNAME,
        @bkp SYSNAME,
        @sql NVARCHAR(MAX);

    DECLARE cur CURSOR LOCAL FAST_FORWARD
    FOR SELECT TName FROM @tables;

    OPEN cur;
    FETCH NEXT FROM cur INTO @tbl;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @bkp = @tbl + '_BKP_' + @dt;
        PRINT 'Processing: ' + @tbl;

        --------------------------------------------------
        -- 1. Rename original table → backup
        --------------------------------------------------
        SET @sql = N'EXEC sys.sp_rename N''' +
                   QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
                   ''', N''' + @bkp + ''';';
        EXEC (@sql);

        --------------------------------------------------
        -- 2. Rename constraints in BACKUP table
        --------------------------------------------------
        DECLARE con_cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT name COLLATE DATABASE_DEFAULT
        FROM sys.objects
        WHERE parent_object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND type IN ('PK','UQ','C','D');

        DECLARE @con SYSNAME;

        OPEN con_cur;
        FETCH NEXT FROM con_cur INTO @con;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @sql = N'EXEC sys.sp_rename N''' +
                       QUOTENAME(@schema) + '.' + QUOTENAME(@con) +
                       ''', N''' + @con + '_BKP_' + @dt + ''';';
            EXEC (@sql);

            FETCH NEXT FROM con_cur INTO @con;
        END

        CLOSE con_cur;
        DEALLOCATE con_cur;

        --------------------------------------------------
        -- 3. Rename indexes in BACKUP table
        --------------------------------------------------
        DECLARE ix_cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT name COLLATE DATABASE_DEFAULT
        FROM sys.indexes
        WHERE object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND name IS NOT NULL;

        DECLARE @ix SYSNAME;

        OPEN ix_cur;
        FETCH NEXT FROM ix_cur INTO @ix;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @sql = N'EXEC sys.sp_rename N''' +
                       QUOTENAME(@schema) + '.' + QUOTENAME(@bkp) + '.' + QUOTENAME(@ix) +
                       ''', N''' + @ix + '_BKP_' + @dt + ''', ''INDEX'';';
            EXEC (@sql);

            FETCH NEXT FROM ix_cur INTO @ix;
        END

        CLOSE ix_cur;
        DEALLOCATE ix_cur;

        --------------------------------------------------
        -- 4. Create NEW empty original table
        --------------------------------------------------
        SET @sql = N'SELECT TOP (0) * INTO ' +
                   QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
                   N' FROM ' +
                   QUOTENAME(@schema) + '.' + QUOTENAME(@bkp) + ';';
        EXEC (@sql);

        --------------------------------------------------
        -- 5. Recreate PRIMARY KEY (original name)
        --------------------------------------------------
        SELECT @sql =
        N'ALTER TABLE ' + QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
        N' ADD CONSTRAINT ' +
        QUOTENAME(REPLACE(kc.name COLLATE DATABASE_DEFAULT,
                 '_BKP_' + @dt, '')) +
        N' PRIMARY KEY (' +
        STRING_AGG(
            QUOTENAME(c.name COLLATE DATABASE_DEFAULT), ','
        ) WITHIN GROUP (ORDER BY ic.key_ordinal) +
        N');'
        FROM sys.key_constraints kc
        JOIN sys.index_columns ic
            ON kc.parent_object_id = ic.object_id
           AND kc.unique_index_id = ic.index_id
        JOIN sys.columns c
            ON ic.object_id = c.object_id
           AND ic.column_id = c.column_id
        WHERE kc.parent_object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND kc.type = 'PK'
        GROUP BY kc.name;

        EXEC (@sql);

        --------------------------------------------------
        -- 6. Recreate indexes (original names)
        --------------------------------------------------
        DECLARE ix2_cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT
        N'CREATE ' +
        CASE WHEN i.is_unique = 1 THEN N'UNIQUE ' ELSE N'' END +
        i.type_desc COLLATE DATABASE_DEFAULT +
        N' INDEX ' +
        QUOTENAME(REPLACE(i.name COLLATE DATABASE_DEFAULT,
                 '_BKP_' + @dt, '')) +
        N' ON ' + QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
        N' (' +
        STRING_AGG(
            QUOTENAME(c.name COLLATE DATABASE_DEFAULT), ','
        ) WITHIN GROUP (ORDER BY ic.key_ordinal) +
        N');'
        FROM sys.indexes i
        JOIN sys.index_columns ic
            ON i.object_id = ic.object_id
           AND i.index_id = ic.index_id
        JOIN sys.columns c
            ON ic.object_id = c.object_id
           AND ic.column_id = c.column_id
        WHERE i.object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND i.is_primary_key = 0
          AND i.is_unique_constraint = 0
        GROUP BY i.name, i.type_desc, i.is_unique;

        OPEN ix2_cur;
        DECLARE @ixdef NVARCHAR(MAX);

        FETCH NEXT FROM ix2_cur INTO @ixdef;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC (@ixdef);
            FETCH NEXT FROM ix2_cur INTO @ixdef;
        END

        CLOSE ix2_cur;
        DEALLOCATE ix2_cur;

        FETCH NEXT FROM cur INTO @tbl;
    END

    CLOSE cur;
    DEALLOCATE cur;
END
GO */

CREATE   PROCEDURE [dbo].[uSp_TableRenameActivity]
AS
BEGIN
    SET NOCOUNT ON;

    /********************************************************************
        DATE FORMAT USED FOR BACKUP TABLES
        CURRENT FORMAT : DDMMYYYY

        Example:
        13052026
    ********************************************************************/
    DECLARE @dt CHAR(8) =
           RIGHT('0' + CAST(DAY(GETDATE()) AS VARCHAR(2)),2) +
           RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) +
           CAST(YEAR(GETDATE()) AS VARCHAR(4));

    /********************************************************************
        ENTER YOUR SCHEMA NAME HERE
    ********************************************************************/
    DECLARE @schema SYSNAME = 'dbo';

    /********************************************************************
        ENTER YOUR TABLE NAMES HERE
    ********************************************************************/
    DECLARE @tables TABLE (TName SYSNAME);

    INSERT INTO @tables VALUES
    ('T_EXTERNAL_API_TRAIL_STAGING'),
    ('T_BONE_API_TRAIL_STAGING'),
    ('T_BONE_API_RESPONSE_STAGING');

    DECLARE
        @tbl SYSNAME,
        @bkp SYSNAME,
        @sql NVARCHAR(MAX);

    DECLARE cur CURSOR LOCAL FAST_FORWARD
    FOR
    SELECT TName
    FROM @tables;

    OPEN cur;

    FETCH NEXT FROM cur INTO @tbl;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        /****************************************************************
            BACKUP TABLE NAME FORMAT

            Example:
            T_BONE_API_RESPONSE_STAGING_BKP_13052026
        ****************************************************************/
        SET @bkp = @tbl + '_BKP_' + @dt;

        PRINT '=====================================================';
        PRINT 'Processing Table : ' + @tbl;
        PRINT 'Backup Table     : ' + @bkp;
        PRINT '=====================================================';

        /****************************************************************
            STEP 1 : RENAME ORIGINAL TABLE TO BACKUP TABLE
        ****************************************************************/
        SET @sql =
        N'EXEC sys.sp_rename N''' +
        QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
        ''', N''' + @bkp + ''';';

        PRINT @sql;
        EXEC (@sql);

        /****************************************************************
            STEP 2 : RENAME CONSTRAINTS
        ****************************************************************/
        DECLARE con_cur CURSOR LOCAL FAST_FORWARD
        FOR
        SELECT name COLLATE DATABASE_DEFAULT
        FROM sys.objects
        WHERE parent_object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND type IN ('PK','UQ','C','D');

        DECLARE
            @con SYSNAME,
            @newCon SYSNAME;

        OPEN con_cur;

        FETCH NEXT FROM con_cur INTO @con;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            /************************************************************
                REMOVE OLD _BKP_ IF EXISTS
                THEN APPEND NEW DATE
            ************************************************************/
            SET @newCon =
                CASE
                    WHEN @con LIKE '%[_]BKP[_]%'
                    THEN LEFT(@con, CHARINDEX('_BKP_', @con) - 1)
                    ELSE @con
                END + '_BKP_' + @dt;

            SET @sql =
            N'EXEC sys.sp_rename N''' +
            QUOTENAME(@schema) + '.' + QUOTENAME(@con) +
            ''', N''' + @newCon + ''';';

            PRINT @sql;
            EXEC (@sql);

            FETCH NEXT FROM con_cur INTO @con;
        END

        CLOSE con_cur;
        DEALLOCATE con_cur;

        /****************************************************************
            STEP 3 : RENAME INDEXES
        ****************************************************************/
        DECLARE ix_cur CURSOR LOCAL FAST_FORWARD
        FOR
        SELECT name COLLATE DATABASE_DEFAULT
        FROM sys.indexes
        WHERE object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND name IS NOT NULL;

        DECLARE
            @ix SYSNAME,
            @newIx SYSNAME;

        OPEN ix_cur;

        FETCH NEXT FROM ix_cur INTO @ix;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            /************************************************************
                REMOVE OLD _BKP_ IF EXISTS
                THEN APPEND NEW DATE
            ************************************************************/
            SET @newIx =
                CASE
                    WHEN @ix LIKE '%[_]BKP[_]%'
                    THEN LEFT(@ix, CHARINDEX('_BKP_', @ix) - 1)
                    ELSE @ix
                END + '_BKP_' + @dt;

            SET @sql =
            N'EXEC sys.sp_rename N''' +
            QUOTENAME(@schema) + '.' + QUOTENAME(@bkp) +
            '.' + QUOTENAME(@ix) +
            ''', N''' + @newIx + ''', ''INDEX'';';

            PRINT @sql;
            EXEC (@sql);

            FETCH NEXT FROM ix_cur INTO @ix;
        END

        CLOSE ix_cur;
        DEALLOCATE ix_cur;

        /****************************************************************
            STEP 4 : CREATE NEW EMPTY TABLE
        ****************************************************************/
        SET @sql =
        N'SELECT TOP (0) * INTO ' +
        QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
        N' FROM ' +
        QUOTENAME(@schema) + '.' + QUOTENAME(@bkp) + ';';

        PRINT @sql;
        EXEC (@sql);

        /****************************************************************
            STEP 5 : RECREATE PRIMARY KEY
        ****************************************************************/
        SELECT @sql =
        N'ALTER TABLE ' +
        QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
        N' ADD CONSTRAINT ' +
        QUOTENAME(
            REPLACE(
                kc.name COLLATE DATABASE_DEFAULT,
                '_BKP_' + @dt,
                ''
            )
        ) +
        N' PRIMARY KEY (' +
        STRING_AGG(
            QUOTENAME(c.name COLLATE DATABASE_DEFAULT),
            ','
        ) WITHIN GROUP (ORDER BY ic.key_ordinal) +
        N');'
        FROM sys.key_constraints kc
        JOIN sys.index_columns ic
            ON kc.parent_object_id = ic.object_id
           AND kc.unique_index_id = ic.index_id
        JOIN sys.columns c
            ON ic.object_id = c.object_id
           AND ic.column_id = c.column_id
        WHERE kc.parent_object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND kc.type = 'PK'
        GROUP BY kc.name;

        PRINT @sql;
        EXEC (@sql);

        /****************************************************************
            STEP 6 : RECREATE NON-CLUSTERED INDEXES
        ****************************************************************/
        DECLARE ix2_cur CURSOR LOCAL FAST_FORWARD
        FOR
        SELECT
            N'CREATE ' +
            CASE
                WHEN i.is_unique = 1
                THEN N'UNIQUE '
                ELSE N''
            END +
            i.type_desc COLLATE DATABASE_DEFAULT +
            N' INDEX ' +
            QUOTENAME(
                REPLACE(
                    i.name COLLATE DATABASE_DEFAULT,
                    '_BKP_' + @dt,
                    ''
                )
            ) +
            N' ON ' +
            QUOTENAME(@schema) + '.' + QUOTENAME(@tbl) +
            N' (' +
            STRING_AGG(
                QUOTENAME(c.name COLLATE DATABASE_DEFAULT),
                ','
            ) WITHIN GROUP (ORDER BY ic.key_ordinal) +
            N');'
        FROM sys.indexes i
        JOIN sys.index_columns ic
            ON i.object_id = ic.object_id
           AND i.index_id = ic.index_id
        JOIN sys.columns c
            ON ic.object_id = c.object_id
           AND ic.column_id = c.column_id
        WHERE i.object_id =
              OBJECT_ID(QUOTENAME(@schema) + '.' + QUOTENAME(@bkp))
          AND i.is_primary_key = 0
          AND i.is_unique_constraint = 0
          AND i.name IS NOT NULL
        GROUP BY
            i.name,
            i.type_desc,
            i.is_unique;

        DECLARE @ixdef NVARCHAR(MAX);

        OPEN ix2_cur;

        FETCH NEXT FROM ix2_cur INTO @ixdef;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT @ixdef;
            EXEC (@ixdef);

            FETCH NEXT FROM ix2_cur INTO @ixdef;
        END

        CLOSE ix2_cur;
        DEALLOCATE ix2_cur;

        /****************************************************************
            NEXT TABLE
        ****************************************************************/
        FETCH NEXT FROM cur INTO @tbl;
    END

    CLOSE cur;
    DEALLOCATE cur;

    PRINT '=====================================================';
    PRINT 'ALL TABLES PROCESSED SUCCESSFULLY';
    PRINT '=====================================================';
END
GO


