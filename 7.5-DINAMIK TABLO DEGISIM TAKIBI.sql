/*
VERITABANLARI ICERISINDEKI TABLOLAR UZERINDE GERCEKLESEN DEGISIMLERI TAKIP ETMENIZI SAGLAYAN DINAMIK DEGISIM TAKIP YAPISI.
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MBT].[dbo].[tTableSizeGrowth](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[table_schema] [nvarchar](256) NULL,
	[table_name] [nvarchar](256) NULL,
	[table_rows] [bigint] NULL,
	[reserved_space] [bigint] NULL,
	[data_space] [bigint] NULL,
	[index_space] [bigint] NULL,
	[unused_space] [bigint] NULL,
	[date] [datetime] NULL,
	[database_name] [nvarchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [MBT].[dbo].[tTableSizeGrowth] ADD  CONSTRAINT [DF_tTableSizeGrowth_date]  DEFAULT (dateadd(day,(0),datediff(day,(0),getdate()))) FOR [date]
GO

 
CREATE PROCEDURE [MBT].[sp_tTableSizeGrowth] 
(
	@DatabaseName VARCHAR(50)
)
AS
BEGIN
 SET NOCOUNT ON

 IF(@DatabaseName IS NULL OR @DatabaseName='MBT')
 BEGIN
 RAISERROR (15600,-1,-1, 'Lütfen veritabaný/database adý parametresini boþ býrakmayýnýz.');
 RETURN;
 END

 DECLARE
 @max INT,
 @min INT,
 @table_name NVARCHAR(256)='',
 @table_schema NVARCHAR(256)='',
 @sql NVARCHAR(4000)
 

 IF (SELECT OBJECT_ID('tempdb..#results')) IS NOT NULL
 BEGIN
  DROP TABLE #results
 END

 IF (SELECT OBJECT_ID('tempdb..#table')) IS NOT NULL
 BEGIN
  DROP TABLE #table
 END
 
 CREATE TABLE #table(
 id INT IDENTITY(1,1) PRIMARY KEY,
 table_name NVARCHAR(256),
 table_schema NVARCHAR(256)
 )

 CREATE TABLE #results
 (
	  [id] int identity primary key,	
	  [table_schema] [nvarchar](256) NULL,
	  [table_name] [nvarchar](256) NULL,
	  [table_rows] [nvarchar](MAX) NULL,
	  [reserved_space] [nvarchar](MAX) NULL,
	  [data_space] [nvarchar](MAX) NULL,
	  [index_space] [nvarchar](MAX) NULL,
	  [unused_space] [nvarchar](MAX) NULL
 )
 
 EXEC ('INSERT #table(table_schema, table_name)  SELECT    table_schema, table_name FROM '+@DatabaseName+'.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE=''BASE TABLE''');
 --WHERE table_schema + '.' + table_name IN ('HumanResources.Employee','Production.Product', 'Purchasing.Vendor') --INSERT TABLE NAMES TO MONITOR

 IF EXISTS(SELECT 1 FROM #table)
 BEGIN
	SET @min =1;
	SELECT @max =MAX(id) FROM #table
 END
 

 WHILE @min <= @max
 BEGIN
 DECLARE @SCOPEIDENT int=0
  SELECT 
   @table_name = table_name,
   @table_schema = table_schema
  FROM
   #table
  WHERE
   id = @min
   
  SELECT @sql = 'USE ['+@DatabaseName+']; EXEC sp_spaceused ''[' + @table_schema + '].[' + @table_name + ']'''
 
  INSERT #results(table_name, table_rows, reserved_space, data_space, index_space, unused_space)
  EXEC (@sql) SELECT @SCOPEIDENT = @@IDENTITY
  
  UPDATE 
	#results  
  SET 
	  table_schema = @table_schema, 
	  table_name= REPLACE(REPLACE(table_name,QUOTENAME(@table_schema)+'.[',''),']',''),
    --REMOVE "KB" FROM RESULTS FOR REPORTING (GRAPH) PURPOSES
	  data_space= CAST(REPLACE(ISNULL(data_space,0),' KB','') as bigint),
	  reserved_space= CAST(REPLACE(ISNULL(reserved_space,0),' KB','') as bigint),
	  index_space= CAST(REPLACE(ISNULL(index_space,0),' KB','') as bigint),
	  unused_space= CAST(REPLACE(ISNULL(unused_space,0),' KB','') as bigint)
  WHERE 
	id = @SCOPEIDENT
  SELECT @min = @min + 1
 END
 
INSERT INTO tTableSizeGrowth (table_schema, table_name, table_rows, reserved_space, data_space, index_space, unused_space,database_name)
SELECT 
	table_schema, 
	table_name, 
	table_rows,
	reserved_space,
	data_space,
	index_space,
	unused_space,
	@DatabaseName as database_name
FROM #results
  
 DROP TABLE #results
 DROP TABLE #table
 SET NOCOUNT OFF
END
GO

EXEC sp_MSforeachdb 'USE [?] IF DB_ID(''?'') > 4 BEGIN exec master..sp_TableSizeGrowth ''?'' END '

EXEC sp_TableSizeGrowth 'MBT'

SELECT * FROM [MBT].[dbo].[tTableSizeGrowth]