DO $$
DECLARE
    index_record RECORD;
    sql_state TEXT;
    index_sql text;
BEGIN
    FOR index_record IN
        SELECT schemaname, relname, indexrelname,idx_scan,idx_tup_read,idx_tup_fetch  
         FROM pg_stat_all_indexes
	   where schemaname = 'public' 
	     and idx_scan = 0
	     and indexrelname like '%idx_%' 
    loop
        index_sql := format('DROP INDEX IF EXISTS %I.%I;', index_record.schemaname, index_record.indexrelname);
        RAISE NOTICE '%', index_sql;
    END LOOP;
END $$;
