
--How to Find Out When Your SQL Login Will Expire?
--work for SQL 2008 onwards.
SELECT  
		 LOGINPROPERTY(name, 'BadPasswordCount')		AS 'BadPasswordCount'
		,LOGINPROPERTY(name, 'BadPasswordTime')			AS 'BadPasswordTime'
		,LOGINPROPERTY(name, 'DaysUntilExpiration')		AS 'DaysUntilExpiration'
		,LOGINPROPERTY(name, 'DefaultDatabase')			AS 'DefaultDatabase'
		,LOGINPROPERTY(name, 'DefaultLanguage')			AS 'DefaultLanguage'
		,LOGINPROPERTY(name, 'HistoryLength')			AS 'HistoryLength'
		,LOGINPROPERTY(name, 'IsExpired')				AS 'IsExpired'
		,LOGINPROPERTY(name, 'IsLocked')				AS 'IsLocked'
		,LOGINPROPERTY(name, 'IsMustChange')			AS 'IsMustChange'
		,LOGINPROPERTY(name, 'LockoutTime')				AS 'LockoutTime'
		,LOGINPROPERTY(name, 'PasswordHash')			AS 'PasswordHash'
		,LOGINPROPERTY(name, 'PasswordLastSetTime')		AS 'PasswordLastSetTime'
		,LOGINPROPERTY(name, 'PasswordHashAlgorithm')	AS 'PasswordHashAlgorithm'
		,is_expiration_checked							As 'is_expiration_checked'
FROM    sys.sql_logins
WHERE   is_policy_checked = 1

--How to Find Out When Your SQL Login Will Expire?
SELECT
    sl.name AS LoginName,
    LOGINPROPERTY(sl.name, 'PasswordLastSetTime') AS PasswordLastSetTime,
    LOGINPROPERTY(sl.name, 'DaysUntilExpiration') AS DaysUntilExpiration,
    CASE
        WHEN LOGINPROPERTY(sl.name, 'DaysUntilExpiration') IS NULL THEN 'Never Expire'
        ELSE CONVERT(VARCHAR(10), DATEADD(dd, CONVERT(INT, LOGINPROPERTY(sl.name, 'DaysUntilExpiration')), CONVERT(DATETIME, LOGINPROPERTY(sl.name, 'PasswordLastSetTime'))), 101)
    END AS PasswordExpirationDate,
    CASE
        WHEN sl.is_expiration_checked = 1 THEN 'TRUE'
        ELSE 'FALSE'
    END AS PasswordPolicyEnabled,
    LOGINPROPERTY(sl.name, 'IsExpired') AS IsExpired,
    LOGINPROPERTY(sl.name, 'IsMustChange') AS IsMustChange,
    LOGINPROPERTY(sl.name, 'IsLocked') AS IsLocked
FROM
    sys.sql_logins AS sl
WHERE
    sl.type = 'S' -- Filter for SQL logins only
    AND sl.name NOT LIKE '##%' -- Exclude system-generated logins
    AND sl.name NOT LIKE 'endPointUser' -- Exclude specific system logins if desired
ORDER BY
    PasswordExpirationDate;

-- When will a SQL login password expire?
SELECT SL.name AS LoginName
      ,LOGINPROPERTY (SL.name, 'PasswordLastSetTime') AS PasswordLastSetTime
      ,LOGINPROPERTY (SL.name, 'DaysUntilExpiration') AS DaysUntilExpiration
        ,DATEADD(dd, CONVERT(int, LOGINPROPERTY (SL.name, 'DaysUntilExpiration'))
                   , CONVERT(datetime, LOGINPROPERTY (SL.name, 'PasswordLastSetTime'))) AS PasswordExpiration
      ,SL.is_policy_checked AS IsPolicyChecked
      ,LOGINPROPERTY (SL.name, 'IsExpired') AS IsExpired
      ,LOGINPROPERTY (SL.name, 'IsMustChange') AS IsMustChange
      ,LOGINPROPERTY (SL.name, 'IsLocked') AS IsLocked
      ,LOGINPROPERTY (SL.name, 'LockoutTime') AS LockoutTime
      ,LOGINPROPERTY (SL.name, 'BadPasswordCount') AS BadPasswordCount
      ,LOGINPROPERTY (SL.name, 'BadPasswordTime') AS BadPasswordTime
      ,LOGINPROPERTY (SL.name, 'HistoryLength') AS HistoryLength
FROM sys.sql_logins AS SL
WHERE is_expiration_checked = 1
ORDER BY LOGINPROPERTY (SL.name, 'PasswordLastSetTime') DESC

--How to Find Out When Your Windows Login Will Expire?
--we need to open a command prompt window and type the following command:
--  net user &lt;User Name&gt; /domain