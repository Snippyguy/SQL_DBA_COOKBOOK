
--SQL Login Password Expiry
-- Declare a temporary table to store login information
DECLARE @temp TABLE 
                (
                    Server_IP               VARCHAR(50),
                    LoginName               VARCHAR(MAX),
                    DaysUntilExpiration     INT,
                    IsExpired               INT,
                    Is_policy_checked       INT,
                    Is_expiration_checked   INT,
                    Expiry_date             DATETIME,
                    Is_disabled             INT
                 );

-- Get the local server IP address
DECLARE @Server_IP VARCHAR(50);

SELECT @Server_IP = c.local_net_address
FROM sys.dm_exec_connections AS c
WHERE c.local_net_address IS NOT NULL
  AND c.local_net_address <> '127.0.0.1';

-- Insert login data into @temp table
INSERT INTO @temp 
                (
                 Server_IP,
                 LoginName,
                 DaysUntilExpiration,
                 IsExpired,
                 Is_policy_checked,
                 Is_expiration_checked,
                 Expiry_date,
                 Is_disabled
                )
SELECT
        @Server_IP,
        name,
        CONVERT(INT, LOGINPROPERTY(name, 'DaysUntilExpiration')),
        CONVERT(INT, LOGINPROPERTY(name, 'IsExpired')),
        Is_policy_checked,
        Is_expiration_checked,
        DATEADD(DAY, CONVERT(INT, LOGINPROPERTY(name, 'DaysUntilExpiration')), GETDATE()) AS Expiry_date,
        Is_disabled
FROM sys.sql_logins
WHERE name NOT IN (
                    '##MS_PolicyTsqlExecutionLogin##',
                    '##MS_PolicyEventProcessingLogin##',
                    '##MS_SQLServerCleanupJobLogin##',
                    'sa',
                    'login',
                    'isuser',
                    'is'
                  )
AND is_expiration_checked = 1;

-- Final result
SELECT
    Server_IP,
    LoginName,
    DaysUntilExpiration,
    IsExpired,
    Is_policy_checked,
    Is_expiration_checked,
    Expiry_date,
    Is_disabled
FROM @temp
WHERE expiry_date IS NOT NULL;
