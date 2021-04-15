/*
KURULUM GENEL ADIMLARI ICIN;
https://www.mssqltips.com/sqlservertip/4577/create-a-linked-server-to-mysql-from-sql-server/
https://www.mssqltips.com/sqlservertip/4570/access-mysql-data-from-sql-server-via-a-linked-server/#:~:text=Create%20a%20SQL%20Server%20Linked,you%20want%20to%20link%20to.

LINKED OLUSTURMAK ICIN TSQL;
*/


USE [master]
GO

/** Object:  LinkedServer [MYSQL]    Script Date: 13.04.2021 17:36:50 **/
EXEC master.dbo.sp_addlinkedserver @server = N'MYSQL', @srvproduct=N'MYSQL', @provider=N'MSDASQL', @datasrc=N'MYSQL'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'MYSQL',@useself=N'False',@locallogin=NULL,@rmtuser=N'root',@rmtpassword='root'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MYSQL', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO