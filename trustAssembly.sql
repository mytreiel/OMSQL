-- First Trusted Assembly
DECLARE @clrName1 nvarchar(4000) = 'Microsoft.EnterpriseManagement.Sql.DataAccessLayer'
PRINT N'Trusted Assembly: ' + CAST(@clrName1 AS nvarchar(120))
DECLARE @hash1 varbinary(64) = 0xEC312664052DE020D0F9631110AFB4DCDF14F477293E1C5DE8C42D3265F543C92FCF8BC1648FC28E9A0731B3E491BCF1D4A8EB838ED9F0B24AE19057BDDBF6EC;

-- Drop trusted assembly if exists
IF EXISTS (select * from sys.trusted_assemblies where description = @clrName1)
BEGIN
PRINT N' - Dropping Trusted Assembly'
EXEC SYS.sp_drop_trusted_assembly @hash1
END

--Add to trusted assembly
PRINT N' - Adding Trusted Assembly'
EXEC sys.sp_add_trusted_assembly @hash = @hash1,
                                 @description = @clrName1;

PRINT N' '
-- Second Trusted Assembly
DECLARE @clrName2 nvarchar(4000) = 'Microsoft.EnterpriseManagement.Sql.UserDefinedDataType'
PRINT N'Trusted Assembly: ' + CAST(@clrName2 AS nvarchar(120))
DECLARE @hash2 varbinary(64) = 0xFAC2A8ECA2BE6AD46FBB6EDFB53321240F4D98D199A5A28B4EB3BAD412BEC849B99018D9207CEA045D186CF67B8D06507EA33BFBF9A7A132DC0BB1D756F4F491;

-- Drop trusted assembly if exists
IF EXISTS (select * from sys.trusted_assemblies where description = @clrName2)
BEGIN
PRINT N' - Dropping Trusted Assembly'
EXEC SYS.sp_drop_trusted_assembly @hash2
END

--Add to trusted assembly
PRINT N' - Adding Trusted Assembly'
EXEC sys.sp_add_trusted_assembly @hash = @hash2,
                                 @description = @clrName2;
