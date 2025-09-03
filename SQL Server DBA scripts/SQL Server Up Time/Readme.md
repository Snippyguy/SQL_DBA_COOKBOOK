# 📊 Check SQL Server Instance Uptime

This guide walks you through different methods to **check SQL Server instance uptime**—via the built-in dashboard, Windows Event Viewer, and error logs.

##  Method 1: SQL Server Monitoring Dashboard

You can quickly view the **SQL Server instance uptime** using the built-in Server Dashboard report:

**Steps:**
1. Right-click on your SQL Server connection in SSMS  
2. Hover over **Reports → Standard Reports**  
3. Select **Server Dashboard**

In the **Configuration Details** grid, the **Server Startup Time** displays instance uptime in `HH:MM AM/PM` format.

![Glimpse of Server dashboard](
https://www.sqlshack.com/wp-content/uploads/2020/05/sql-server-uptime-server-dashboard.jpg
)  
*Example showing startup time: 12:10 AM.*

##  Method 2: Windows Event Viewer

You can also trace startup time through the **Windows Event Viewer**:

**Steps:**
1. Open **Control Panel → Administrative Tools → Event Viewer**  
2. Expand **Windows Logs → Application**  
3. Click **Filter Current Log…**  
4. Filter by **Event ID**: `17162`, All levels  
5. Locate the event with:
   - **Source**: `MSSQLSERVER`
   - **Level**: `Information`  

The details pane reveals the SQL Server instance uptime.

![Event Viewer](
https://www.sqlshack.com/wp-content/uploads/2020/05/sql-server-uptime-event-viewer.jpg
)

##  Method 3: SQL Server Error Log

When SQL Server restarts, the `sp_cycle_errorlog` procedure rotates logs and captures startup details—not perfectly accurate, but close enough.

**Viewing via SSMS:**
1. Open SSMS and connect to your SQL Server instance  
2. Expand **SQL Server Agent → Error Logs → Current**

![View current error log](
https://www.sqlshack.com/wp-content/uploads/2020/05/sql-server-uptime-error-log.jpg
)

##  Method 4: Querying the Error Log (via `xp_readerrorlog`)

To extract startup time programmatically:

```sql
USE master;
GO
EXEC xp_ReadErrorLog 0, 1, N'SQL', N'Starting';
