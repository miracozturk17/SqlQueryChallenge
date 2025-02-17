 /*
BAZI GERCEKLESTIRMEMIZ GEREKEN TARIH DUZENLEMESI ICEREN SORGULARIMIZDA KOLAYLIK ADINA MEVCUT SQL SERVER FONKSIYONLARINDAN YARARLANIRIZ.
*/

/*
		DATE TIME TIPLERI

time			: hh:mm:ss[.nnnnnnn]

date			: YYYY-MM-DD

samalldatetime  : YYYY-MM-DD hh:mm:ss

datetime        : YYYY-MM-DD hh:mm:ss[.nnn]

datetime2       : YYYY-MM-DD hh:mm:ss[.nnnnnnn]

datetimeoffset  : YYYY-MM-DD hh:mm:ss[.nnnnnnn] [+|-]hh:mm 

*/ 

--ANLIK OLARAK SISTEM ZAMAN SORGULARI
SELECT GETDATE() AS [Simdiki Zaman] --2019-06-12 21:11:30.440

SELECT CURRENT_TIMESTAMP AS [Simdiki Zaman] --2019-06-12 21:14:46.050 ANSI SQL

SELECT SYSDATETIME() AS [Simdiki Zaman] --2019-06-12 21:15:54.6942024 

SELECT SYSDATETIMEOFFSET() AS [Simdiki Zaman] --2019-06-12 21:17:15.1613225 +03:00 --> ISTANBUL BAZ ALINAN ZAMAN (TIME ZONE)

SELECT GETUTCDATE() AS [Simdiki Zaman] --2019-06-12 18:18:44.463

SELECT SYSUTCDATETIME() AS [Simdiki Zaman] --2019-06-12 18:19:24.7182841

--GETTIME() FONKSIYONUNU TABLO ICINDE SUTUNLARIN ZAMAN TIPLERI OLARAK TANIMLAYIP INSERT ETTIK
INSERT INTO TIME VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

SELECT * FROM TIME

--ISDATE() FONKSIYONU datetime2 VERISI MEVCUT OLUP OLMADIGINI SORGULAR 
SELECT ISDATE(GETDATE()) AS [DATETIME2 MI ?]
SELECT ISDATE('MIRAC')

--DAY() FONKSIYONU VERILEN VERI ICERISINDEKI GUNU GERI DONDURUR 
SELECT DAY(GETDATE()) AS [VERILEN GUN]

--MONTH() FONKSIYONU VERILEN VERI ICERISINDEKI AYI GERI DONDURUR 
SELECT MONTH(GETDATE()) AS [VERILEN AY]

--YEAR() FONKSIYONU VERILEN VERI ICERISINDEKI AYI GERI DONDURUR 
SELECT YEAR(GETDATE()) AS [VERILEN YIL]

--DATENAME() FONKSIYONU VERILEN VERI ICERISINDEKI MEVCUT TUMA ZAMAN BELIRTECLERINI GERI DONDURUR 
SELECT DATENAME(DAY,GETDATE()) AS [VERILEN GUN NO]
SELECT DATENAME(WEEKDAY,GETDATE()) AS [VERILEN GUN ADI]
SELECT DATENAME(WEEK,GETDATE()) AS [VERILEN YIL ICINDEKI HAFTA NO]
SELECT DATENAME(QUARTER,GETDATE()) AS [KACINCI CEYREK]
SELECT DATENAME(YY,GETDATE()) AS [YIL]

--YAS VE KISI BILGILERINI GERI DONDUREN SORGU 
SELECT P.Name,P.BirthDate,P.City,P.EMail,
	   DATENAME(WEEKDAY,BirthDate) AS [GUN],
	   DATENAME(YEAR,BirthDate) AS [YIL],
	   DATEDIFF(YEAR,BirthDate,GETDATE()) AS [YAS]	--DATEDIFF() BELIRLLI KOSULDA /YIL-AY-GUN/ BAZINDA IKI ZAMAN ARASINDAKI SUREYI HESAPLAR
	 FROM PERSON P

--DATEADD() FONKSIYONU VERILEN TARIH ICINE ISTENILEN SURE ZARFINI EKLER
SELECT DATEADD(DAY,20,'2019-06-01 01:01:01.100') AS [Eklenmis Gun]
SELECT DATEADD(MONTH,2,'2019-06-01 01:01:01.100') AS [Eklenmis Ay]
SELECT DATEADD(YEAR,2,'2019-06-01 01:01:01.100') AS [Eklenmis Yil]


--SIRKET NE KADAR FAALIYET GOSTERMIS
--SIRKET KURULUS TARIHINDEN ITIBAREN KIM NE KADAR SURE ZARFINDA SIRKET BUNYESINDE BULUNMUS SEKLINDE DUZENLENEBILIR
--CREATE FUNCTION fn_PersonalTimeZone(@PersonalTimeZone)
--RETURNS nvarchar(50)
--AS
--BEGIN
DECLARE @DOB datetime,
		@tempdate datetime,
		@yil int,
		@ay int,
		@gun int

SET  @DOB= 1992-06-18  --SIRKET KURULUS TARIHI

SELECT @tempdate = @DOB

SELECT @yil = DATEDIFF(YEAR,@tempdate,GETDATE())-
			  CASE 
					WHEN (MONTH(@DOB)>MONTH(GETDATE())) OR
				         (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
					THEN 1
					ELSE 0
			  END

SELECT @tempdate = DATEADD(YEAR,@yil,@tempdate)

SELECT @ay  = DATEDIFF(MONTH,@tempdate,GETDATE())-
			  CASE
					WHEN DAY(@DOB) > DAY(GETDATE())
					THEN 1
					ELSE 0
			  END

SELECT @tempdate = DATEADD(MONTH,@ay,@tempdate)

SELECT @gun = DATEDIFF(DAY,@tempdate,GETDATE())

SELECT @yil AS [Yil] , @ay AS [Ay] , @gun AS [Gun]

--DECLARE @TimeZone NVARCHAR(50)
--SET @TimeZone = @yil + 'Yil' + @ay + 'Ay' + @gun 'Gun'
--RETURN @TimeZone
--END
