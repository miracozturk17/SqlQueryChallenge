/*
GLOBAL FORMATLANMIS TARIH DEGERLERI.
*/

SELECT FORMAT(GETDATE(), 'yyyy.MM.d HH:MM:ss');

DECLARE @tarIh DATETIME = GETDATE()

SELECT FORMAT ( @tarIh, 'd', 'tr-TR' ) AS 'Turkce'
 ,FORMAT ( @tarIh, 'd', 'en-US' ) AS 'Amerikan Ingilizcesi'
 ,FORMAT ( @tarIh, 'd', 'en-gb' ) AS 'Ingiltere Ingilizcesi'
 ,FORMAT ( @tarIh, 'd', 'de-de' ) AS 'Almanca'
 ,FORMAT ( @tarIh, 'd', 'zh-cn' ) AS 'Cince'; 


SELECT FORMAT ( @tarIh, 'D', 'tr-TR' ) AS 'Turkce'
 ,FORMAT ( @tarIh, 'D', 'en-US' ) AS 'Amerikan Ingilizcesi'
 ,FORMAT ( @tarIh, 'D', 'en-gb' ) AS 'Ingiltere Ingilizcesi'
 ,FORMAT ( @tarIh, 'D', 'de-de' ) AS 'Almanca'
 ,FORMAT ( @tarIh, 'D', 'zh-cn' ) AS 'Cince'; 


SELECT FORMAT ( GETDATE(), 'd', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'dd', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'ddd', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'dddd', 'tr-TR' ) AS Turkiye;


SELECT FORMAT ( GETDATE(), 'm', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'mm', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'mmm', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'mmmm', 'tr-TR' ) AS Turkiye;


SELECT FORMAT ( GETDATE(), 'y', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'yy', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'yyy', 'tr-TR' ) AS Turkiye;