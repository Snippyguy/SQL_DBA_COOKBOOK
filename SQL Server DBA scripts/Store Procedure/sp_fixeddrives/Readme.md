# 📊 sp\_fixeddrives: Enhanced Disk Monitoring for SQL Server

> ⚙️ *An advanced alternative to `xp_fixeddrives` with full disk, mount point, and SQL Server database context.*

## 📌 Overview

Managing disk space efficiently is critical in SQL Server environments, especially when SAN storage is involved or mount points are in use. While `xp_fixeddrives` gives a quick view of free space, it lacks critical details like:

* Total disk size
* Volume labels
* Mount point data
* Associated SQL Server databases and recovery modes

To bridge this gap, **`sp_fixeddrives`** was developed by **Kun Lee**, a drop-in replacement stored procedure that brings complete visibility into your SQL Server disk usage — including volumes, mount points, and database details.

## 🚀 Features

✅ Total disk size and free space (in MB)
✅ Volume name / labels
✅ Mount point awareness
✅ Database-to-volume mapping
✅ Database recovery model view
✅ Easy-to-use format similar to `xp_fixeddrives`
✅ SQL mode and DB mode switch via parameters

## 🏗 Requirements/ pre-requisites

* **SQL Server** (tested on Windows Server 2003 and later)
* `xp_cmdshell` must be enabled
* WMI scripting support
* Permissions to execute system commands via T-SQL

## 🛠 How to Install

1. Copy the procedure code into a query window.
2. Deploy it to the `master` database:

   ```sql
   USE master;
   GO
   -- Paste sp_fixeddrives procedure code here
   ```

> 🧠 Naming Convention Tip: Just replace the `x` in `xp_fixeddrives` with `s` to run it: `sp_fixeddrives`

## 📎 Sample Output

### 🔍 `xp_fixeddrives` (Basic)

| drive | MB free |
| ----- | ------- |
| C     | 20000   |
| D     | 15000   |

### ⚡ `sp_fixeddrives` (Enhanced)

| Drive | Label | Free MB | Total MB | MountPoint | DBName | RecoveryModel |
| ----- | ----- | ------- | -------- | ---------- | ------ | ------------- |
| D     | Logs  | 15000   | 50000    | Yes        | MyDB   | FULL          |
| E     | Data  | 8000    | 25000    | Yes        | TestDB | SIMPLE        |

---

### 📦 With Database Mode

To see database details:

```sql
EXEC sp_fixeddrives 1;
```

Or use an alias:

```sql
EXEC sp_fixeddrives 'DBMode';
```

---

## 🧾 How It Works

`sp_fixeddrives` uses **WMI** via `xp_cmdshell` to gather drive information:

```sql
-- Example WMI call
EXEC xp_cmdshell 'wmic volume where drivetype="3" get caption, freespace, capacity, label'
```

If volume labels are too long (especially in older systems like Windows Server 2003), a fallback WMI command is used:

```sql
wmic logicaldisk where (drivetype="3" and volumename!="RECOVERY" AND volumename!="System Reserved") get deviceid,volumename /Format:csv
```

---

## 🧪 Tested On

* SQL Server 2005+
* Windows Server 2003, 2008, 2012, and later

---

## 🤝 Contributors

* **Kun Lee** – Original Author
* **Vara Thelu** – WMI improvement for volume label bug

---

## 📁 License

Open Source – Feel free to modify and use in your environment.

---

## 🔗 Resources

* [Original Article (2013)]([https://www.mssqltips.com/sqlservertip/XXXX/enhanced-xp-fixeddrives-in-sql-server/](https://www.mssqltips.com/sqlservertip/3037/getting-more-details-with-an-enhanced-xpfixeddrives-for-sql-server/))
* Microsoft Docs – [xp\_cmdshell](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/xp-cmdshell-transact-sql)

---

💡 *Improve your DBA productivity and gain deeper visibility into SQL Server disk usage with `sp_fixeddrives`!*
