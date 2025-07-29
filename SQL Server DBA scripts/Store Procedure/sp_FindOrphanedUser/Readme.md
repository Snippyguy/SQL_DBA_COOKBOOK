# 🧙‍♂️ sp_FindOrphanedUser — Discover & Fix Orphaned SQL Users

`sp_FindOrphanedUser` is a **SQL Server stored procedure** designed to detect and optionally help fix orphaned database users across your entire SQL Server instance — either **per-database** or **server-wide**.

> 🧠 Orphaned users are database users that **do not have an associated login** at the server level. These can break access and create security management issues. This procedure helps you **detect, document, and repair** them.

---

## 🚀 Features

✅ Supports checking a **specific database** or **all databases**  
✅ Generates actionable repair T-SQL for orphaned users  
✅ Identifies mismatched logins using `sp_change_users_login`  
✅ Handles schema authorization issues due to orphaned users  
✅ Temp table results for easy exporting  
✅ Detailed report for compliance/audit purposes

---

## 📂 Stored Procedure Syntax

```sql
EXEC sp_FindOrphanedUser @DatabaseName = '[YourDatabase]';  -- Optional
