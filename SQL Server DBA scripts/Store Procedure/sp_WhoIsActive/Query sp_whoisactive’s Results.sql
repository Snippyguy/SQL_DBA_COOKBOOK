_/*************************************************************************
Code Description: How to Query sp_whoisactive’s Results
Author			: Brent Ozar
Link			: https://www.brentozar.com/responder/log-sp_whoisactive-to-a-table/

This is just a starter query. I generally am looking at a specific time period based on a complaint from a user that queries were running slow earlier in the day. 
I once used the WhoIsActive logging table to identify who was causing tempdb to grow absurdly big. 
By the time I got to it, tempdb was 500GB in size! 
I switched my query to include tempdb_allocations and tempdb_current plus ORDER BY tempdb_allocations DESC, and it was immediately clear a business user was querying ALL.THE.THINGS.

sp_WhoIsActive Documentation Link: http://whoisactive.com/docs/
 **************************************************************************/

 SELECT TOP 
			1000 CPU, 
			reads, 
			collection_time, 
			start_time, [dd hh:mm:ss.mss] AS 'run duration', 
			[program_name], 
			login_name, 
			database_name, 
			session_id, 
			blocking_session_id, 
			wait_info, sql_text, *
FROM WhoIsActive
WHERE collection_time BETWEEN '2016-07-20 07:55:00.000' AND '2016-07-20 09:00:00.000'
AND login_name NOT IN ('DomainName\sqlservice')
--AND CAST(sql_text AS varchar(max)) LIKE '%some query%'
ORDER BY 1 DESC