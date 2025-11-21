
--Delete Orphaned users

/*===============================================================
  SCRIPT 1: GET ORPHANED USERS IN ALL DATABASES
===============================================================*/
DECLARE @DBName sysname,
        @SQL    NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4                -- Exclude system DBs
  AND state_desc = 'ONLINE';         -- Only online DBs

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DBName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    USE [' + @DBName + '];

    SELECT 
        ''' + @DBName + ''' AS DatabaseName,
        dp.name AS OrphanedUser
    FROM sys.database_principals dp
    LEFT JOIN sys.server_principals sp
        ON dp.sid = sp.sid
    WHERE sp.sid IS NULL
      AND dp.type IN (''S'', ''U'')     -- SQL + Windows users
      AND dp.authentication_type <> 2   -- Exclude Contained DB users
      AND dp.name NOT IN 
        (''dbo'', ''guest'', ''sys'', ''INFORMATION_SCHEMA'', 
         ''MS_DataCollectorInternalUser'', ''public'');
    ';

    EXEC (@SQL);

    FETCH NEXT FROM db_cursor INTO @DBName;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;

--To get orphaned user for single DB
--EXEC sp_change_users_login @action = 'Report'
--EXEC sp_change_users_login 'Auto_Fix', 'UAT_orphn'

/*===============================================================
  SCRIPT 2: AUTO-FIX SQL ORPHANED USERS (SID MISMATCH ONLY)
===============================================================*/
DECLARE @DB sysname,
        @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4
  AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DB;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    USE [' + @DB + '];

    DECLARE @User sysname;

    DECLARE orphan_fix_cursor CURSOR FOR
    SELECT dp.name
    FROM sys.database_principals dp
    LEFT JOIN sys.server_principals sp
        ON dp.sid = sp.sid
    WHERE dp.type = ''S''        -- SQL Users only
      AND sp.sid IS NULL;

    OPEN orphan_fix_cursor;
    FETCH NEXT FROM orphan_fix_cursor INTO @User;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC sp_change_users_login ''Auto_Fix'', @User;
        FETCH NEXT FROM orphan_fix_cursor INTO @User;
    END;

    CLOSE orphan_fix_cursor;
    DEALLOCATE orphan_fix_cursor;
    ';

    EXEC (@SQL);

    FETCH NEXT FROM db_cursor INTO @DB;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;

/*===============================================================
  SCRIPT 3: DROP ORPHANED USERS (AFTER SCHEMA REASSIGNMENT)
===============================================================*/
DECLARE @DB sysname,
        @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4
  AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DB;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    USE [' + @DB + '];

    DECLARE @User sysname,
            @DropSQL NVARCHAR(MAX);

    DECLARE orphan_drop_cursor CURSOR FOR
    SELECT dp.name
    FROM sys.database_principals dp
    LEFT JOIN sys.server_principals sp
        ON dp.sid = sp.sid
    WHERE sp.sid IS NULL
      AND dp.type IN (''S'', ''U'', ''G'')            -- SQL, Windows, AD Groups
      AND dp.authentication_type <> 2                 -- Exclude Contained DB users
      AND dp.name NOT IN (''dbo'', ''guest'', ''INFORMATION_SCHEMA'', 
                          ''sys'', ''MS_DataCollectorInternalUser'');

    OPEN orphan_drop_cursor;
    FETCH NEXT FROM orphan_drop_cursor INTO @User;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Transfer schemas owned by the user to dbo
        SET @DropSQL = N'''';

        SELECT @DropSQL = @DropSQL +
                ''ALTER AUTHORIZATION ON SCHEMA::['' + s.name + ''] TO dbo;''
        FROM sys.schemas s
        WHERE s.principal_id = USER_ID(@User);

        IF (@DropSQL <> N'''')
            EXEC (@DropSQL);

        -- Now drop the orphaned user
        EXEC (''DROP USER ['' + @User + ''];'');

        FETCH NEXT FROM orphan_drop_cursor INTO @User;
    END;

    CLOSE orphan_drop_cursor;
    DEALLOCATE orphan_drop_cursor;
    ';

    EXEC (@SQL);

    FETCH NEXT FROM db_cursor INTO @DB;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;
