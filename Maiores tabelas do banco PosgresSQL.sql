select t.schemaname
     , t.tablename
     , pg_size_pretty(pg_relation_size(t.schemaname || '.' || t.tablename)) as table_size
     , pg_size_pretty(pg_total_relation_size(t.schemaname || '.' || t.tablename) - pg_relation_size(t.schemaname || '.' || t.tablename)) as index_size
     , pg_size_pretty(pg_total_relation_size(t.schemaname || '.' || t.tablename)) as total_size
     , s.n_live_tup as live_tup 
  from pg_tables t
  join pg_stat_user_tables s on t.tablename = s.relname and t.schemaname = s.schemaname
 where t.schemaname = 'public'
 order by pg_total_relation_size(t.schemaname || '.' || t.tablename) desc
 limit 20;