SELECT * FROM [dbo].[CariCiro]

/*ID OLUSTURMA*/
UPDATE CariCiroMBT
SET DepoTeslimTipiId= (1+ROUND( 10 * RAND(CONVERT(VARBINARY, NEWID())), 0))


/*GUNCELLEME VE SILMELER*/
DECLARE @EskiStok NVARCHAR(50)='ZTE'
DECLARE @YeniStok NVARCHAR(50)='LORENTO'

UPDATE Stok
SET StokIsim = REPLACE(StokIsim,@EskiStok,@YeniStok)
UPDATE Stok
SET MarkaKodu = REPLACE(MarkaKodu,LEFT(@EskiStok,3),LEFT(@YeniStok,3))
UPDATE Stok
SET Marka = REPLACE(Marka,@EskiStok,@YeniStok)

UPDATE Cari
SET PazarlamaSorumlusu=(1+ROUND( 10 *RAND(convert(varbinary, newid())), 0))

DECLARE @EskiStok NVARCHAR(250)='%Apacer%'
DECLARE @YeniStok NVARCHAR(250)='LORENTO'

UPDATE HedefGenel
SET HedefBaslik = REPLACE(HedefBaslik,@YeniStok,@EskiStok)
WHERE HedefTip='IlkFatura'

UPDATE Stok
SET MarkaKodu = REPLACE(MarkaKodu,LEFT(@EskiStok,3),LEFT(@YeniStok,3))
UPDATE Stok
SET Marka = REPLACE(Marka,@EskiStok,@YeniStok)

UPDATE HedefGenel 
SET HedefBaslik=REPLACE(SUBSTRING(HedefBaslik,1,DATALENGTH(HedefBaslik)),'Ýntel','Yuan') 
WHERE HedefBaslik LIKE '%Ýntel%'

DELETE FROM HedefGenel WHERE HedefBaslik LIKE '%Genel Satýþ%'