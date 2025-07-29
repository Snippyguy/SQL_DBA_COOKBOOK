<p align="center">
  <img src="https://img.shields.io/badge/SQL%20Server-Security%20Tool-blue?style=for-the-badge&logo=microsoftsqlserver&logoColor=white" alt="SQL Server Security Tool Badge" />
  <img src="https://img.shields.io/github/stars/Straight-Path-Solutions/sp_CheckSecurity?style=for-the-badge" alt="GitHub stars" />
</p>

<h1 align="center">🛡️ sp_CheckSecurity</h1>

<p align="center">A free and powerful SQL Server security checklist tool built by DBAs, for DBAs.</p>

---

## 🔍 About

Welcome to **sp_CheckSecurity** — a free stored procedure from [Straight Path Solutions](https://github.com/Straight-Path-Solutions), designed to help SQL Server Database Administrators (or those who find themselves acting as DBAs) detect **security vulnerabilities**, **misconfigurations**, and **permissions issues** across SQL Server instances.

---

## 💡 Why Use sp_CheckSecurity?

At Straight Path Solutions, we live and breathe SQL Server. Inspired by community favorites like:
- `sp_WhoIsActive`
- Brent Ozar’s First Responder Kit
- Erik Darling’s helper procedures

We built **sp_CheckSecurity** to quickly give you a bird's-eye view of your SQL Server security posture — because when it comes to vulnerabilities, you want to find them *before* someone else does.

---

## 🛠️ What It Checks

### 🔐 Instance Info
- Encrypted/Unencrypted databases
- Communication protocol
- Dedicated admin connections
- SQL Server edition/version
- Security updates and service accounts

### 👥 Logins & Permissions
- `sysadmin`, `securityadmin` role members
- `CONTROL SERVER` permissions
- Enabled `sa` account
- Invalid Windows logins
- Local Admin Group members
- Password vulnerabilities

### ⚙️ Instance Settings
- `xp_cmdshell`, `CLR`, ownership chaining
- SQL Agent job ownership
- Login audits
- TDE and backup certificate status

### 📂 Database Permissions
- Orphaned users
- TRUSTWORTHY settings
- Public role grants
- db_owner members
- Nested roles
- Unusual/granted permissions

---

## 📊 Result Set Example

After running the procedure, you'll get a result set with:
- ⚠️ **Vulnerability Level (0-4)**
- 📌 What was found
- ❓ Why it's an issue
- ✅ Recommended fix
- 🔗 Helpful link

---

## 🧪 Parameters

| Parameter             | Description |
|-----------------------|-------------|
| `@help`               | Returns usage instructions (`1` for help) |
| `@ShowHighOnly`       | Only return critical/high results (`1`) |
| `@PreferredDBOwner`   | Your preferred DB owner (default: `sa`) |
| `@CheckLocalAdmin`    | Check members of BUILTIN\Administrators group (use with caution) |

⚠️ **Warning**: Enabling `@CheckLocalAdmin = 1` will temporarily add and roll back the BUILTIN\Administrators group to collect data. Triggers or audits on login changes may be affected. Use responsibly.

---

## 🧠 Vulnerability Levels

| Level | Meaning |
|-------|---------|
| `0`   | ℹ️ Informational only |
| `1`   | 🚨 High – Immediate action needed |
| `2`   | ⚠️ High – Review and likely act |
| `3`   | ⚖️ Medium – Review for correctness |
| `4`   | 🧹 Low – Clean up inconsistencies |

---

## 🧾 Requirements

- ✅ Must be executed by a member of the `sysadmin` role  
- ✅ SQL Server 2012 or later  

---

## 🚀 How To Use

```sql
-- Run this once in the master database:
EXEC sp_CheckSecurity;

-- Want help?
EXEC sp_CheckSecurity @help = 1;

-- Critical only:
EXEC sp_CheckSecurity @ShowHighOnly = 1;
