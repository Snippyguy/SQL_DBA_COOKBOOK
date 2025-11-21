--TCP Port Check
SELECT 
		net_transport,
		local_net_address,
		local_tcp_port,
		protocol_type
FROM sys.dm_exec_connections