/*
MALIYET ANAZLIZI VE PERFORMANS TAKIBI ADINA KIMI DURUMLARDA VERITABANI BUYUMELERINI TAKIP ETMEK ZORUNDA KALABILIRIZ.
BUNUN ICIN MSSQLTIPS EKIBININ HAZIRLAMIS OLDUGU ALT KISIMDA YER ALAN SORGUYU KULLANARAK SURECI COZUME ULASTIRABILIRIZ.

https://www.mssqltips.com/
*/

SELECT 
      DATABASE_NAME,
	  YEAR(backup_start_date) YEAR_ ,
	  MONTH(backup_start_date) MONTH_ ,
	  MIN(BackupSize) FIRSTSIZE_MB,
	  MAX(BackupSize) LASTSIZE_MB,
	  MAX(BackupSize)-MIN(BackupSize) AS GROW_MB,
	  ROUND((MAX(BackupSize)-MIN(BackupSize))/CONVERT(FLOAT,MIN(BackupSize))*100,2) AS PERCENT_
 FROM
(
	SELECT
		s.database_name,
		s.backup_start_date,
		COUNT(*) OVER (PARTITION BY s.database_name) AS SampleSize,
		CAST((s.backup_size / 1024 / 1024 ) AS INT) AS BackupSize,
		CAST((LAG(s.backup_size) OVER (PARTITION BY s.database_name ORDER BY s.backup_start_date) / 1024 / 1024 ) AS INT) AS Previous_Backup_Size
FROM
	msdb..backupset s
WHERE
	s.type = 'D'
	and s.database_name='<dbname>'
)T GROUP BY DATABASE_NAME,MONTH(backup_start_date),YEAR(backup_start_date) 