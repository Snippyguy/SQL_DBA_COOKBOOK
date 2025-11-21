--SQL User creation with SID

SELECT 
    sp.name AS LoginName,
    'IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = ''' + sp.name + ''')
    DROP LOGIN [' + sp.name + '];
    CREATE LOGIN [' + sp.name + '] ' +

    CASE 
        WHEN sp.type IN ('G','U') THEN 'FROM WINDOWS '
        WHEN sp.type = 'S' THEN 
            'WITH PASSWORD = ' + master.sys.fn_varbintohexstr(sl.password_hash) + ' HASHED, ' +
            'SID = ' + master.sys.fn_varbintohexstr(sp.sid) + ', ' +
            'CHECK_EXPIRATION = ' + 
                CASE WHEN sl.is_expiration_checked = 1 THEN 'ON' ELSE 'OFF' END + ', ' +
            'CHECK_POLICY = ' + 
                CASE WHEN sl.is_policy_checked = 1 THEN 'ON' ELSE 'OFF' END + ', '
        ELSE ''
    END +

    -- Credential
    CASE 
        WHEN c.credential_id IS NOT NULL 
            THEN 'CREDENTIAL = [' + c.name + '], '
        ELSE ''
    END +

    -- Default Database
    'DEFAULT_DATABASE = [' + sp.default_database_name + '], ' +

    -- Default Language
    'DEFAULT_LANGUAGE = [' + sp.default_language_name + '];'
    AS CreateLoginScript

FROM sys.server_principals sp
LEFT JOIN sys.sql_logins sl 
    ON sp.principal_id = sl.principal_id
LEFT JOIN sys.credentials c
    ON sp.credential_id = c.credential_id
WHERE sp.type IN ('S','U','G') -- SQL, Windows user, Windows group
  AND sp.name <> 'sa'
  AND sp.name NOT LIKE 'NT AUTHORITY\%'
  AND sp.name NOT LIKE 'NT SERVICE\%'
  --AND sp.name NOT LIKE 'SNIPPYGUY\%'
  AND sp.name NOT LIKE '##%'
  AND sp.is_disabled = 0;