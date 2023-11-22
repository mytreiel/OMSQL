------------------------------------------------------
-- Change Variables Below
------------------------------------------------------

-- Operations Manager DB Info
DECLARE @OriginalOpsMgrSQLDB nvarchar(50) = '$OldSQLDatabase'
DECLARE @OpsMgrSQLInstance nvarchar(50) = '$NewOpsDBServerName'

-- Operations Manager DW DB Info
DECLARE @DWSQLInstance nvarchar(50) = '$NewDWServerName'

------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE
------------------------------------------------------

DECLARE @UseOpsMgrDB nvarchar(50) = QUOTENAME(@OriginalOpsMgrSQLDB) + N'.sys.sp_executesql'
DECLARE @tblName varchar(100)
DECLARE @colName varchar(100)
DECLARE @sqlstmt nvarchar(1000)

BEGIN TRY
IF (EXISTS (SELECT * 
                 FROM tempdb.INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND TABLE_NAME LIKE '#tmp_DBMigration%'))
BEGIN
drop table #tmp_DBMigration
END
END TRY
BEGIN CATCH
END CATCH
CREATE TABLE #tmp_DBMigration
(
	TableName varchar(100),
	OldValue varchar(50),
	NewValue varchar(50)
)

BEGIN TRY
TRUNCATE TABLE #tmp_DBMigration
END TRY
BEGIN CATCH
END CATCH

--
--Update OperationsManager
--
--USE OperationsManager

SET @tblName = 'MT_Microsoft$SystemCenter$ManagementGroup'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'SQLServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @OpsMgrSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt

SET @tblName = 'MT_Microsoft$SystemCenter$OpsMgrDB$AppMonitoring'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'MainDatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @OpsMgrSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt

SET @tblName = 'MT_Microsoft$SystemCenter$OpsMgrDB$AppMonitoring_Log'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'Post_MainDatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @OpsMgrSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt

--
--End update OperationsManager
--

--
--Update DW
--
--USE OperationsManager

SET @tblName = 'MT_Microsoft$SystemCenter$DataWarehouse'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'MainDatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @DWSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt


SET @tblName = 'MT_Microsoft$SystemCenter$DataWarehouse$AppMonitoring'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'MainDatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @DWSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt


SET @tblName = 'MT_Microsoft$SystemCenter$DataWarehouse$AppMonitoring_Log'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'Post_MainDatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @DWSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) #tmp_DBMigration SET NewValue = (SELECT ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt


SET @tblName = 'MT_Microsoft$SystemCenter$DataWarehouse_Log'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'Post_MainDatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @DWSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt


SET @tblName = 'MT_Microsoft$SystemCenter$OpsMgrDWWatcher'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'DatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @DWSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt

SET @tblName = 'MT_Microsoft$SystemCenter$OpsMgrDWWatcher_Log'
SET @colName = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tblName AND COLUMN_NAME LIKE 'Post_DatabaseServerName_%')

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''' + @tblName + ''' AS TableName, ' + @colName + ' AS OldValue, NULL AS NewValue FROM ' + @tblName
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE TOP(1) ' + @tblName + ' SET ' + @colName + ' = ''' + @DWSQLInstance + ''''
--select @sqlstmt
exec @UseOpsMgrDB @sqlstmt

SET @sqlstmt = N'UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) ' + @colName + ' FROM ' + @tblName + ') WHERE TableName = ''' + @tblName + ''''
exec @UseOpsMgrDB @sqlstmt

--USE OperationsManager

SET @sqlstmt = N'INSERT INTO #tmp_DBMigration SELECT TOP(1) ''GlobalSettings'' AS TableName, SettingValue AS OldValue, NULL AS NewValue FROM GlobalSettings WHERE ManagedTypePropertyId IN (select ManagedTypePropertyId from [dbo].[ManagedTypeProperty] where [ManagedTypePropertyName] like ''MainDatabaseServerName'')
UPDATE TOP(1) GlobalSettings SET SettingValue = ''' + @DWSQLInstance + ''' WHERE ManagedTypePropertyId IN (select ManagedTypePropertyId from [dbo].[ManagedTypeProperty] where [ManagedTypePropertyName] like ''MainDatabaseServerName'')
UPDATE #tmp_DBMigration SET NewValue = (SELECT TOP(1) SettingValue FROM GlobalSettings WHERE ManagedTypePropertyId IN (select ManagedTypePropertyId from [dbo].[ManagedTypeProperty] where [ManagedTypePropertyName] like ''MainDatabaseServerName'')) WHERE TableName = ''GlobalSettings'''

exec @UseOpsMgrDB @sqlstmt

select * from #tmp_DBMigration
drop table #tmp_DBMigration