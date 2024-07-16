--Este script SQL é projetado para gerar e imprimir comandos de criação de índices para uma tabela específica no PostgreSQL,
--excluindo aquelas do tipo 'character varying' e 'id', e gera todas as combinações possíveis de duas colunas.

DO $$
DECLARE
    v_table_name text := 'convocacao_ativa'; -- Substitua 'sua_tabela' pelo nome da sua tabela
    col record;
    columns text[] := '{}';
    index_sql text;
    col_count int;
    index_counter int := 1;
BEGIN
    FOR col IN
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = v_table_name
          AND data_type != 'character varying'
          AND column_name not in ('id')
    LOOP
        columns := array_append(columns, col.column_name);
    END LOOP;
    col_count := array_length(columns, 1);
    IF col_count IS NULL OR col_count < 2 THEN
        RAISE NOTICE 'Não há colunas suficientes para formar combinações.';
        RETURN;
    END IF;
    FOR i IN 1..col_count LOOP
        FOR j IN i+1..col_count LOOP
            index_sql := format('CREATE INDEX %s_idx_%s ON %s (%s, %s);', 
                                v_table_name, index_counter, v_table_name, columns[i], columns[j]);
            RAISE NOTICE '%', index_sql;
            index_counter := index_counter + 1;
        END LOOP;
    END LOOP;
END $$;