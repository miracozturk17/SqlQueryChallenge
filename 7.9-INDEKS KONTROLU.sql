SELECT 
       indexs.object_id, 
	   systemobject.name AS index_table,
	   indexs.name       AS index_name,
	   indexs.type_desc  AS index_type, 
	   systemobject.is_ms_shipped,
	   basecolumn.name   AS index_column
FROM       sys.indexes       indexs
INNER JOIN sys.index_columns indexcolumn  ON indexcolumn.object_id  = indexs.object_id      AND indexcolumn.index_id  = indexs.index_id
INNER JOIN sys.columns       basecolumn   ON basecolumn.object_id   = indexcolumn.object_id AND indexcolumn.column_id = basecolumn.column_id
INNER JOIN sys.objects       systemobject ON systemobject.object_id = indexs.object_id
WHERE 
      indexs.object_id > 100 AND 
	  systemobject.is_ms_shipped <> 1 AND --SQLAgent, Queue Secondary, File Table Update
	  systemobject.name<>'sysdiagrams'
GROUP BY 
      indexs.object_id,
	  indexs.name,
	  systemobject.name,
	  systemobject.is_ms_shipped,
	  basecolumn.name,
	  indexs.type_desc
ORDER BY indexs.name