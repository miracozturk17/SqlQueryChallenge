/*
KIMI ZAMAN DILIMLERINDE GERCEKLESTIRILEN YEDEKLEME VE YEDEKTEN DONME ZAMAN DILIMI VE YUZDE BILGILERI SUREC ADINA GEREKEBILIR.

BUNUN ICIN ASAGIDAKI KOD KULLANILABILIR;
*/

SELECT
	   session_id AS OturumKimligi,
	   command AS Komut,
	   St.text AS Sorgu,
	   start_time AS BaslangicZamani,
	   percent_complete AS TamamlanmaYuzdesi,
	   DATEADD(SECOND,estimated_completion_time/1000,GETDATE()) AS TahminiTamamlanmaZamani
FROM sys.dm_exec_requests Req
CROSS APPLY sys.dm_exec_sql_text (Req.sql_handle) St 
WHERE Req.command in ('BACKUP DATABASE','RESTORE DATABASE')