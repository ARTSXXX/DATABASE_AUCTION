--- 1ый способ ЭКСПОРТ
CREATE TEMP TABLE lots_tmp AS
SELECT * FROM Лоты;

copy (
  SELECT ROW_TO_JSON("lots_tmp") FROM "lots_tmp"
) TO 'D:\asd.json';

-- Очищение при необходимости
DROP TABLE lots_tmp;


-- ИМПОРТ
CREATE TEMP TABLE temp_lots_json (
  id_Лота INTEGER,
  Название VARCHAR(255),
  Описание VARCHAR,
  Изображение VARCHAR(255)
);


	CREATE OR REPLACE FUNCTION IMPORT_LOTS_FROM_JSON_FILE(FILE_PATH TEXT)
	RETURNS TABLE (
		id_Лота INTEGER,
		Название VARCHAR(255),
		Описание VARCHAR,
		Изображение VARCHAR(255)
	) AS $$
	DECLARE 
	  JSON_DATA JSON;
	  LOT_DATA JSON;
	BEGIN
	  CREATE TEMPORARY TABLE IF NOT EXISTS temp_lots_json (
		id_Лота INTEGER,
		Название VARCHAR(255),
		Описание VARCHAR,
		Изображение VARCHAR(255)
	  );
	  DELETE FROM temp_lots_json;
	  JSON_DATA := PG_READ_FILE(FILE_PATH, 0, 1000000000)::JSON;
	  FOR LOT_DATA IN SELECT * FROM JSON_ARRAY_ELEMENTS(JSON_DATA)
	  LOOP
		INSERT INTO temp_lots_json (id_Лота, Название, Описание, Изображение)
		VALUES (
		  cast(LOT_DATA->>'id_Лота' as INTEGER), 
		  LOT_DATA->>'Наименование', 
		  LOT_DATA->>'Описание', 
		  LOT_DATA->>'Изображение'
		);
	  END LOOP;
	  RETURN QUERY SELECT * FROM temp_lots_json;
	END;
	$$ LANGUAGE PLPGSQL;

SELECT * FROM IMPORT_LOTS_FROM_JSON_FILE('D:\asd.json');




--- 2ый способ
-- Импорт данных в XML
COPY (SELECT xmlagg(xmlforest(Лоты.*)) FROM Лоты) TO 'E:/file.xml';

COPY (SELECT xmlagg(xmlforest(Аукционы.*)) FROM Аукционы) TO 'E:/file1.xml';

-- Экспорт данных 

SELECT pg_read_file('E:/file.xml', 0, length(pg_read_file('E:/file.xml')))

SELECT pg_read_file('E:/file1.xml', 0, length(pg_read_file('E:/file1.xml')))
