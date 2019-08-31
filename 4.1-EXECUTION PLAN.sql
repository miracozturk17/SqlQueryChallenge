/*
MEVCUT SISTEMIMIZ UZERINDE GERCEKLESTIRILEN ISLEMLRIMIZ ICIN BELIRLI BIR ISTATISTIK VE SISTEM YORULMASINI ANALIZ ETMEMIZ GEREKMEKTEDIR.

BUNUN ICIN SQL MANAGEMENT STUDIO UZERINDEKI BARDAN SORGULAMAYI GERCEKLESTIRMEDEN "INCLUDE CLIENT STATISTIC" VE "INCLUDE LIVE QUERRY STATISTIC" ACMAMIZ GEREKMEKTEDIR.
*/

USE BussinesLife

--TRIAL-1 PERSONELLERI LISTELE
--TRIAL-2 PERSONELLERI VE UCRETLERI LISTELE
--TRIAL-3 PERSONELLERE BAGLI UCRET VE DEPARTMANLARI LISTELE
--TRIAL-4 PERSONELLERE BAGLI UCRET,DEPARTMAN,SÝRKETLERÝ LISTELE
SELECT * FROM PERSON
LEFT OUTER JOIN PRICE ON PRICE.PersonId=PERSON.ID
LEFT OUTER JOIN DEPARTMENT ON DEPARTMENT.DepartmentID=PERSON.DepartmentID
LEFT OUTER JOIN COMPANY ON COMPANY.CompanyID=PERSON.CompanyID

--MEVCUT SORGUMUZUN ISTATISTIKSEL PLANI ASAGIDAKI GIBIDIR.
--BAR UZERINDEKI "INCLUDE CLIENT STATISTIC" BOLUMUNDEN ACABILIRSINIZ.
/*
																TRIAL-1			TRIAL-2			TRIAL-3			TRIAL-4			 AVERAGE
Client Execution Time											18:22:56		18:22:07		18:21:25		18:20:16	     Average	
Query Profile Statistics									
  Number of INSERT, DELETE and UPDATE statements				0				0				0				0				0.0000
  Rows affected by INSERT, DELETE, or UPDATE statements			0				0				0				0				0.0000
  Number of SELECT statements 									5				5				5				4				4.7500
  Rows returned by SELECT statements							35				33				31				28				31.7500
  Number of transactions 										0				0				0				0				0.0000
Network Statistics									
  Number of server roundtrips									5				5				5				4				4.7500
  TDS packets sent from client									5				5				5				4				4.7500
  TDS packets received from server								22				18				15				10				16.2500
  Bytes sent from client										818				692				542				382				608.5000
  Bytes received from server									70936			56697			41182			28415			49307.5000
Time Statistics										
  Client processing time										6				29				19				12				16.5000
  Total execution time											14				37				26				25				25.5000
  Wait time on server replies									8				8				7				13				9.0000
*/

--BAR UZERINDEKI "INCLUDE LIVE QUERRY STATISTIC" BOLUMUNDEN ACTIGIMZI QUERRY SHOT GORUNUMUZ EKTEKI "Person Executýon Plan" ICERISINDE.