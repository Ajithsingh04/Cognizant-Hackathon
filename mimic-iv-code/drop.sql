DO $$
DECLARE
    schema_name TEXT := 'mimic_hosp';
    table_to_modify TEXT := 'hcpcsevents';
    keep_columns TEXT[] := ARRAY['hcpcs_cd','short_description'];
    col RECORD;
BEGIN
    FOR col IN
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = schema_name
        AND table_name = table_to_modify
        AND column_name NOT IN (SELECT unnest(keep_columns))
    LOOP
        EXECUTE format('ALTER TABLE %I.%I DROP COLUMN %I;', schema_name, table_to_modify, col.column_name);
    END LOOP;
END $$;

