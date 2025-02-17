/*
BAZEN BELIRLI AYIRACLARLA OLUSTURULAN METIN DIZELERINI AYIRIP ICINDEKI KELIMELERI KULLANMAMIZ GEREKEBILIR.
*/

--BELIRLI BIR AYIRACA BAGLI OLAN METIN DIZESINDEKI KELIMELERI AYIRACLARA BAGLI OLARAK AYIRALIM.
--ONCELIKLE BUNUN ICIN BIR FONKSIYON TANIMLAYALAIM.
--MEVCUT SQL SORGUSU;
CREATE FUNCTION dbo.Kelime_Parcalama(@STR AS NVARCHAR(MAX),@DELIMITER AS VARCHAR(10))
RETURNS @RESULTTABLE TABLE (ITEM VARCHAR(MAX),IDX INT)
AS 
BEGIN

DECLARE @I AS INT=1
DECLARE @POS AS INT=1

WHILE @POS>=1
BEGIN
SET @POS=CHARINDEX(@DELIMITER,@STR)

DECLARE @ITEM AS VARCHAR(MAX)

SET @ITEM=SUBSTRING(@STR,0,@POS)
SET @STR=SUBSTRING(@STR,@POS+1,LEN(@STR)-@POS)

IF @POS=0
	SET @ITEM=@STR

INSERT INTO @RESULTTABLE(ITEM,IDX)
VALUES (@ITEM,@I)
SET @I=@I+1
END
RETURN
END

--OLUSTURDUGUMUZ FONKSIYONU BELIRLI BIR METIN DIZESI ILE TEST EDELIM.
--MEVCUT SQL SORGUSU;
SELECT * FROM DBO.Kelime_Parcalama('ALI-VELI-MERT','-') --'KELIME','AYRAC'