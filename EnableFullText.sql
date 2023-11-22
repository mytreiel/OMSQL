SELECT is_fulltext_enabled FROM sys.databases WHERE name='OperationsManager'
--enable fulltext index
EXEC sp_fulltext_database 'enable'