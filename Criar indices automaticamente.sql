DO $$
DECLARE
    v_table_name text := 'contagem'; -- Substitua 'contagem' pelo nome da sua tabela
    columns text[] := '{}';
    index_sql text;
    col_count int;
    index_counter int := 1;
BEGIN
    -- Obtenção das colunas, exceto as de tipo 'character varying' e 'id'
    SELECT array_agg(column_name::text)
    INTO columns
    FROM information_schema.columns
    WHERE table_name = v_table_name
      AND data_type != 'character varying'
      AND column_name NOT IN ('id');

    -- Obter o número de colunas
    col_count := array_length(columns, 1);
    
    -- Verificação se há colunas suficientes para combinar
    IF col_count IS NULL OR col_count < 2 THEN
        RAISE NOTICE 'Não há colunas suficientes para formar combinações.';
        RETURN;
    END IF;

    -- Criação dos índices
    FOR i IN 1..col_count LOOP
        FOR j IN i+1..col_count LOOP
            index_sql := format('CREATE INDEX %s_idx_%s ON %s (%s, %s);', 
                                v_table_name, index_counter, v_table_name, columns[i], columns[j]);
            RAISE NOTICE '%', index_sql;
            index_counter := index_counter + 1;
        END LOOP;
    END LOOP;
END $$;
