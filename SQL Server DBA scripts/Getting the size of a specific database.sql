
--Getting the size of a specific database
--Run this script in the context of a specific database to get the files and size info for that database alone.

SELECT DB_NAME()                                                   AS [Database],
       SUM(CASE
             WHEN [type] = 0 THEN 1
             ELSE 0
           END)                                                    AS [DataFiles],
       CAST(SUM(CASE
                  WHEN [type] = 0 THEN (CAST([size] AS BIGINT) * 8 / 1024.00 / 1024.00 )
                  ELSE 0.00
                END) AS NUMERIC(15, 3))                            AS [DataFilesSizeGB],
       SUM(CASE
             WHEN [type] = 1 THEN 1
             ELSE 0
           END)                                                    AS [LogFiles],
       CAST(SUM(CASE
                  WHEN [type] = 1 THEN (CAST([size] AS BIGINT) * 8 / 1024.00 / 1024.00 )
                  ELSE 0.00
                END) AS NUMERIC(15, 3))                            AS [LogFilesSizeGB],
       SUM(CASE
             WHEN [type] = 2 THEN 1
             ELSE 0
           END)                                                    AS [FILESTREAMContainers],
       CAST(SUM(CASE
                  WHEN [type] = 2 THEN (CAST([size] AS BIGINT) * 8 / 1024.00 / 1024.00 )
                  ELSE 0.00
                END) AS NUMERIC(15, 3))                            AS [FSContainersSizeGB],
       CAST(SUM(CAST([size] AS BIGINT) * 8 / 1024.00 / 1024.00) AS NUMERIC(15, 3)) AS [DatabaseSizeGB]
FROM sys.database_files; 