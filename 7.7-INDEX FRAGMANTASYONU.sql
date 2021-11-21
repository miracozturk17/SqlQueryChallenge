SELECT 
*
FROM sys.dm_db_index_physical_stats (DB_ID(),NULL,NULL,NULL,NULL) AS indexstatistic
INNER JOIN sys.tables  dbtables  ON dbtables.[object_id]      = indexstatistic.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id]      = dbschemas.[schema_id]
INNER JOIN sys.indexes dbindexes ON indexstatistic.[index_id] = dbindexes.[index_id]
WHERE indexstatistic.[database_id]= DB_ID() AND indexstatistic.avg_fragmentation_in_percent>0
ORDER BY indexstatistic.avg_fragmentation_in_percent DESC