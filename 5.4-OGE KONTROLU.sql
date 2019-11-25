/*
MEVCUT SISTEMIMMIZDE BULUNAN OGELERI ANLIK OLARAK KONTROL ETMEMIZ GEREKEBILIR.

MICROSOFT SQL SERVER ICERISINDEKI SISTEM YAPILARINDAN BUNU KONTROL ETMEK OLDUKCA BAASITTIR.
*/

/*
--------------------------XTYPE KISALTMA ON EKLERI--------------------------

			AF = Aggregate function (CLR)

			C = CHECK constraint

			D = Default or DEFAULT constraint

			F = FOREIGN KEY constraint

			L = Log

			FN = Scalar function

			FS = Assembly (CLR) scalar-function

			FT = Assembly (CLR) table-valued function

			IF = In-lined table-function

			IT = Internal table

			P = Stored procedure

			PC = Assembly (CLR) stored-procedure

			PK = PRIMARY KEY constraint (type is K)

			RF = Replication filter stored procedure

			S = System table

			SN = Synonym

			SQ = Service queue

			TA = Assembly (CLR) DML trigger

			TF = Table function

			TR = SQL DML Trigger

			TT = Table type

			U = User table

			UQ = UNIQUE constraint (type is K)

			V = View

			X = Extended stored procedure
*/

--SISTEM DISI OLUSTURULAN TABLOLAR. U=USER TABLE
--MEVCUT SQL SORGUSU;
SELECT * FROM sysobjects WHERE xtype='U'

--YADA
SELECT * FROM sys.tables

--SISTEM DISI OLUSTURULAN TABLOLAR. FN=FUNCTION
--MEVCUT SQL SORGUSU;
SELECT * FROM sysobjects WHERE xtype='FN'

--YADA
SELECT * FROM sys.views

--SISTEMDE MEVCUT BULUNAN FARKLI XTYPE TURLERI.
--MEVCUT SQL SORGUSU;
SELECT DISTINCT xtype FROM sysobjects

--TUM BU KONTROLLER MEVCUT SECILMIS VERITABANI UZERINDE GERCEKLESMEKTEDIR.

--TUM TABLO YAPILARI ICIN (TABLE + VIEW),
--MEVCUT SQL SORGUSU;
SELECT * FROM INFORMATION_SCHEMA.TABLES

--VERITABANI UZERINDE OLUSTURULMUS TUM OBJELER ICIN,
--MEVCUT SQL SORGUSU;
SELECT * FROM INFORMATION_SCHEMA.ROUTINES