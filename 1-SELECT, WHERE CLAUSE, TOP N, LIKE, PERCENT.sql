/*
MEVCUT VERITABANI ICERISINDEKI HERHANGI BIR TABLODAKI VERIYI DOGRUDAN VEYA BIR KISIT OLUSTURARAK CEKME ISLEMINI BASITCE SORGU OLARAK ADLANDIRABILIRIZ.
*/

--* GENEL TUM KOLONLARI GETIRIR
--KISILER TABLOSUNDAKI TUM MEVCUT KAYITLAR
SELECT * FROM PERSON

--DISTINCT FARKLI OLAN KAYIT DEGERLERINI GETIRIR
--FARKLI SEHIRLER
SELECT DISTINCT City FROM PERSON

--ILK KOLONU DONDUREN SORGU 
SELECT (1) FROM PERSON

--WHERE ARANILAN BIR DEGER VEYA DURUM ICIN KULLANILIR
--ISTENILEN SEHRI ICEREN KAYITLARI DONDUREN SORGU
SELECT * FROM PERSON
WHERE City = 'SARAJEVO'

--OLMASINI ISTEMEDIGIMIZ SEHIR DISINDAKI KAYITLARI GETIREN SORGU
SELECT * FROM PERSON
WHERE City  <> 'SARAJEVO'

--V2
SELECT * FROM PERSON
WHERE City != 'SARAJEVO'

--IN ICERSINDE BULUNAN VEYA ISTENILEN DEGERLERE GORE ARAMAYI KISITLAR
--BELIRLI YASLARDAKI KISILERI GETIREN SORGU
SELECT * FROM PERSON
WHERE Age IN (27,23)

--OR BAGLAYICI OPERATOR OLARAK KULLANILIR
--V2
SELECT * FROM PERSON
WHERE Age = 23 OR Age = 27

--BETWEEN BELIRLI ARALIKLAR ICIN KULLANILIR
--BELIRLI YAS ARALIGINDAKI KISILERI GETIREN SORGU
SELECT * FROM PERSON
WHERE Age BETWEEN 23 AND 27

--LIKE ISTENILEN VERI DEGERINE GORE ARAMA MODELLER
--BELIRLI SEHIR HARFI ILE BASLAYAN KAYITLARI GETIREN SORGU
SELECT * FROM PERSON
WHERE City LIKE 'S%'

--BELIRLI SEHIR HARFI ILE BITEN KAYITLARI GETIREN SORGU
SELECT * FROM PERSON
WHERE City LIKE '%A'

--BELIRLI HARFI ICEREN SEHIR ILE ILGILI KAYITLARI GETIREN SORGU
SELECT * FROM PERSON
WHERE City LIKE '%S%'

--NOT LIKE ISTENILMEYEN VERI DEGERINE GORE ARAMA MODELLER
--MAIL ADRESI YANLIS VEYA FAKE OLAN KAYILARI GETIREN SORGU
SELECT * FROM PERSON
WHERE EMail NOT LIKE '%@%'

--BELIRLI MAIL ADRESI ILE ILGILI KAYITLARI GETIREN SORGU
SELECT * FROM PERSON
WHERE EMail NOT LIKE '_@gmaIl.com'

--BELIRLI HARF ARALIGINDAKI KAYITLARI GETIREN SORGU
SELECT * FROM PERSON
WHERE Name  LIKE '[^MKO]%'

--V2
SELECT * FROM PERSON
WHERE (Name  LIKE '[^MKO]%' AND Age=23)
ORDER BY Name DESC /*ASC*/

--PERCENT KAYIT SAYISINI YUZDELIK OLARAK GETIRIR 
--YUZDELIK BAZDA KAYIT GETIREN SORGU
SELECT TOP (50) PERCENT * FROM PERSON 