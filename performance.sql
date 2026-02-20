SELECT 'kill ' + cast(r.session_id as varchar(20))as spid,s.host_name,
s.login_name,  
DATEDIFF(minute ,r.start_time,getdate()) time_in_min,
DATEDIFF(ss ,r.start_time,getdate()) time_in_sec,
r.percent_complete,
r.wait_type,
r.session_id as spid,
r.[status],
r.cpu_time,
r.command,
t.[text],
r.blocking_session_id as blocked,
r.start_time,
[query_plan] AS [Last Plan]
FROM sys.dm_exec_requests AS r
LEFT OUTER JOIN sys.dm_exec_sessions s ON s.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(r.[sql_handle]) AS t
cross APPLY
    sys.dm_exec_query_plan ([r].[plan_handle]) AS [s_eqp]
WHERE r.session_id <> @@SPID AND r.session_id > 50
--and s.login_name not  like '%\%'
ORDER BY 5 desc
