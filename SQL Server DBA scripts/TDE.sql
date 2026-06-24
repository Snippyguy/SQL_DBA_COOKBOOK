--TDE
USE Master;
Go

CREATE MASTER KEY ENCRYPTION
BY PASSWORD='YourStrongPWD'
GO

CREATE CERTIFICATE YourCertificateName
WITH
SUBJECT='Database_Encryption', expiry_date='20290906'
GO

BACKUP CERTIFICATE YourCertificateName
TO FILE = 'D:\TDE\YourCertificateName.Cer'
WITH PRIVATE KEY (file='D:\TDE\YourCertificateName.pvk', 
ENCRYPTION BY PASSWORD='YourStrongPWD')

BACKUP MASTER KEY TO FILE = 'D:\TDE\DbMasterKey.key' ENCRYPTION BY PASSWORD = 'YourStrongPWD'

BACKUP SERVICE MASTER KEY TO FILE = 'D:\TDE\SvcMasterKey.key' ENCRYPTION BY PASSWORD = 'YourStrongPWD'

USE YourUserDBName
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE YourCertificateName;
GO

ALTER DATABASE YourUserDBName
SET ENCRYPTION ON;
GO


--copy the security certificate and private key from the mentioned server to backup-restore server.
--Go to backup-restore server or secondary server and fire the same query 
USE master;
SELECT * FROM sys.key_encryptions --to check master key exist or not

USE Master;
Go

CREATE MASTER KEY ENCRYPTION
BY PASSWORD='YourStrongPWD'
GO

SELECT * FROM sys.certificates ---if certificate key is there///do that step if certificate key already exist
DROP CERTIFICATE YourCertificateName

CREATE CERTIFICATE YourCertificateName
FROM FILE ='D:\TDE\YourCertificateName.Cer'
WITH PRIVATE KEY (file='D:\TDE\YourCertificateName.pvk', 
DECRYPTION BY PASSWORD='YourStrongPWD')


