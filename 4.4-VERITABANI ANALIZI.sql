/*
MEVCUT OLARAK SISTEMIMIZIN ANA OBEGI OLAN VERITABANIMIZA AIT BILGILERE ERISIP SISTEMIMIZIN PERFORMANSINI KONTROL ETMEMIZ GEREKEBILIR.
*/
--BELIRLEDIGIMIZ BIR VERI TABANININ DURUM BILGILERINI ANLIK OLARAK ELDE EDEBILIRIZ.
--MEVCUT SQL SORGUSU;
SELECT TOP 3 
		DB_NAME(ST.dbid) AS [DATABASE],
		execution_count AS [EXECUTE_SAYISI],
		total_worker_time / execution_count AS [ORT.CPU],
		total_elapsed_time / execution_count AS [ORT.ZAMAN],
		total_logical_reads / execution_count AS [ORT.OKUMA],
		total_logical_writes / execution_count AS [ORT.YAZMA],
		SUBSTRING(ST.text,(QS.statement_start_offset /2)+1,
		CASE QS.statement_end_offset
			WHEN -1 THEN DATALENGTH(ST.text)
				ELSE QS.statement_end_offset
			END - QS.statement_start_offset ) /2 + 1 AS [ISTEK],
	    query_plan AS [SORGU_PLANI]
		FROM sys.dm_exec_query_stats QS
	CROSS APPLY sys.dm_exec_query_plan(QS.plan_handle) AS QP
	CROSS APPLY sys.dm_exec_sql_text (QS.sql_handle) AS ST
WHERE DB_NAME(ST.dbid) ='SiparisTakipSistemi'
ORDER BY total_elapsed_time DESC

--BELIRLEDIGIMIZ BIR VERI TABANININ ISLEM DURUMU BILGILERINI ANLIK OLARAK ELDE EDEBILIRIZ.
--MEVCUT SQL SORGUSU;
SELECT 
		eR.session_id AS [SESSION_ID],
		eR.percent_complete AS [TAMAMLANMA_YUZDESI],
		eR.total_elapsed_time/100 AS [GECEN_SURE],
		CASE WHEN 
		(eR.percent_complete/eR.total_elapsed_time/1000)=0 THEN DATEADD(SECOND,100/1/1000,eR.start_time) 
		ELSE 
		DATEADD(SECOND,100/eR.percent_complete/eR.total_elapsed_time/1000/1000,eR.start_time) 
		END	AS [TAMAMLANMA_SURESI],
		esT.text AS [ACIKLAMA]
	FROM sys.dm_exec_requests eR
	CROSS APPLY sys.dm_exec_sql_text (eR.sql_handle) esT 

--HERHANGI BIR VERITABANINA ANLIK OLARAK ATILAN KULLANICI SORGU DURUM BILGILERINI ELDE EDEBILIRIZ.
--MEVCUT SQL SORGUSU;
SELECT  
		object_name(object_id) AS [TABLO_ID],
		(user_seeks+' '+user_scans+' '+user_lookups) AS [KULLANICI_OKUMA],
		user_updates AS [KULLANICI_YAZMA]
	FROM sys.dm_db_index_usage_stats	
WHERE DB_NAME(database_id)='Equinox' AND index_id = 0
ORDER BY 1 DESC
	 
--HERHANGI BIR VERITABANININ ISLEM BILGILERINI ANLIK OLARAK ELDE EDEBILIRIZ.
--MEVCUT SQL SORGUSU;
SELECT 
	DB_NAME(ioFS.database_id) AS [DATABASE],
	MF.name AS [LOGIC_DOSYA],
	MF.physical_name AS [FIZIKSEL_DOSYA_ADI],
	ioFS.io_stall_read_ms/ioFS.num_of_reads AS [ORT.OKUMA],
	ioFS.num_of_reads AS [OKUMA_NO],
	ioFS.num_of_bytes_read AS [OKUMA_BYTE],
	ioFS.size_on_disk_bytes AS [DISK_KAPASITE]
	FROM sys.dm_io_virtual_file_stats(NULL,NULL) ioFS
	INNER JOIN master.sys.master_files MF ON ioFS.database_id = MF.database_id
				AND ioFS.file_id = MF.file_id
	ORDER BY 4 DESC

--HERHANGI BIR VERITABANININ CALISMA SURESI ILE ILGILI DURUM BILGILERINI ANLIK OLARAK ELDE EDEBILRIZ.
--MEVCUT SQL SORGUSU;
WITH WAITS AS (
			SELECT 
				wait_type AS [BEKLEME_TIPI],
				wait_time_ms / 1000. AS [SN_CINSI_BEKLEME_SURESI],
				100.*wait_time_ms/SUM(wait_time_ms) OVER () AS [ORT_],
				ROW_NUMBER() OVER (ORDER BY wait_time_ms DESC) AS [RN] 
				FROM sys.dm_os_wait_stats
				WHERE wait_type IN('DIRTY_PAGE_POOL',
				'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
				'TRACEWRITE',
				'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
				'WRITELOG',
				'BROKER_EVENTHANDLER')
)
	SELECT 
		W1.BEKLEME_TIPI,
		CAST(W1.SN_CINSI_BEKLEME_SURESI AS DECIMAL(16,4)) AS [BEKLEME_SURESI],
		CAST(W1.ORT_ AS DECIMAL(16,4)) AS [ORT_],
		CAST(SUM(W2.ORT_) AS DECIMAL (16,4)) AS [DEVAM_EDEN_ORT]
		FROM WAITS AS W1
		INNER JOIN WAITS AS W2 ON W2.RN=W1.RN
		GROUP BY 
			W1.RN,W1.BEKLEME_TIPI,W1.SN_CINSI_BEKLEME_SURESI,W1.ORT_
		HAVING SUM(W2.ORT_)-W1.ORT_<95

--VERITABANI NESNE ICERIKLERINI INCELEMEMIZ GEREKEBILIR.
--MEVCUT SQL SORGUSU;

--SISTEM YORUMLARI;
SELECT * FROM sys.syscomments(NOLOCK)

--SISTEM SCHEMALARI
SELECT * FROM sys.schemas(NOLOCK)
 
--SISTEMDE BULUNAN TUM NESNELER
SELECT * FROM sys.all_objects(NOLOCK)
 
--ANA SQL OBJE SORGUSU;
SELECT  S.name AS SP_SCHEMA,
        O.name AS SP_NAME,
        C.text AS SP_TEXT
FROM sys.syscomments(NOLOCK) AS C
    JOIN sys.all_objects(NOLOCK) AS O
        ON C.id = O.object_id
    JOIN sys.schemas AS S
        ON S.schema_id = O.schema_id
WHERE O.type in ('P','FN','IF','FS','AF','X','TF','TR','PC') AND
      C.text like '%' + 'ARANACAK KELIME' + '%'