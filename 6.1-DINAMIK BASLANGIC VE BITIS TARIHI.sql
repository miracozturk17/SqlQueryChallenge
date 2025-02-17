/*
MEVCUT YAPILARIMIZ ICERISINDE PARAMETRELI SEKILDE BASLANGIC VE BITIS ZAMANI ICEREN YAPILARA IHTIYAC DUYABILIRIZ.
*/

--DINAMIK OLARAK 'N' AY GERIDEN BUGUNE KADAR OLAN ZAMANI KAPSAYAN BIR YAPI OLUSTURALIM.
--MEVCUT SQL SORGUSU;
DECLARE @Month	   INT  = 3
DECLARE @StartDate DATE = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-@Month, 0)
DECLARE @EndDate   DATE = DATEFROMPARTS (YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()))

/*
BU YAPIYI CESITLI VARYASYONLAR OLARAK KULLANABILIRSINIZ.

SAAT - GUN - HAFTA - AY - CEYREK - YIL
*/