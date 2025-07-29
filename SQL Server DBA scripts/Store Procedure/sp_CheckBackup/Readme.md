# sp_CheckBackup

Hello, and welcome to the GitHub repository for **sp_CheckBackup**!  
This is a free tool from **Straight Path Solutions** for SQL Server Database Administrators (or people who play DBA at their organization) to use for detecting **recoverability vulnerabilities and discrepancies** in their SQL Server instances.

---

## Why would you use sp_CheckBackup?

Here at Straight Path Solutions, we're big fans of community tools like:

- `sp_WhoIsActive`
- Brent Ozar's First Responder's Kit
- Erik Darling's suite of helpful stored procedures

As database administrators who are constantly looking at new clients and new servers, we wished there was a tool to quickly give an overview of potential recoverability issues.  
We didn't find one, so we made one.

---

## What does sp_CheckBackup do?

This tool allows you to **review your SQL Server backup history** quickly and easily, and also identify potential issues like:

- Missing backups
- Failed backups
- Split backup chains

It includes several modes depending on what you want to examine:

### Mode 0: A check for problems like…

- Backup compression configuration disabled  
- Backup checksum configuration disabled  
- Backups made without using checksum  
- Databases missing full or log backups  
- Databases that haven’t had any full backups in over a week  
- Databases that haven’t had any log backups in over an hour  
- Split backup chains that could complicate recoverability  
- TDE certificates that haven’t been backed up recently  
- TDE certificates that have expired  
- Databases backup certificates that haven’t been backed up recently  
- Databases backup certificates that have expired  
- Recent failed backups  

---

### Mode 1: A summary of backups for all databases including…

- Current recovery model  
- Minutes since last backup (Recovery point)  
- Last full/diff/log backup start, finish, and duration  
- Number of files and size  
- Backup type (Disk, Virtual disk, etc.) and location  

---

### Mode 2: A detailed look at every backup file including…

- Copy-only or snapshot backup flags  
- Password protection status  
- Checksum usage  
- Physical device name  
- User name used for backup  
- Availability group name (if applicable)  

---

### Mode 3: A check for split backups that could complicate recovery

- Backup type  
- Number of different file paths used  
- Actual backup file paths  

---

### Mode 4: A check that returns results from Modes 1–3  

---

### Mode 5: A check for restores  

---

## How do I use it?

Execute the script to create `sp_CheckBackup` in the database of your choice.  
We recommend placing it in the `master` database to run it easily from anywhere.

By default, it returns two result sets:

- Results of **Mode 1**, ordered by database name  
- Results of **Mode 0**, ordered by Importance  

You can customize it with these parameters:

- `@Help` – Set to `1` for usage instructions  
- `@Mode` – Choose your desired mode (0–5)  
- `@ShowCopyOnly` – `1` includes copy-only backups (default), `0` excludes  
- `@DatabaseName` – Limit results to one specific database  
- `@BackupType` – Filter by `F` (full), `D` (diff), `T` (log)  
- `@StartDate` / `@EndDate` – Filter results to a specific backup date range  
- `@RPO` – Check compliance with your Recovery Point Objective  
- `@Override` – Allow execution on servers with 50+ databases  

---

## Importance levels in Mode 0

- **1 – High**  
  Prevents recoverability (e.g., missing backups, expired certs)  
- **2 – Medium**  
  Could complicate recovery (e.g., split chains, no checksum)  
- **3 – Low**  
  Could affect backup/restore performance (e.g., compression disabled)  

---

## Requirements

1. **VIEW SERVER STATE** permissions – required to access relevant DMVs  
2. **SQL Server 2014 or higher** – earlier versions will skip some checks  

---

## 🔗 Related

Visit [Straight Path Solutions on GitHub](https://github.com/Straight-Path-Solutions)  
for more free SQL Server tools and community contributions.
