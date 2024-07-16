DO $$
DECLARE
    table_rec RECORD;
    max_id INTEGER;
BEGIN
    -- Iterar sobre todas as tabelas visíveis no schema public
    FOR table_rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    LOOP
        -- Encontrar o maior valor presente na tabela
        BEGIN
            EXECUTE format('SELECT MAX(%I) FROM %I', 'id', table_rec.table_name) INTO max_id;
            
            -- Ajustar a sequence para o próximo número maior
            IF max_id IS NOT NULL THEN
                EXECUTE format('SELECT SETVAL(pg_get_serial_sequence(''%I'', ''%I''), %s)', table_rec.table_name, 'id', max_id + 1);
            END IF;
        EXCEPTION
            WHEN undefined_column THEN
                -- Se a coluna 'id' não existir na tabela, pular para a próxima tabela
                CONTINUE;
        END;
    END LOOP;
END $$;
