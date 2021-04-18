/*
TEXT ICERISINDEKI SAYI VE ALFABETIK KARAKTERLERI AYIRIP GRUPLMAKA UZERINE.
*/



CREATE TABLE Test
(
	TestValue NVARCHAR(100)
)

INSERT INTO Test VALUES ('M1234ÝR75AÇ')
INSERT INTO Test VALUES ('ÖM842ER')
INSERT INTO Test VALUES ('KA72256DÝ241543R')
INSERT INTO Test VALUES ('RECE5366084556P')

------------------------------------------------------------------------
CREATE FUNCTION udf_ExtractNumbers
(  
  @Input VARCHAR(255)  
)  
RETURNS VARCHAR(255)  
AS  
BEGIN  
  DECLARE @AlphabetIndex INT = PATINDEX('%[^0-9]%', @Input)  
  BEGIN  
    WHILE @alphabetIndex > 0  
    BEGIN  
      SET @Input = STUFF(@Input, @AlphabetIndex, 1, '' )  
      SET @alphabetIndex = PATINDEX('%[^0-9]%', @Input )  
    END  
  END  
  RETURN @Input
END
------------------------------------------------------------------------
CREATE FUNCTION udf_ExtractAlphabet
(  
  @Input VARCHAR(255)  
)  
RETURNS VARCHAR(255)  
AS  
BEGIN  
  DECLARE @AlphabetIndex int = Patindex('%[^a-zA-Z]%', @Input)  
  BEGIN  
    WHILE @AlphabetIndex > 0  
    BEGIN  
      SET @Input = Stuff(@Input, @AlphabetIndex, 1, '' )  
      SET @AlphabetIndex = Patindex('%[^a-zA-Z]%', @Input)  
    END  
  END  
  RETURN @Input
END
------------------------------------------------------------------------

SELECT * FROM Test
SELECT 
	dbo.udf_ExtractNumbers (Test.TestValue)  TestExtractNumbers, 
	dbo.udf_ExtractAlphabet(Test.TestValue) TestExtractAlphabet
FROM Test