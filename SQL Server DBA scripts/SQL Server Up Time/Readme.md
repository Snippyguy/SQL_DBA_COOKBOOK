# 📊 Check SQL Server Instance Uptime

This project explains different ways to **check SQL Server instance uptime** using built-in dashboards, Windows Event Viewer, and SQL Server error logs.  

## 🔹 SQL Server Monitoring Dashboard

We can view the **SQL Server instance uptime** from the SQL Server monitoring dashboard.  
It’s a built-in report used to monitor the **real-time performance** of SQL Server instances and databases.  

**Steps:**
1. Right-click on the SQL Server connection  
2. Hover on **Reports** → **Standard Reports**  
3. Click on **Server Dashboard**

### 🖼️ Open Server Dashboard
In the Server Dashboard report, you can view details of the SQL Server instance.  
The **uptime** is shown in the **Server Startup Time** field of the **Configuration Details** grid.  
Format → `HH:MM AM/PM`

![Server Dashboard](https://www.sqlshack.com/wp-content/uploads/2020/05/sql-server-uptime-server-dashboard.jpg)

## 🔹 Windows Event Viewer

We can also view uptime using the **Windows Event Viewer**.  

**Steps:**
1. Open **Control Panel** → **Administrative Tools** → **Event Viewer**  
2. In the Event Viewer MMC, expand **Windows Logs** → **Application**  
3. Filter the log by **Event ID 17162**  
4. Look for source = **MSSQLSERVER**, Level = **Information**

![Event Viewer](https://www.sqlshack.com/wp-content/uploads/2020/05/sql-server-uptime-event-viewer.jpg)


## 🔹 SQL Server Error Log

When SQL Server restarts, the system stored procedure **`sp_cycle_errorlog`** creates a new error log file that contains startup information.  

Although not exact, it gives the **closest uptime details**.  

**Steps in SSMS:**
1. Open SSMS and connect to the SQL Server instance  
2. Expand **SQL Server Agent** → **Error Logs**  
3. Click on **Current**  

![SQL Server Error Log](https://www.sqlshack.com/wp-content/uploads/2020/05/sql-server-uptime-error-log.jpg)

## 🔹 Querying the Error Log

Alternatively, use the stored procedure **`xp_readerrorlog`** to extract startup details:

```sql
USE master;
GO
EXEC xp_ReadErrorLog 0, 1, N'SQL', N'Starting';
