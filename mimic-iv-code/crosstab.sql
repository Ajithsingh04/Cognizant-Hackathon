CREATE OR REPLACE FUNCTION generate_pivot()
RETURNS void AS $$
DECLARE
  col_list text;
  pivot_query text;
BEGIN
  -- Generate column list with itemid values directly as column names
  SELECT string_agg(format('%s', quote_ident(itemid::text)), ', ')
  INTO col_list
  FROM (SELECT DISTINCT itemid FROM mimiciv_icu.chartevents ORDER BY itemid) sub;

  -- Generate crosstab query
  pivot_query := format('
    SELECT * FROM crosstab(
      ''SELECT charttime, itemid, valuenum FROM mimiciv_icu.chartevents ORDER BY charttime, itemid'',
      ''SELECT DISTINCT itemid FROM mimiciv_icu.chartevents ORDER BY itemid''
    ) AS ct(charttime timestamp, %s);
  ', col_list);

  -- Execute dynamic query
  EXECUTE pivot_query;
END $$
LANGUAGE plpgsql;


