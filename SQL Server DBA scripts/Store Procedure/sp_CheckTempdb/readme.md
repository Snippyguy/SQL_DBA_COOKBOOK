<p align="center">
  <img src="https://img.shields.io/badge/SQL%20Server-tempdb%20Health%20Check-blue?style=for-the-badge&logo=microsoftsqlserver&logoColor=white" alt="SQL Server tempdb Badge" />
  <img src="https://img.shields.io/github/stars/Straight-Path-Solutions/sp_CheckTempdb?style=for-the-badge" alt="GitHub Stars" />
</p>

<h1 align="center">♨️ sp_CheckTempdb</h1>

<p align="center">Your go-to script for evaluating <strong>tempdb configuration, performance, and contention</strong> in SQL Server.</p>

---

## 🔍 What is sp_CheckTempdb?

**sp_CheckTempdb** is a free SQL Server troubleshooting tool from [Straight Path Solutions](https://github.com/Straight-Path-Solutions), created for Database Administrators or anyone managing SQL Server instances.

It provides immediate insight into:
- Misconfigured tempdb settings  
- File-level performance bottlenecks  
- Metadata/allocation contention  
- Current tempdb usage statistics  

---

## 💡 Why Use It?

Inspired by community-loved tools like:
- `sp_WhoIsActive`
- Brent Ozar’s First Responder Kit
- Erik Darling’s stored procedures

We found no reliable tool to audit and monitor tempdb quickly — so we built one ourselves.

---

## ⚙️ Modes of Operation

| Mode | Purpose |
|------|---------|
| `0`  | 🔍 **Problem Scan** – Scan for configuration and performance issues |
| `1`  | 📊 **File Summary** – Displays tempdb file configuration |
| `2`  | 📈 **Current Usage** – Shows real-time file utilization & summary |
| `3`  | 🔄 **Contention Check** – Detect metadata/allocation contention |

Running without parameters will return:
- Mode 1 (File Summary)
- Mode 0 (Problem Check)

---

## 🧪 Parameters

| Parameter            | Description |
|----------------------|-------------|
| `@Help`              | `1` to display help info |
| `@Mode`              | Choose from Mode 0 to 3 |
| `@Size`              | Display sizes in `MB` or `GB` (default: `MB`) |
| `@UsagePercent`      | Flag high usage above % (default: `50`) |
| `@AvgReadStallMs`    | Filter files with high read latency (default: `20`) |
| `@AvgWriteStallMs`   | Filter files with high write latency (default: `20`) |

---

## ⚠️ Importance Levels (Mode 0)

| Level | Meaning |
|-------|---------|
| `1`   | 🔥 High – Address ASAP for performance gain |
| `2`   | ⚠️ Medium – Review settings or trace flags |
| `3`   | 🧾 Low – Informational; just be aware |

---

## 🚀 How to Use

```sql
-- Install in master or your preferred DBA utility DB
EXEC sp_CheckTempdb;

-- See help
EXEC sp_CheckTempdb @Help = 1;

-- Run a specific mode
EXEC sp_CheckTempdb @Mode = 2;

-- Customize output
EXEC sp_CheckTempdb @Mode = 2, @Size = 'GB', @UsagePercent = 75;
