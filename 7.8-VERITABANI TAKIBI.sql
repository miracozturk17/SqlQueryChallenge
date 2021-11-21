
---BAGLANTI HAKKINDA BILGI EDINMEK---
SELECT 
    c.session_id AS SessionID,
	c.auth_scheme AS OturumSemasi,
	c.last_read AS SonOkuma,
	c.last_write AS SonYazma,
	c.client_net_address AS KullaniciAdres,
	c.local_tcp_port AS LocalPort,
	st.text AS SonSorgu
FROM sys.dm_exec_connections c
CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) st



---SESSION/OTURUM HAKKINDA BILGI EDINMEK---
SELECT 
	login_name AS OturumAdi, 
	COUNT(session_id) AS ToplamOturum, 
	login_time AS OturumZamani
FROM sys.dm_exec_sessions 
GROUP BY login_name, login_time;



---VERITABANI SUNUCUSU HAKKINDA BILGI EDINMEK---
SELECT * FROM sys.dm_os_sys_info;

SELECT 
	DATEDIFF(MINUTE, sqlserver_start_time, CURRENT_TIMESTAMP) AS SqlServerBaslangicZamani
FROM sys.dm_os_sys_info;

SELECT (ms_ticks-sqlserver_start_time_ms_ticks)/1000/60 AS BaslangicZamani
FROM sys.dm_os_sys_info;



---FIZIKSEL BELLEK HAKKINDA BILGI EDINMEK---
SELECT * FROM sys.dm_os_sys_memory;

SELECT 
	total_physical_memory_kb/1024 AS ToplamFizikselBellek,
	(total_physical_memory_kb-available_physical_memory_kb)/1024 AS KullanýlanFizikselBellek,
	available_physical_memory_kb/1024 AS KullanýlabilirFizikselBellek,
	total_page_file_kb/1024 AS ToplamSayfaMB,
	(total_page_file_kb - available_page_file_kb)/1024 AS KullanýlanSayfaMB,
	available_page_file_kb/1024 AS KullanýlabilirSayfaMB,
	system_memory_state_desc AS SistemHafizaDurumu
FROM sys.dm_os_sys_memory;



---AKTIF OLARAK CALISAN SORGULAR HAKKINDA BILGI EDINMEK---
DECLARE @test INT = 0;
WHILE 1 = 1
SET @test = 1;

SELECT DB_NAME(er.database_id) AS DBAdi,
	es.login_name OturumAdi,
	es.host_name HostAdi,
	st.text AS IfadeSorgu,
      SUBSTRING(st.text, (er.statement_start_offset/2) + 1, 
        ((CASE er.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         	ELSE er.statement_end_offset
          END - er.statement_start_offset)/2) + 1) AS IfadeSorguMetni,
   er.blocking_session_id AS BloklananOturumID,
   er.status AS Durum,
   er.wait_type AS BeklemeTipi,
   er.wait_time AS BeklemeZamani,
   er.percent_complete AS OrtalamaTamamlanma,
   er.estimated_completion_time AS TamamlanmaZamani
FROM sys.dm_exec_requests er
     LEFT JOIN sys.dm_exec_sessions es ON es.session_id = er.session_id
     CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
     CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp
WHERE er.session_id > 50 AND er.session_id != @@SPID;



--CACHE'LENEN SORGU PLANLARI HAKKINDA BILGI EDINMEK---
SELECT * FROM sys.dm_exec_cached_plans;

SELECT 
    cp.usecounts,
	st.text,
	qp.query_plan,	   
	cp.cacheobjtype,
	cp.objtype,
	cp.size_in_bytes
FROM sys.dm_exec_cached_plans cp
	CROSS APPLY sys.dm_exec_query_plan(CP.plan_handle) qp
	CROSS APPLY sys.dm_exec_sql_text(CP.plan_handle) st
WHERE cp.usecounts > 3
ORDER BY cp.usecounts DESC;

SELECT 
	DB_NAME(st.dbid) AS DBAdi,
	OBJECT_SCHEMA_NAME(ST.objectid, ST.dbid) AS SemaAdi,
	OBJECT_NAME(ST.objectid, ST.dbid) AS NesneAdi,
	st.text AS IfadeSorgu,
	qp.query_plan AS SorguPlani,
	cp.usecounts,
	cp.size_in_bytes
FROM sys.dm_exec_cached_plans cp
	CROSS APPLY sys.dm_exec_query_plan(CP.plan_handle) qp
	CROSS APPLY sys.dm_exec_sql_text(CP.plan_handle) st
WHERE ST.dbid <> 32767 
--AND CP.objtype = 'Proc';



---CACHE'LENEN SORGU PLANLARININ NESNE DAGILIMI---
SELECT 
	cp.objtype AS Nesne,
	COUNT(*) AS NesneToplami
FROM sys.dm_exec_cached_plans cp
GROUP BY cp.objtype
ORDER BY 2 DESC;



---PARAMETRE OLARAK VERILEN sql_handle'IN SQL SORGUSUNA ULASMAK---
SELECT 
	st.text AS IfadeSorgu
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(sql_handle) st
WHERE session_id = @@SPID;


SELECT 
	st.text AS IfadeSorgu 
FROM sys.dm_exec_connections c
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) st
WHERE session_id = @@SPID;

--sys.dm_exec_sql_text
--sys.dm_exec_cursors
--sys.dm_exec_xml_handles

SELECT * FROM sys.dm_exec_requests
SELECT * FROM sys.dm_exec_query_memory_grants
SELECT * FROM sys.dm_exec_connections



---PARAMETRE OLARAK VERILEN plan_handle'IN SORGU PLANINI ELDE ETMEK---
SELECT 
	qp.query_plan AS SorguPlani
FROM sys.dm_exec_requests c
CROSS APPLY sys.dm_exec_query_plan(plan_handle) qp
WHERE session_id = @@SPID;



---SORGU ISTATISTIKLERI---
SELECT * FROM sys.dm_exec_query_stats;

SELECT 
     q.[text] AS IfadeSorgu,
     SUBSTRING(q.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          	WHEN -1 THEN DATALENGTH(q.text)
          	ELSE qs.statement_end_offset
          END - qs.statement_start_offset)/2) + 1) AS IfadeSorguMetni,        
     qs.last_execution_time AS CalismaZamani,
     qs.execution_count AS CalismaSayisi,
     qs.total_worker_time / 1000000 AS ToplamCPUZamani,
     qs.total_worker_time / qs.execution_count / 1000 AS OrtalamaCPUZamani,
     qp.query_plan AS SorguPlani,
     DB_NAME(q.dbid) AS DBAdi,
     		q.objectid AS ObjeID,
     		q.number AS No,
     		q.encrypted AS SifrelemeDurum
FROM 
    (SELECT TOP 20 
          qs.last_execution_time,
          qs.execution_count,
	    qs.plan_handle, 
          qs.total_worker_time,
          qs.statement_start_offset,
          qs.statement_end_offset
    FROM sys.dm_exec_query_stats qs
    ORDER BY qs.total_worker_time desc) qs
CROSS APPLY sys.dm_exec_sql_text(plan_handle) q
CROSS APPLY sys.dm_exec_query_plan(plan_handle) qp
ORDER BY qs.total_worker_time DESC;

SELECT 
  q.[text] AS IfadeSorgu,
     SUBSTRING(q.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          	WHEN -1 THEN DATALENGTH(q.text)
          	ELSE qs.statement_end_offset
          END - qs.statement_start_offset)/2) + 1) AS IfadeSorguMetni,        
     qs.last_execution_time AS CalismaZamani,
     qs.execution_count AS CalismaSayisi,
     qs.total_worker_time / 1000000 AS ToplamCPUZamani,
     qs.total_worker_time / qs.execution_count / 1000 AS OrtalamaCPUZamani,
     qp.query_plan AS SorguPlani,
     DB_NAME(q.dbid) AS DBAdi,
     		q.objectid AS ObjeID,
     		q.number AS No,
     		q.encrypted AS SifrelemeDurum
FROM
    (SELECT TOP 20 
          qs.last_execution_time,
          qs.execution_count,
	    qs.plan_handle, 
          qs.total_worker_time,
          qs.total_logical_reads,
          qs.statement_start_offset,
          qs.statement_end_offset
    FROM sys.dm_exec_query_stats qs
    ORDER BY qs.total_worker_time desc) qs
CROSS APPLY sys.dm_exec_sql_text(plan_handle) q
CROSS APPLY sys.dm_exec_query_plan(plan_handle) qp
ORDER BY qs.total_logical_reads DESC;

SELECT TOP 10 
	SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
	((CASE qs.statement_end_offset
	WHEN -1 THEN DATALENGTH(qt.TEXT)
	ELSE qs.statement_end_offset
	END - qs.statement_start_offset)/2)+1) AS IfadeSorgu,
	qs.execution_count SorguSayisi,
	qs.total_logical_reads AS ToplamMantiksalOkuma,
	qs.last_logical_reads SonMantiksalOkuma,
	qs.total_logical_writes AS ToplamMantiksalYazma,
	qs.last_logical_writes SonMantiksalYazma,
	qs.total_worker_time AS ToplamCalismaZamani,
	qs.last_worker_time AS SonCalismaZamani,
	qs.total_elapsed_time/1000000 AS ToplamGecenZaman ,
	qs.last_elapsed_time/1000000 AS SonGecenZaman,
	qs.last_execution_time AS SonCalismaZamani,
	qp.query_plan AS SorguPlani
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time



---ISLEMLERDEKI BEKLEME SORUNU HAKKINDA BILGI ALMAK---
SELECT * FROM sys.dm_os_wait_stats;

DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);



---DISK CEVAP SURESI HAKKINDA BILGI ALMAK---
SELECT * FROM sys.dm_io_virtual_file_stats(null, null);


SELECT 
	 db_name(mf.database_id) AS DBAdi, 
	 mf.name AS DosyaAdi,
	 io_stall_read_ms/NULLIF(num_of_reads,0) AS CevapOkumaSuresi,
	 io_stall_write_ms/NULLIF(num_of_writes,0) AS CevapYazmaSuresi,
	 io_stall/NULLIF(num_of_reads+num_of_writes,0) AS CevapSuresi,
     num_of_reads OkumaSirasi,
	 num_of_bytes_read AS OkumaBYTE,
	 io_stall_read_ms IOOkumaMS,        
	 num_of_writes AS YazmaSayisi,
	 num_of_bytes_written AS YazmaBYTE,
	 io_stall_write_ms AS YazmaMS, 
	 io_stall IOAmbari,
	 size_on_disk_bytes AS DiskBYTEAlani
FROM 
	sys.dm_io_virtual_file_stats(DB_ID('AdventureWorks'), NULL) AS divFS
JOIN 
	sys.master_files AS MF
	ON MF.database_id = divFS.database_id 
	AND MF.file_id = divFS.file_id;



---BEKLEYEN I/O ISTEKLERI HAKKINDA BILGI EDINMEK---
SELECT * FROM sys.dm_io_pending_io_requests;

SELECT
   fs.database_id AS [DBID],
   db_name(FS.database_id) AS DBAdi,
   mf.name AS MantiksalDosyaAdi,
   ip.io_type,
   ip.io_pending_ms_ticks,
   ip.io_pending
FROM sys.dm_io_pending_io_requests ip
LEFT JOIN sys.dm_io_virtual_file_stats(null, null) fs 
     ON FS.file_handle = ip.io_handle
LEFT JOIN sys.master_files mf 
     ON mf.database_id = FS.database_id
     AND mf.file_id = fs.file_id



---DBCC SQLPERF ILE DMV ISTATISTIKLERINI TAKIP ETMEK---
SELECT * FROM sys.dm_os_wait_stats 
WHERE wait_time_ms > 0;

DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);



---STORED PROCEDURE ISTATISTIKLERI HAKKINDA BILGI ALMAK---
SELECT * FROM sys.dm_exec_procedure_stats;

SELECT TOP 20 
   DB_NAME(database_id) AS DBAdi,
   OBJECT_NAME(object_id) AS SPAdi,
   st.[text] AS SPKodu,
   qp.query_plan SorguPlani,
   cached_time AS IlkCalismaZamani,
   last_execution_time SonCalismaZamani,
   execution_count CalismaSayisi,
   ps.total_logical_reads AS ToplamMantiksalOkuma,
   ps.total_logical_reads / NULLIF(execution_count,0) AS OrtalamaMantiksalOkuma,
   ps.total_worker_time / 1000 AS ToplamCPUZamani,
   ps.total_worker_time / NULLIF(ps.execution_count,0)/1000 AS OrtalamaCPUZamani
FROM sys.dm_exec_procedure_stats ps
CROSS APPLY sys.dm_exec_sql_text(ps.plan_handle) st
CROSS APPLY sys.dm_exec_query_plan(ps.plan_handle) qp
WHERE DB_NAME(database_id)='AdventureWorks'
ORDER BY ps.total_worker_time DESC;


---KULLANILMAYAN STORED PROCEDURE'LERIN TESPIT EDILMESI---
SELECT 
	   SCHEMA_NAME(o.schema_id) AS SemaIsmi,
       p.name AS NesneIsmi, 
       p.create_date OlusturmaTarihi,
       p.modify_date AS DuzenlemeTarihi
FROM sys.procedures p
LEFT JOIN sys.objects o ON p.object_id = o.object_id
WHERE p.type = 'P'
AND NOT EXISTS(SELECT ps.object_id 
		FROM sys.dm_exec_procedure_stats ps 
		WHERE ps.object_id = p.object_id
		AND ps.database_id=DB_ID('AdventureWorks'))
ORDER BY SCHEMA_NAME(o.schema_id), p.name;


---TRIGGER ISTATISTIKLERI---
SELECT * FROM sys.dm_exec_trigger_stats;

SELECT TOP 10 
	   DB_NAME(database_id) AS DBAdi,
	   SCHEMA_NAME(o.schema_id) AS TabloSemaIsmi,
	   o.name AS TabloIsmi, 
	   t.name AS TriggerIsmi,
       st.[text] AS TriggerKodu,
	   qp.query_plan AS SorguPlani,
	   cached_time AS IlkCalismaZamani,
	   last_execution_time SonCalismaZamani,
	   execution_count CalismaSayisi,
       ps.total_logical_reads AS ToplamMantiksalOkuma,
       ps.total_logical_reads / NULLIF(execution_count,0) AS OrtalamaMantiksalOkuma,
       ps.total_worker_time / 1000 AS ToplamCPUZamani,
       ps.total_worker_time / NULLIF(ps.execution_count,0) / 1000 AS OrtalamaCPUZamani
FROM sys.dm_exec_trigger_stats ps
LEFT JOIN sys.triggers t ON t.object_id = ps.object_id
LEFT JOIN sys.objects O ON O.object_id = t.parent_id
CROSS APPLY sys.dm_exec_sql_text(ps.plan_handle) st
CROSS APPLY sys.dm_exec_query_plan(PS.plan_handle) qp
WHERE DB_NAME(database_id) = 'AdventureWorks'
ORDER BY ps.total_worker_time DESC;



---TABLO VERI GUNCELLEMELERI---
/*
UPDATE Production.WorkOrder 
SET StartDate = GETDATE(), EndDate = GETDATE(), DueDate = GETDATE()
WHERE WorkOrderID = 1


UPDATE Sales.SalesOrderHeader
SET OrderDate = GETDATE(), DueDate = GETDATE(), ShipDate = GETDATE()
WHERE SalesOrderID = 75123;
*/



---KULLANILMAYAN TRIGERLARI TESPIT ETMEK---
SELECT SCHEMA_NAME(o.schema_id) AS TabloSemaIsmi,
       o.name AS TabloNesneIsmi, 
       t.name AS TriggerNesneIsmi,
       t.create_date AS OlusturmaTarihi,
       t.modify_date AS DuzenlemeTarihi
FROM sys.triggers t
LEFT JOIN sys.objects o ON t.parent_id = o.object_id
WHERE t.is_disabled = 0 AND t.parent_id > 0
AND NOT EXISTS(SELECT ps.object_id 
		FROM sys.dm_exec_procedure_stats ps 
		WHERE ps.object_id = t.object_id
		AND ps.database_id = DB_ID('MBT'))
		ORDER BY SCHEMA_NAME(o.schema_id),o.name,t.name;



---ACIK OLAN CURSOR'LARI SORGULAMA---
SELECT * FROM sys.dm_exec_cursors(0);

/*
DECLARE @ProductID INT;
DECLARE @Name	 VARCHAR(255);
DECLARE ProductCursor CURSOR FOR
	  SELECT ProductID, Name FROM Production.Product WHERE ProductID < 5;
OPEN ProductCursor;
FETCH NEXT FROM ProductCursor INTO @ProductID, @Name;
WHILE @@FETCH_STATUS = 0
BEGIN
	WAITFOR DELAY '00:00:2';
	PRINT CAST(@ProductID AS VARCHAR) + '  -  ' + @Name;
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name;
END;
CLOSE ProductCursor;
DEALLOCATE ProductCursor;
*/


SELECT ec.cursor_id AS CursorID,
       ec.name AS CursorAdi,
       ec.creation_time AS OlusturmaTarihi,
       ec.dormant_duration/1000 AS BeklemeUykuSuresi,
       ec.fetch_status AS FetchDurumu,
       ec.properties AS Ozellikler,
       ec.session_id AS SessionOturumID,
       es.login_name AS OturumAdi,
       es.host_name AS HostAdi,
       st.text AS IfadeSorgu,
       SUBSTRING(st.text, (ec.statement_start_offset/2)+1, 
        ((CASE ec.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         	ELSE ec.statement_end_offset
          END - ec.statement_start_offset)/2) + 1) AS IfadeMetni
FROM sys.dm_exec_cursors(0) ec
CROSS APPLY sys.dm_exec_sql_text(ec.sql_handle) st
JOIN sys.dm_exec_sessions es ON es.session_id = ec.session_id