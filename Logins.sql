DECLARE @login NVARCHAR(100);
DECLARE @sqlString NVARCHAR(MAX);
DECLARE @sqlParams NVARCHAR(1000);
DECLARE @database NVARCHAR(100) = 'msdb'
DECLARE @i int
DECLARE @numrows int

--logins & mapping
create table #usernames (idx int IDENTITY(1,1), username varchar(35))
INSERT INTO #usernames (username) values ('COMPANY\gMSA_SCOM_DWR$'),('COMPANY\gMSA_SCOM_DAS$'),('COMPANY\gMSA_SCOM_MSAA$'),('COMPANY\gMSA_SCOM_DWW$'),('COMPANY\gMSA_SQLSVC$')
SET @i = 1
SET @numrows = (SELECT COUNT(*) FROM #usernames)
IF @numrows > 0
WHILE (@i <= (SELECT MAX(idx) FROM #usernames))
BEGIN

SET @login = (SELECT username FROM #usernames WHERE idx = @i)

SET @sqlString = '
USE [master];

IF NOT EXISTS (SELECT [name] from master.sys.server_principals Where [name] = ''' + @login + ''')
BEGIN
print ''Creating login''
CREATE LOGIN [' + @login +'] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=us_english;
print ''Login created successfully''
END

USE [' + @database +'];
IF NOT EXISTS
(SELECT name
 FROM sys.database_principals
 WHERE name = ''' + @login + ''')
BEGIN
CREATE USER [' + @login + '] FOR LOGIN [' + @login + '] WITH DEFAULT_SCHEMA = dbo;
print ''User created successfully''

ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [' + @login + '];
print ''User added to role SQLAgentOperatorRole''
ALTER ROLE [SQLAgentReaderRole] ADD MEMBER [' + @login + '];
print ''User added to role SQLAgentReaderRole''
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [' + @login + '];
print ''User added to role SQLAgentUserRole''
END


';
SET @sqlParams = '@login NVARCHAR(100), @database NVARCHAR(100)';
EXEC sp_executesql @sqlString, @sqlParams, @login, @database;

SET @i = @i + 1
END

--just logins
create table #logins (idx int IDENTITY(1,1), username varchar(35))
INSERT INTO #logins (username) values ('COMPANY\gMSA_SCOM_DWW$'),('COMPANY\gMSA_SQLSVC$')
SET @i = 1
SET @numrows = (SELECT COUNT(*) FROM #logins)
IF @numrows > 0
WHILE (@i <= (SELECT MAX(idx) FROM #logins))
BEGIN

SET @login = (SELECT username FROM #logins WHERE idx = @i)

SET @sqlString = '
USE [master];

IF NOT EXISTS (SELECT [name] from master.sys.server_principals Where [name] = ''' + @login + ''')
BEGIN
print ''Creating login''
CREATE LOGIN [' + @login +'] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=us_english;
print ''Login created successfully''
END

';
SET @sqlParams = '@login NVARCHAR(100)';
EXEC sp_executesql @sqlString, @sqlParams, @login;

SET @i = @i + 1
END

drop table #usernames
drop table #logins