<div align="center">

<img src="Image/Snippyguy%20Logo%20copy%202.png" alt="SnippyGuy" width="500"/>

# 🗄️ SQL Server Backup & Restore Toolkit

### *Your one-stop arsenal for backup, restore, PITR & disaster recovery scripts*

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=for-the-badge&logo=databricks&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![DBA](https://img.shields.io/badge/Made%20by-Happy%20DBA-FF4500?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=for-the-badge)

**Because every DBA deserves a good night's sleep 😴🔒**

</div>

# 🗄️ SQL Server Backup & Restore Toolkit

> **A practical collection of SQL Server backup, restore, recovery, troubleshooting, and database protection scripts.**

Welcome to the **SQL Server Backup & Restore Toolkit** — a collection of reusable **T-SQL scripts, troubleshooting queries, and DBA utilities** designed to make SQL Server backup and restore operations easier, faster, and more reliable.

This repository focuses not only on taking backups, but also on the **complete backup → restore → recovery lifecycle**, including **Point-in-Time Recovery (PITR)**, backup validation, restore troubleshooting, split backups, recovery-chain analysis, and identifying common backup/restore issues.
This folder is a curated collection of **SQL Server backup and restore scripts**, built to help DBAs handle everything from routine full backups to nail-biting **point-in-time recovery (PITR)** scenarios. Whether you're troubleshooting a broken restore chain at 3 AM or setting up a clean backup strategy from scratch, you'll find something here to save the day.

> 💡 **Goal:** Reduce panic, increase confidence, and make backup/restore operations boring (in the best way possible).

> 📁 Browse each subfolder for ready-to-run `.sql` and `.ps1` scripts with inline comments.
---

## 🎯 What This Repository Covers

This folder contains scripts related to:

* Full Database Backup
* Differential Database Backup
* Transaction Log Backup
* Copy-Only Backup
* Partial / Filegroup Backup
* Split Backup
* Compressed Backup
* Encrypted Backup
* Backup Verification
* Backup History & Reporting
* Restore Database
* Restore with `WITH MOVE`
* Restore File List
* Point-in-Time Recovery
* Tail-Log Backup
* Recovery Chain Validation
* Database Recovery Troubleshooting
* Backup Failure Investigation
* Restore Failure Investigation
* Orphaned / Missing Backup Identification
* Log Chain Analysis
* Backup Duration & Performance Analysis
* Backup Size Analysis
* Backup Device / Media troubleshooting
* SQL Server Agent backup-job troubleshooting
* Recovery Status Monitoring
* Disaster Recovery scenarios
* Production recovery utilities

---

# 📚 Backup Types

## 1. Full Backup

A **Full Database Backup** contains the complete database required to restore the database to the point at which the backup completed.

Typical use:

```sql
BACKUP DATABASE [DatabaseName]
TO DISK = 'D:\SQLBackup\DatabaseName_FULL.bak'
WITH
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
```

---

## 2. Differential Backup

A differential backup contains changes made since the most recent full backup.

Typical strategy:

```text
FULL
 ├── DIFF
 ├── DIFF
 ├── DIFF
 └── DIFF
```

Restore normally requires:

```text
FULL → Latest DIFF
```

---

## 3. Transaction Log Backup

Transaction log backups are required for **Point-in-Time Recovery** when using the Full or Bulk-Logged recovery model.

Example:

```sql
BACKUP LOG [DatabaseName]
TO DISK = 'D:\SQLBackup\DatabaseName_LOG.trn'
WITH
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
```

Typical log chain:

```text
FULL
  ↓
LOG
  ↓
LOG
  ↓
LOG
  ↓
LOG
```

A broken log chain can prevent successful Point-in-Time Recovery.

---

# 🔄 Point-in-Time Recovery

One of the most important capabilities covered by this repository is **Point-in-Time Recovery (PITR)**.

Example scenario:

> Someone accidentally deleted important data at `10:42:15 AM`.

The objective is to restore the database to:

```text
10:42:14 AM
```

Typical recovery sequence:

```text
1. Tail-Log Backup
        ↓
2. Restore FULL Backup
        ↓
3. Restore Latest Differential Backup
        ↓
4. Restore Transaction Log Backups
        ↓
5. STOPAT
        ↓
6. WITH RECOVERY
```

Example:

```sql
RESTORE DATABASE [DatabaseName]
FROM DISK = 'D:\SQLBackup\DatabaseName_FULL.bak'
WITH
    NORECOVERY,
    REPLACE,
    STATS = 10;
```

Then restore the required differential backup:

```sql
RESTORE DATABASE [DatabaseName]
FROM DISK = 'D:\SQLBackup\DatabaseName_DIFF.bak'
WITH
    NORECOVERY,
    STATS = 10;
```

Finally, restore the transaction log:

```sql
RESTORE LOG [DatabaseName]
FROM DISK = 'D:\SQLBackup\DatabaseName_LOG.trn'
WITH
    STOPAT = '2026-09-01T10:42:14',
    RECOVERY,
    STATS = 10;
```

> ⚠️ **Important:** Always identify the correct backup chain before performing a production Point-in-Time Recovery.

---

# 🧩 Split Backup

Large databases can generate very large backup files.

Instead of writing one huge backup file, the backup can be split across multiple backup devices/files.

Example:

```sql
BACKUP DATABASE [DatabaseName]
TO
    DISK = 'D:\SQLBackup\DatabaseName_01.bak',
    DISK = 'E:\SQLBackup\DatabaseName_02.bak',
    DISK = 'F:\SQLBackup\DatabaseName_03.bak'
WITH
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
```

Advantages:

* Parallel I/O
* Faster backup in suitable environments
* Distribution across multiple disks
* Reduced pressure on a single storage device
* Useful for very large databases

Restore using **all backup pieces**:

```sql
RESTORE DATABASE [DatabaseName]
FROM
    DISK = 'D:\SQLBackup\DatabaseName_01.bak',
    DISK = 'E:\SQLBackup\DatabaseName_02.bak',
    DISK = 'F:\SQLBackup\DatabaseName_03.bak'
WITH
    RECOVERY,
    STATS = 10;
```

---

# 📦 Copy-Only Backup

Copy-only backups are useful when you need an independent backup without affecting the normal backup sequence.

Example:

```sql
BACKUP DATABASE [DatabaseName]
TO DISK = 'D:\SQLBackup\DatabaseName_COPYONLY.bak'
WITH
    COPY_ONLY,
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
```

Useful for:

* Development refresh
* Testing
* Migration
* Ad-hoc backup requirements
* Creating a backup for another team without disturbing the regular backup strategy

---

# 🔐 Backup Encryption

For environments where backup protection is required, encrypted backups can be created using SQL Server backup encryption.

Example:

```sql
BACKUP DATABASE [DatabaseName]
TO DISK = 'D:\SQLBackup\DatabaseName_ENCRYPTED.bak'
WITH
    COMPRESSION,
    ENCRYPTION
    (
        ALGORITHM = AES_256,
        SERVER CERTIFICATE = [BackupCertificate]
    ),
    CHECKSUM,
    STATS = 10;
```

> 🔑 **Important:** The certificate/asymmetric key used for backup encryption must be preserved. Losing the encryption key material can make the backup impossible to restore.

---

# 🧪 Backup Validation

Taking a backup successfully does **not** automatically mean that the backup is usable.

Use:

```sql
RESTORE VERIFYONLY
FROM DISK = 'D:\SQLBackup\DatabaseName_FULL.bak'
WITH CHECKSUM;
```

For critical environments, the strongest validation is a **test restore**.

Recommended approach:

```text
Backup
  ↓
VERIFYONLY
  ↓
Test Restore
  ↓
DBCC CHECKDB
  ↓
Application Validation
```

---

# 🔍 Backup History & Investigation

Scripts in this repository can be used to investigate:

* When was the last full backup?
* When was the last differential backup?
* When was the last log backup?
* How large was the backup?
* How long did it take?
* Which backup device was used?
* Was the backup successful?
* What is the backup chain?
* Is a log backup missing?
* Which backup should be restored?

Useful system tables/views include:

```text
msdb.dbo.backupset
msdb.dbo.backupmediafamily
msdb.dbo.backupmediaset
msdb.dbo.backupfile
```

---

# 🚨 Backup Failure Troubleshooting

The scripts can help investigate common errors such as:

```text
Backup failed
Operating system error
Access is denied
Cannot open backup device
Disk full
Insufficient disk space
Backup timeout
Network path unavailable
Backup checksum error
Media family error
Backup chain broken
Transaction log backup failed
SQL Server Agent job failure
```

Recommended investigation flow:

```text
Backup Job Failed
       ↓
Check SQL Agent Job History
       ↓
Check SQL Server Error Log
       ↓
Check Backup History
       ↓
Check Backup Destination
       ↓
Check Disk Space
       ↓
Check SQL Server Service Account
       ↓
Check Permissions
       ↓
Check Network Connectivity
       ↓
Validate Backup
```

---

# ♻️ Restore Troubleshooting

Common restore scenarios covered by the scripts include:

### Database stuck in RESTORING

```sql
SELECT
    name,
    state_desc,
    recovery_model_desc
FROM sys.databases
WHERE name = 'DatabaseName';
```

### Restore history

```sql
SELECT *
FROM msdb.dbo.restorehistory
ORDER BY restore_date DESC;
```

### Restore file information

```sql
RESTORE FILELISTONLY
FROM DISK = 'D:\SQLBackup\DatabaseName_FULL.bak';
```

This is particularly useful before using:

```sql
WITH MOVE
```

---

# 🛠️ Restore WITH MOVE

Useful when restoring a database to a different server or different drive structure.

Example:

```sql
RESTORE DATABASE [DatabaseName]
FROM DISK = 'D:\SQLBackup\DatabaseName_FULL.bak'
WITH
    MOVE 'DatabaseName'
        TO 'E:\SQLData\DatabaseName.mdf',

    MOVE 'DatabaseName_log'
        TO 'F:\SQLLog\DatabaseName_log.ldf',

    RECOVERY,
    STATS = 10;
```

---

# 🧯 Tail-Log Backup

When a database failure occurs and the goal is to minimize data loss, a **tail-log backup** may be required before restoring.

Example:

```sql
BACKUP LOG [DatabaseName]
TO DISK = 'D:\SQLBackup\DatabaseName_TAIL.trn'
WITH
    NORECOVERY,
    CHECKSUM,
    STATS = 10;
```

This can be an important step during disaster recovery and Point-in-Time Recovery.

---

# 🧠 Recovery Chain Concept

Understanding the backup chain is critical for every SQL Server DBA.

```text
              FULL
               │
        ┌──────┴──────┐
        │             │
       DIFF           LOG
                      │
             ┌────────┼────────┐
             │        │        │
            LOG      LOG      LOG
```

The restore process must follow the correct sequence.

For example:

```text
FULL
 ↓
LATEST VALID DIFF
 ↓
LOG 1
 ↓
LOG 2
 ↓
LOG 3
 ↓
STOPAT
 ↓
RECOVERY
```

---

# 📊 Useful DBA Checks

This repository also contains scripts for identifying:

* Last successful backup
* Databases without recent backups
* Backup age
* Backup frequency
* Backup size
* Backup duration
* Failed backup jobs
* Missing transaction log backups
* Recovery model
* Database state
* Backup destination
* Backup compression
* Backup encryption
* Backup chain information
* Restore history
* Recovery progress

---

# ⚠️ Production Safety

These scripts are intended to **assist DBAs**, not replace proper recovery planning.

Before executing a restore in production:

* Confirm the correct database.
* Confirm the recovery objective.
* Confirm the required restore point.
* Validate the backup chain.
* Confirm sufficient disk space.
* Confirm backup files are accessible.
* Check `RESTORE HEADERONLY`.
* Check `RESTORE FILELISTONLY`.
* Verify the backup where appropriate.
* Confirm whether `WITH RECOVERY` should be used.
* Obtain required change/incident approval.
* Record the exact restore sequence.

### Never blindly execute a production restore script.

A single incorrect `WITH RECOVERY`, `REPLACE`, or `STOPAT` can affect the recovery outcome.

---

# 🎯 DBA Recovery Philosophy

A backup is **not a recovery strategy**.

A mature SQL Server backup strategy should answer:

```text
How much data can we afford to lose?
            ↓
RPO
            ↓
How quickly must we recover?
            ↓
RTO
            ↓
Which backup chain is required?
            ↓
Can we restore it?
            ↓
Can the application use the restored database?
            ↓
Have we tested it?
```

The ultimate goal is:

> **Backup → Validate → Restore → Verify → Recover → Document → Test Again**

---

# ⭐ Happy DBA!

Being a DBA is not just about knowing how to execute:

```sql
BACKUP DATABASE
```

or:

```sql
RESTORE DATABASE
```

A good DBA understands **why the backup exists, how the backup chain works, how recovery works, what can go wrong, and how to bring the database back when everything else has failed.**

**Keep your backups healthy.
Keep your restore scripts ready.
Test your recovery.
And always remember — a backup that has never been restored is only a hypothesis.**

### 🧑‍💻 Happy DBA! 🚀

---

## 🤖 Built with a DBA mindset

*Practical scripts • Production-focused troubleshooting • Recovery-first thinking*

![SQL Server DBA](https://img.shields.io/badge/SQL%20Server-Backup%20%26%20Restore-red?style=for-the-badge\&logo=microsoftsqlserver)

![Happy DBA](https://img.shields.io/badge/Happy-DBA-blue?style=for-the-badge)

---

<p align="center">
  <b>🛡️ Protect the data. 🔄 Test the restore. 🚀 Keep the database alive.</b>
</p>

Each issue has a **dedicated diagnostic script + fix** inside `/troubleshooting`.

---

## 🛠️ Recommended Backup Strategy

```
📅 Sunday      → FULL Backup
📅 Daily        → DIFFERENTIAL Backup
⏱️ Every 15 min → TRANSACTION LOG Backup
```

This combo enables **minimal data loss** and reliable **point-in-time recovery** for any production system.

---

## 🤝 Contributing

Found a bug? Have a script that saved your day? PRs and issues are welcome — let's build the ultimate DBA survival kit together! 🚀

---

## ⭐ Support

If this repo has ever saved you from a restore nightmare, consider giving it a ⭐ — it keeps the Happy DBA happy.

---

<div align="center">

### Crafted with ☕, T-SQL, and a little bit of panic-recovery experience

<img src="Image/Snippyguy%20Logo%20copy%202.png" alt="SnippyGuy" width="500"/>

**🩹 Happy DBA — Backing up your data, one script at a time.**

</div>
