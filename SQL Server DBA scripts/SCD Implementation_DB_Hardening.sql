--SCD Implementation:
--SCD points enable or disable status check: Value should be 0 except clr strict security

SELECT * FROM sys.configurations 
WHERE name IN ('Ad Hoc Distributed Queries', 
			   'CLR Enabled', 
			   'Cross DB Ownership Chaining', 
			   'Database Mail XPs', 
			   'Ole Automation Procedures', 
			   'Remote Access', 
			   'Remote Admin Connections', 
			   'Scan For Startup Procs', 
			   'clr strict security', 
			   'xp_cmdshell')

--disable or configure value to 0
exec sp_configure N'xp_cmdshell', N'O'
reconfigure with override

exec sp_configure N'Ad Hoc Distributed Queries', N'O'
reconfigure with override

exec sp_configure N'CLR Enabled', N'O'
reconfigure with override

exec sp_configure N'Cross DB Ownership Chaining', N'O'
reconfigure with override

exec sp_configure N'Database Mail XPs', N'O'
reconfigure with override

exec sp_configure N'Ole Automation Procedures', N'O'
reconfigure with override

exec sp_configure N'Remote Access', N'O'
reconfigure with override

exec sp_configure N'Remote Admin Connections', N'O'
reconfigure with override

exec sp_configure N'Scan For Startup Procs', N'O'
reconfigure with override