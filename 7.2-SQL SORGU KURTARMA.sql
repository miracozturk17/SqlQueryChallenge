/*

1- SSMS; Tools -> Options -> Eviroment AutoRecover: Save Auto Recover (+)

*/


SELECT 
	eqs.creation_time,
	eqs.last_execution_time,
	eqs.total_rows,
	es.text
FROM sys.dm_exec_query_stats eqs
CROSS APPLY 
	sys.dm_exec_sql_text(eqs.sql_handle) AS es
ORDER BY eqs.last_execution_time DESC