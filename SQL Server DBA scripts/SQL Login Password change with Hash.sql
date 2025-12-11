--SQL Login Password change with Hash: It will keep the same password
--**It is not the best way**

--To find Hash for a specific SQL Login or User
SELECT name, password_hash FROM sys.sql_logins WHERE name= 'SQLLoginName'

--To keep the same password if expire
--Get the hash from above query and paste it below, select below 3 line at once after changeing loginname and hash and run three query in one go
ALTER LOGIN [SQLLoginName] WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE = [us_english], CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF
ALTER LOGIN [SQLLoginName] WITH PASSWORD = 0x0200186854729FB4DC20F242830CF826C7658197AC3F088887BC318CF9FB10346BC48490465C46087088142A7F662FBDED785769358ABCD7366FFE4F0E2E688118ACEBD4CB86 HASHED; -- Here put your hash that youu get from above select query
ALTER LOGIN [SQLLoginName] WITH DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = [us_english], CHECK_EXPIRATION = ON, CHECK_POLICY = ON