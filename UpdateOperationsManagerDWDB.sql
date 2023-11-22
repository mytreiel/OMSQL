------------------------------------------------------
-- Change Variables Below
------------------------------------------------------

-- Operations Manager DW DB Info
DECLARE @DWSQLInstance nvarchar(50) = '$NewDWServerName'
DECLARE @DWDBName nvarchar(50) = '$OldSQLDatabase'

------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE
------------------------------------------------------
DECLARE @UseDWDB nvarchar(50) = QUOTENAME(@DWDBName) + N'.sys.sp_executesql'
DECLARE @tblName varchar(100)
DECLARE @colName varchar(100)
DECLARE @sqlstmt nvarchar(1000)

BEGIN TRY;
IF (EXISTS (SELECT * 
                 FROM tempdb.INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND TABLE_NAME LIKE '#tmp_DBMigrationDW%'))
BEGIN
drop table #tmp_DBMigrationDW
END
END TRY
BEGIN CATCH
END CATCH
CREATE TABLE #tmp_DBMigrationDW
(
	TableName varchar(100),
	OldValue varchar(50),
	NewValue varchar(50)
)

BEGIN TRY
TRUNCATE TABLE #tmp_DBMigrationDW
END TRY
BEGIN CATCH
END CATCH

--USE OperationsManagerDW

SET @sqlstmt = N'INSERT INTO #tmp_DBMigrationDW SELECT TOP(1) ''MemberDatabase'' AS TableName, ServerName AS OldValue, NULL AS NewValue FROM MemberDatabase;
UPDATE TOP(1) dbo.MemberDatabase SET ServerName = ''' + @DWSQLInstance + '''; UPDATE #tmp_DBMigrationDW SET NewValue = (SELECT TOP(1) ServerName FROM MemberDatabase) WHERE TableName = ''MemberDatabase'''

exec @UseDWDB @sqlstmt

select * from #tmp_DBMigrationDW
drop table #tmp_DBMigrationDW