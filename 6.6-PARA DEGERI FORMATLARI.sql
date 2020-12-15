/*
PARA DEGERI FORMATLARI.

EK FORMATLAR ICIN : https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-lcid/a9eac961-e77d-41a6-90a5-ce1a8b0cdb9c?redirectedfrom=MSDN
*/


DECLARE @paraDegeri INT = 500;
SELECT FORMAT ( @paraDegeri, 'c', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( @paraDegeri, 'c', 'en-US' ) AS ABD;
SELECT FORMAT ( @paraDegeri, 'c', 'fr-FR' ) AS Fransa;
SELECT FORMAT ( @paraDegeri, 'c', 'de-DE' ) AS Almanca;
SELECT FORMAT ( @paraDegeri, 'c', 'zh-cn' ) AS Cin;


SELECT FORMAT(@paraDegeri,'c') AS Para;
SELECT FORMAT(@paraDegeri,'c1') AS Para;
SELECT FORMAT(@paraDegeri,'c2') AS Para;
SELECT FORMAT(@paraDegeri,'c3') AS Para;