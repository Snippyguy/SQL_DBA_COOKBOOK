# 🧠 sp_WhoIsActive – The Ultimate SQL Server Activity Monitor

**sp_WhoIsActive** is a comprehensive and flexible stored procedure designed for SQL Server professionals to identify and diagnose performance issues in real-time. Developed by [Adam Machanic](http://whoisactive.com/), this tool gives deep insight into current SQL activity — far beyond what `sp_who` and `sp_who2` provide.

Whether you're hunting down blocking chains, runaway queries, or CPU hogs — this is your Swiss Army knife.

---

## 📦 Features

- Monitor live activity on SQL Server with rich detail
- Identify blocking sessions and locks
- View current running queries, wait types, CPU, and I/O stats
- Capture query plans, SQL text, and login/session info
- Customizable output with dozens of optional parameters
- Works on SQL Server 2005–2022+

---

## 🛠 Installation

Download the latest version from the [official GitHub repo](https://github.com/amachanic/sp_whoisactive) or run:

```sql
-- Run the script in the target database (typically master or a DBA utility DB)
USE master;
GO
-- Paste and execute the sp_WhoIsActive.sql script here
