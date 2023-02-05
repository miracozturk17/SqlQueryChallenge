/*
KIMI ZAMAN DILIMLERINDE URUN SATAN FIRMALARDA FIYAT DEGISIMLERININ TAKIP EDILMESI GEREKEBILIR.

BU NOKTADA DEGISIMLERE YONELIK ALT KISIMDAKI KODU KULLANABILIRSINIZ;
*/


SELECT
ttMain.Urun AS MUrun,
ttMain.V    AS MLogId,
prev.Fiyat  AS PFiyat,
nexv.Fiyat  AS NFiyat,
CASE WHEN   ABS(nexv.Fiyat-prev.Fiyat)/(NULLIF(prev.Fiyat,0))>=0.00  AND ABS((nexv.Fiyat-prev.Fiyat)/NULLIF(prev.Fiyat,0))<=0.0099 THEN '%0-%1'
 WHEN       ABS(nexv.Fiyat-prev.Fiyat)/(NULLIF(prev.Fiyat,0))>0.0099 AND ABS((nexv.Fiyat-prev.Fiyat)/NULLIF(prev.Fiyat,0))<=0.0499 THEN '%1-%5'
 WHEN       ABS(nexv.Fiyat-prev.Fiyat)/(NULLIF(prev.Fiyat,0))>0.0499 AND ABS((nexv.Fiyat-prev.Fiyat)/NULLIF(prev.Fiyat,0))<=0.099  THEN '%5-%10'
 WHEN       ABS(nexv.Fiyat-prev.Fiyat)/(NULLIF(prev.Fiyat,0))>0.099  AND ABS((nexv.Fiyat-prev.Fiyat)/NULLIF(prev.Fiyat,0))<=0.299  THEN '%10-%30'  
 WHEN       ABS(nexv.Fiyat-prev.Fiyat)/(NULLIF(prev.Fiyat,0))>0.299  AND ABS((nexv.Fiyat-prev.Fiyat)/NULLIF(prev.Fiyat,0))<=0.499  THEN '%30-%50' 
 WHEN       ABS(nexv.Fiyat-prev.Fiyat)/(NULLIF(prev.Fiyat,0))>0.499  THEN '+%50'	
 END  AS OranAraligi
FROM
(
	SELECT 
	   t.Urun,
	   LAG(t.UrunMaliyetLogID)  OVER (ORDER BY t.Urun) AS PV,
	   t.UrunMaliyetLogID AS V,
	   LEAD(t.UrunMaliyetLogID) OVER (ORDER BY t.Urun) AS NV
	FROM UrunMaliyetLog t
)ttMain
LEFT OUTER JOIN UrunMaliyetLog prev ON prev.UrunMaliyetLogID=ttMain.PV AND prev.Urun=ttMain.Urun
LEFT OUTER JOIN UrunMaliyetLog nexv ON nexv.UrunMaliyetLogID=ttMain.NV AND nexv.Urun=ttMain.Urun
WHERE ttMain.Urun='X'