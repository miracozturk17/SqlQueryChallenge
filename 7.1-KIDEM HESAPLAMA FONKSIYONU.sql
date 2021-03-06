USE [PowerBI]
GO
/** Object:  UserDefinedFunction [dbo].[fn_KidemHesaplama]    Script Date: 22.02.2021 12:07:29 **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_KidemHesaplama] (@Tarih1 DATETIME,@Tarih2 DATETIME)
RETURNS CHAR(50)
AS
BEGIN
DECLARE @Gun AS INT,@Ay AS INT,@Yil AS INT,@GunAl AS INT,@AyAl AS INT,@Sonuc CHAR(100)
IF @Tarih2>=@Tarih1
BEGIN
IF DAY(@Tarih2)>=DAY(@Tarih1)
BEGIN
SET @Gun=DAY(@Tarih2)-DAY(@Tarih1)
END
ELSE
BEGIN
SET @Gun=(DAY(@Tarih2)+30)-DAY(@Tarih1)
SET @GunAl=1
END

IF (MONTH(@Tarih2)-ISNULL(@GunAl,0))>=MONTH(@Tarih1)
BEGIN
SET @Ay=MONTH(@Tarih2)-MONTH(@Tarih1)
END
ELSE
BEGIN
SET @Ay=(MONTH(@Tarih2)+12)-(MONTH(@Tarih1)+ISNULL(@GunAl,0))
SET @AyAl=1
END

IF (YEAR(@Tarih2)-ISNULL(@AyAl,0))>=YEAR(@Tarih1)
BEGIN
SET @Yil=YEAR(@Tarih2)-(YEAR(@Tarih1)+ISNULL(@AyAl,0))
END
ELSE
BEGIN
SET @Yil=YEAR(@Tarih2)-YEAR(@Tarih1)
END
SET @Sonuc=RTRIM(CONVERT(CHAR(3),@Yil))+' Yýl ' + LTRIM(CONVERT(CHAR(2),@Ay))+' Ay '+ RTRIM(CONVERT(CHAR(2),@Gun)) +' Gün '

END
ELSE
BEGIN
SET @Sonuc='Bitis Tarihi Baslangýc Tarihinden buyuk olamaz.'
END
RETURN @Sonuc
END