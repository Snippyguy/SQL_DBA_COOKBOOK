
--detect database files and other files not used by SQL Server, but located in the same folders as active database files.

/*variable declaration*/
DECLARE @folders TABLE (folder NVARCHAR(512))
DECLARE @osfiles TABLE (files NVARCHAR(255),depth INT,is_file BIT)
DECLARE @result  TABLE (folder NVARCHAR(512),files NVARCHAR(255))
DECLARE @folder  NVARCHAR(512)

/*get list of folders*/
INSERT INTO @folders (folder)
SELECT 
		DISTINCT left(physical_name, 1 + len(physical_name) - charindex('\', reverse(physical_name)))
FROM sys.master_files

/*check them one by one*/
WHILE EXISTS (SELECT 1 FROM @folders)
BEGIN

/*pick a folder*/
SELECT TOP 1
		@folder = folder
FROM @folders

/*get list of files in the folder*/
INSERT INTO @osfiles (files,depth,is_file)
EXEC master.sys.xp_dirtree @folder,1,1

/*exclude system ones*/
DELETE @osfiles
WHERE files IN (
				 N'distmdl.ldf'
				,N'distmdl.mdf'
				,N'mssqlsystemresource.ldf'
				,N'mssqlsystemresource.mdf'
				,N'model_msdbdata.mdf'
				,N'model_msdblog.ldf'
				,N'model_replicatedmaster.ldf'
				,N'model_replicatedmaster.mdf'
				,N'$RECYCLE.BIN'
				,N'System Volume Information'
				)
OR files LIKE N'%.cer'

/*seek unused files*/
INSERT INTO @result (folder,files)
SELECT @folder
	   ,iif(o.is_file = 0, o.files + N' [Folder]', o.files)
FROM @osfiles o
WHERE NOT EXISTS (
					SELECT 1 
					FROM sys.master_files m
					where replace(m.physical_name, @folder, '')=o.files
				)

/*if nothing found, report it*/
IF @@ROWCOUNT = 0
INSERT INTO @result (folder,files)
VALUES (@folder,N'No unused files found.')

/*clean-up*/
DELETE @folders
WHERE folder = @folder

DELETE @osfiles

SELECT @folder = N''
END

/*report findings*/
SELECT folder [Folder]
	   ,files [Files which are probably not used by SQL]
FROM @result
ORDER BY 1,2

/*
Why might such files exist?
They could be remnants from data uploads or extracts (e.g., .csv files), dropped databases in offline or emergency states (yes, their files remain on file system after drop command),
forgotten dumps, or obsolete database files. These files simply consume disk space.
But in some cases, they represent valuable "spare" space that can be freed up when needed.

**The script uses the extended stored procedure "xp_dirtree" to list files in the relevant directories and compares them against known database files from the sys.master_files system view.**

This script has helped me recover tens or even hundreds of gigabytes of lost disk space in the past.
*/