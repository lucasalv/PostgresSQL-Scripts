DO $$
DECLARE
    index_record RECORD;
    sql_state TEXT;
BEGIN
    FOR index_record IN
        SELECT schemaname, relname, indexrelname
        FROM pg_stat_all_indexes
        where schemaname = 'public' 
    LOOP
        BEGIN
            EXECUTE format('DROP INDEX IF EXISTS %I.%I;', index_record.schemaname, index_record.indexrelname);
            RAISE NOTICE 'Índice % excluído.', index_record.indexrelname;
        EXCEPTION
            WHEN others THEN
                GET STACKED DIAGNOSTICS sql_state = RETURNED_SQLSTATE;
                RAISE NOTICE 'Não foi possível excluir o índice % (SQLSTATE: %).', index_record.indexrelname, sql_state;
        END;
    END LOOP;
END $$;