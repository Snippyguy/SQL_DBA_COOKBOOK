# 📊 SQL Server Scoped Configurations Collector

### Stored Procedure: `sp_get_dbconfiguration_all_dbs`

> 🔧 Instantly audit **all database-scoped configurations** across your SQL Server instance — the right way.

---

## 🚀 What It Does

This stored procedure gathers scoped configuration settings from **all databases (except tempdb)** in a SQL Server 2016+ instance and stores the results in a **global temporary table**.

💡 Use this to:
- Compare configuration settings across databases
- Detect anomalies or misconfigurations
- Snapshot settings for audits or documentation

---

## 📂 Output Structure

The procedure returns the following columns:

| Column Name          | Description                                                    |
|----------------------|----------------------------------------------------------------|
| `snapdate`           | Timestamp when the snapshot was taken                          |
| `srv`                | Server machine name                                            |
| `sv`                 | SQL Server instance name (`@@SERVICENAME`)                     |
| `dbname`             | Name of the database                                           |
| `configuration_id`   | Internal ID for the configuration                              |
| `configuration_name` | Name of the database-scoped configuration (e.g., MAXDOP)       |
| `configuration_value`| Value currently set for that configuration                     |

---

## 🛠️ How It Works

1. Drops the global temp table `##DBCONFIG_ALLDB` if it already exists.
2. Creates a fresh `##DBCONFIG_ALLDB` to hold the results.
3. Iterates through each database using `sp_MSforeachdb`.
4. For each database (except tempdb), collects records from `sys.database_scoped_configurations`.
5. Appends all results into the global temp table.
6. Returns the full dataset.

---

## 🧪 Example Output

| snapdate            | srv       | sv          | dbname        | configuration_name            | configuration_value |
|---------------------|-----------|-------------|----------------|-------------------------------|---------------------|
| 2025-07-29 12:01:00 | SQL01     | MSSQLSERVER | AdventureWorks | MAXDOP                        | 4                   |
| 2025-07-29 12:01:00 | SQL01     | MSSQLSERVER | MyAppDB        | LEGACY_CARDINALITY_ESTIMATION | 1                   |

---

## ⚙️ Requirements

- SQL Server **2016 or newer**
- Appropriate privileges to run dynamic SQL across all databases

---

## 🧼 Best Practices

- Run this procedure during off-peak hours if you have a large number of databases.
- Store or export the results periodically for configuration drift analysis.
- Combine this with other inventory scripts for full environment visibility.

---

## 📤 Sample Usage

```sql
USE DBATOOLS;
EXEC dbo.sp_get_dbconfiguration_all_dbs;

