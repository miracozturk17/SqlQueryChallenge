/*
KIMI ZAMAN DILIMLERINDE XML UZERINDEKI BIR ALANDA BIRDEN COK BILGI IC-ICE YAZILABILIR.

BU BILGILERI AYIRMAK ICIN ISE ASAGIDAKI KOD KULLANILABILIR;
*/

SELECT 
  REPLACE(value, '</br>', CHAR(10)) AS evrak_no
FROM 
  (
    SELECT 
      CAST('<root><s>' + REPLACE(evrak_no, '</br>', '</s><s>') + '</s></root>' AS XML) AS xmlData
    FROM 
      [PowerBI].[dbo].[Faturalar]
  ) t
CROSS APPLY 
  xmlData.nodes('/root/s') AS x(value)