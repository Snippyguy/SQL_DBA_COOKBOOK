--Dynamic Data Masking check
--Excluding system Databases
EXEC sp_MSforeachdb '
IF ''?'' NOT IN (''master'', ''model'', ''msdb'', ''tempdb'') 
BEGIN
    USE [?];
    SELECT 
        DB_NAME() AS DatabaseName,
        t.name AS table_name,
        c.name AS column_name,
        c.is_masked,
        c.masking_function
    FROM sys.masked_columns c
    INNER JOIN sys.tables t
        ON c.object_id = t.object_id
    WHERE c.is_masked = 1;
END';

--Dynamic Data Masking check
--Including system Databases
EXEC sp_MSforeachdb N'

    USE [?];
    SELECT 
        DB_NAME() AS DatabaseName,
        t.name AS table_name,
        c.name AS column_name,
        c.is_masked,
        c.masking_function
    FROM sys.masked_columns c
    INNER JOIN sys.tables t
        ON c.object_id = t.object_id
    WHERE c.is_masked = 1;'
;

--Dynamic Data Masking check
--A safer alternative using official cursor (MS discourages sp_MSforeachdb)
DECLARE @sql NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb');

OPEN db_cursor;
DECLARE @dbname SYSNAME;

FETCH NEXT FROM db_cursor INTO @dbname;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
    USE [' + @dbname + '];

    SELECT 
        ''' + @dbname + ''' AS DatabaseName,
        t.name AS table_name,
        c.name AS column_name,
        c.is_masked,
        c.masking_function
    FROM sys.masked_columns c
    INNER JOIN sys.tables t
        ON c.object_id = t.object_id
    WHERE c.is_masked = 1;
    ';

    EXEC (@sql);

    FETCH NEXT FROM db_cursor INTO @dbname;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

