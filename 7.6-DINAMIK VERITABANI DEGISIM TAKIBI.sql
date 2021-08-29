/*
VERITABANLARI UZERINDE GERCEKLESEN DEGISIMLERI TAKIP ETMENIZI SAGLAYAN DINAMIK DEGISIM TAKIP YAPISI.
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MBT].[dbo].[tDatabaseFileSize](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[database_id] [int] NULL,
	[file_id] [int] NULL,
	[file_type_desc] [nvarchar](25) NULL,
	[name] [nvarchar](40) NULL,
	[physical_name] [nvarchar](512) NULL,
	[state_desc] [nvarchar](40) NULL,
	[size] [int] NULL,
	[max_size] [int] NULL,
	[growth] [int] NULL,
	[is_sparse] [bit] NULL,
	[is_percent_growth] [bit] NULL,
	[collect_date] [datetime] NULL,
	[table_name] [nvarchar](256) NULL
) ON [PRIMARY]
GO

USE [MBT]
GO
/****** Object:  StoredProcedure [can].[sp_DatabaseFileSizeGrowth]    Script Date: 6/8/2020 4:59:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [sp_DatabaseFileSizeGrowth]
AS
BEGIN
SET NOCOUNT ON
INSERT INTO tDatabaseFileSize
(
	[database_id],
	[file_id],
	[file_type_desc],
	[name],
	[physical_name],
	[state_desc],
	[size],
	[max_size],
	[growth],
	[is_sparse],
	[is_percent_growth],
	[collect_date]
)
SELECT
	[database_id],
	[file_id],
	[type_desc],
	[name],
	[physical_name],
	[state_desc],
	[size],
	[max_size],
	[growth],
	[is_sparse],
	[is_percent_growth],
	GETDATE()
	FROM sys.master_files
	SET NOCOUNT OFF
END
