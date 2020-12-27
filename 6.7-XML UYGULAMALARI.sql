SELECT p.FirstName,p.LastName,p.EmailPromotion
FROM Person.Person p
WHERE p.BusinessEntityID < 11111155
FOR XML RAW;

SELECT p.FirstName,p.LastName,p.EmailPromotion
FROM Person.Person p
WHERE p.BusinessEntityID < 11111155
FOR XML RAW , ELEMENTS;

SELECT p.FirstName,p.LastName,p.EmailPromotion
FROM Person.Person p
WHERE p.BusinessEntityID < 11111155
FOR XML RAW('miracozturk.com'), ELEMENTS, ROOT('MiracOzturk'); --NULL OLAN DEGERLER GELMEMEKTEDIR.


SELECT p.FirstName,p.LastName,p.EmailPromotion
FROM Person.Person p
WHERE p.BusinessEntityID < 11111155
FOR XML RAW('miracozturk.com'), ELEMENTS XSINIL, ROOT('MiracOzturk'); --ELEMENTS XSINIL NULL OLANLAR DAHIL GETIRECEKTIR.


SELECT p.FirstName,p.LastName,p.EmailPromotion
FROM Person.Person p
WHERE p.BusinessEntityID < 11111155
FOR XML AUTO;


SELECT
 1 AS TAG,
 NULL AS PARENT,
 p.BusinessEntityID AS [Person!1!ID],
 p.PersonType       AS [Person!1!PersonType],
 p.MiddleName       AS [Person!1!MiddleName!element],
 p.FirstName        AS [Person!1!FirstName!element],
 p.LastName         AS [Person!1!LastName!element]
FROM Person.Person p
ORDER BY p.BusinessEntityID ASC
FOR XML EXPLICIT;


SELECT
 1 AS TAG,
 NULL AS PARENT,
 p.BusinessEntityID AS [Person!1!ID],
 p.PersonType       AS [Person!1!PersonType],
 p.MiddleName       AS [Person!1!MiddleName!element],
 p.FirstName        AS [Person!1!FirstName!element],
 p.LastName         AS [Person!1!LastName!element],
 p.Title            AS [Person!1!LastName!hide], --HIDE ILE ISTENILEN SUTUNLARI GIZLIYEBILIYORUZ.
 p.Suffix           AS [Person!1!LastName!elementxsinil] --XSINIL ILE NULL OLANLARI DA GETIRDIK.
FROM Person.Person p
ORDER BY p.BusinessEntityID ASC
FOR XML EXPLICIT;


SELECT
*
FROM Person.Person p
FOR XML PATH -- STANDART XML CIKTISI.


CREATE ENDPOINT EP_Persons
STATE = STARTED
AS HTTP
(
 PATH = '/AWorks',
 AUTHENTICATION = (INTEGRATED),
 PORTS = (CLEAR),
 SITE = 'localhost'
)
FOR SOAP
(
 WEBMETHOD 'Persons'
 (NAME = 'AdventureWorks2012.dbo.sp_Persons'),
 WEBMETHOD 'Persons'
 (NAME = 'AdventureWorks2012.dbo.sp_Persons'),
 BATCHES = DISABLED,
 WSDL = DEFAULT,
 DATABASE = 'AdventureWorks2012',
 NAMESPACE = 'http://AdventureWorks/'
)										--http://localhost/AWorks?wsdl LINKINI CALISTI. SQL LISANSLI OLMALI !!!