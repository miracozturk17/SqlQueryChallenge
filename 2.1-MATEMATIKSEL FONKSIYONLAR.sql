/*
SQL SERVER ICERISINDE YER YER MATEMATIKSEL ISLEMLER ICEREN YOGUN YAPILAR KURMAMIZ GEREKEBILIR.
BU YAPILARI DAHA ANLASILIR VE KOLAY ISLENEBILIR HALE GETIRMEK ICIN MEVCUT SQL SERVER ICERISINDEKI MATEMATIKSEL FONSIYONLARDAN YARARLANABILIRIZ.
*/

USE BussinesLife
SELECT * FROM PRICE

--ABS() FONKSIYONU MEVCUT VERIYI POZITIF SEKILDE ELE ALIR
SELECT ABS(Price) FROM PRICE

--CEILING() FONKSIYONU MEVCUT VERIYI BIR UST SAYIYA (TAM SAYI OLARAK) YUVARLAR
SELECT CEILING(Price) FROM PRICE
SELECT CEILING(11110.500) 
SELECT CEILING(-11110.500) 

--FLOOR() FONKSIYONU MEVCUT VERIYI BIR ALT SAYIYA (TAM SAYI OLARAK) YUVARLAR
SELECT FLOOR(Price) FROM PRICE
SELECT FLOOR(11110.500) 
SELECT FLOOR(-11110.500) 

--POWER(A,B) (A:ALINACAK SAYI - B:ALINACAK KUVVET) FONKSIYONU MEVCUT VERININ KUVVETINI ALIR
SELECT POWER(2,3)

--SQRT() FONKSIYONU MEVCUT VERININ KAREKOKUNU ALIR
SELECT SQRT(81)
SELECT SQRT(81.1)

--RAND() FONKSIYONU RASTGELE 0-1 ARASINDA SAYI OLUSTURUR
SELECT RAND()

--1-100 ARASI RASTGELE SAYI URETEN SORGU
SELECT FLOOR(RAND()*100) AS [1-100 Arasi Rastgele Sayi]

--RASTGELE 1-100000 ARASI SAYI URETEN PROSEDUR
ALTER PROCEDURE spRandomNumber
AS
BEGIN
DECLARE @Sayi INT 
DECLARE @RANDOMTABLE table(Sayi INT) 
SET @Sayi = 0 
DECLARE @Sayac INT 
SET @Sayac = 0 
WHILE @Sayac < 60
BEGIN 
   WHILE @Sayac = 0 
    BEGIN 
     SELECT @Sayac = CONVERT(INT, RAND() * 100000) 
     IF @Sayac in (SELECT * FROM @RANDOMTABLE) 
      BEGIN 
       SET @Sayac = 0	
     END 
     ELSE 
      BEGIN 
       INSERT INTO @RANDOMTABLE(Sayi) VALUES(@Sayi) 
       SET @Sayac = @Sayac + 1 
      END 
     END 
     SET @Sayi = 0 
    END 
END	 