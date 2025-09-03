-- =============================================
-- Index Fragmentation Report (Excluding Heaps)
-- With Recommended Action + Generated Script
-- =============================================

SELECT 
    s.name AS SchemaName,                -- Schema name (e.g., dbo)
    t.name AS TableName,                 -- Table name
    i.name AS IndexName,                 -- Index name
    ips.index_id,                        -- Index ID
    ips.avg_fragmentation_in_percent AS FragPercent,  -- Fragmentation percentage
    ips.page_count,                      -- Number of pages in the index
    CASE 
        WHEN ips.avg_fragmentation_in_percent >= 30 THEN 'REBUILD'
        WHEN ips.avg_fragmentation_in_percent BETWEEN 5 AND 30 THEN 'REORGANIZE'
        ELSE 'NONE'
    END AS RecommendedAction,             -- Suggested maintenance
    CASE 
        WHEN ips.avg_fragmentation_in_percent >= 30 
            THEN 'ALTER INDEX [' + i.name + '] ON [' + s.name + '].[' + t.name + '] REBUILD;'
        WHEN ips.avg_fragmentation_in_percent BETWEEN 5 AND 30
            THEN 'ALTER INDEX [' + i.name + '] ON [' + s.name + '].[' + t.name + '] REORGANIZE;'
        ELSE '-- No action required'
    END AS FixScript                      -- Auto-generated script
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i
    ON ips.object_id = i.object_id
    AND ips.index_id = i.index_id
JOIN sys.tables t
    ON ips.object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE ips.index_id > 0          -- Exclude heaps (index_id = 0 means a heap table)
  AND ips.page_count > 1000     -- Skip tiny indexes (best practice)
ORDER BY FragPercent DESC;      -- Show the most fragmented indexes first
