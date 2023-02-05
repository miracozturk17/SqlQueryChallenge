/*
KIMI ZAMAN DILIMLERINDE ELDEKI KULLANICI MAILLERINI TEKIL KULLANICILAR OLARAK AYIRMAMIZ VE OZELLESTIRMEMIZ GEREKEBILIR.
BUNUN ICIN @ KARAKTERINDEN ONCEKI ALANI KULLANICI ADI VE @ KARAKTERINDEN SONRAKI MAIL BILGISINI GRUP OLARAK DERLEYEBILIRIZ.

BUNU ASAGIDAKI SORGUYU KULLANARAK GERCEKLESTIREBILIRIZ.
*/


SELECT 
	  *,
	  LEFT(KullaniciGrubu, LEN(KullaniciGrubu) - LEN(SUBSTRING(KullaniciGrubu, CHARINDEX('.com', KullaniciGrubu), LEN(KullaniciGrubu))))        AS Domain,
	  UPPER(LEFT(KullaniciGrubu, LEN(KullaniciGrubu) - LEN(SUBSTRING(KullaniciGrubu, CHARINDEX('.com', KullaniciGrubu), LEN(KullaniciGrubu))))) AS FormatliDomain
FROM
(
	SELECT 
		  UserName AS KullaniciMail,
		  SUBSTRING(UserName, CHARINDEX('@', UserName) - LEN(UserName), LEN(UserName))          AS Kullanici,
		  SUBSTRING(UserName, CHARINDEX('@', UserName) + 1 , LEN(UserName))                     AS KullaniciGrubu,
		  UPPER(SUBSTRING(UserName, CHARINDEX('@', UserName) + 1, LEN(UserName)))               AS FormatliKullaniciGrubu
	FROM [BTSDB].[dbo].[AspNetUsers]
	WHERE SUBSTRING(UserName, CHARINDEX('@', UserName) - LEN(UserName), LEN(UserName))<>''
)ttKullanici


/*
KullaniciMail	             Kullanici	        KullaniciGrubu     FormatliKullaniciGrubu    Domain         FormatliDomain
admin@miracozturk.com	     admin	        miracozturk.com	   MİRACOZTURK.COM           miracozturk    MİRACOZTURK
bilgi@miracozturk.com	     bilgi	        miracozturk.com	   MİRACOZTURK.COM	     miracozturk    MİRACOZTURK
jebelod58@xeiex.com	     jebelod58	        xeiex.com	   XEİEX.COM                 xeiex          XEİEX
mz@gmail.com	             mz	                gmail.com	   GMAİL.COM                 gmail          GMAİL
jebelod585@xeiex.com	     jebelod585	        xeiex.com	   XEİEX.COM                 xeiex          XEİEX
miracles_205_tr@gmail.com    miracles_205_tr    gmail.com	   GMAİL.COM                 gmail          GMAİL
*/
