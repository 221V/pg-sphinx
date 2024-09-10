

------------------------------------------------------------------------
-- sphinx.conf

-- # for search by -- name, text
-- index test1_rt
-- {
--   type = rt
--   path = /var/lib/manticore/data/test1_rt
--   # rt_mem_limit = 512M
-- 
--   #rt_attr_bigint = id # will created by default
--   rt_attr_uint = lang
--   rt_attr_bool = is_show
--   rt_field = name
--   rt_field = text1
-- }
-- # CREATE TABLE test1_rt (id BIGINT, lang INT, is_show BOOL, name TEXT, text1 TEXT);

------------------------------------------------------------------------

-- sphinx_select(index, match, condition, order, offset, limit, options)
SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);
 id
----
(0 rows)

-- sphinx_insert(index, id, data_array)
SELECT sphinx_insert('test1_rt', 1, ARRAY['name', 'назва', 'text1', 'це довгий текст List of Dell gaming laptops', 'lang', '1', 'is_show', '1']::text[]);
 sphinx_insert
---------------
(1 row)

-- sphinx_replace(index, id, data_array)
SELECT sphinx_replace('test1_rt', 2, ARRAY['name', 'назва2', 'text1', 'це дуже довгий текст List of cool gaming laptops', 'lang', '3', 'is_show', '1']::text[]);
 sphinx_replace
----------------
(1 row)

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);
 id
----
  2
  1
(2 rows)

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0 AND is_show = 1', 'id DESC', 0, 100, NULL);
 id
----
  1
(1 row)

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0 AND is_show = 0', 'id DESC', 0, 100, NULL);
 id
----
(0 rows)

SELECT * FROM sphinx_select('test1_rt', 'laptops', '', '', 0, 100, NULL);
 id
----
  1
(1 row)

SELECT * FROM sphinx_select('test1_rt', 'довгий', '', '', 0, 100, NULL);
 id
----
  1
(1 row)

SELECT * FROM sphinx_select('test1_rt', 'lap', '', '', 0, 100, NULL);
 id
----
(0 rows)

SELECT * FROM sphinx_select('test1_rt', 'довги', '', '', 0, 100, NULL);
 id
----
(0 rows)

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);
 id
----
  1
(1 row)

-- UPDATE only for non-full-text-indexing-columns
-- UPDATE test1_rt SET is_show = 0 WHERE id = 1; # 0 IS FALSE
SELECT sphinx_update('test1_rt', '', 'id = 1', ARRAY['is_show', '0']::text[]);
 sphinx_update
---------------
(1 row)

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);
 id
----
  1
(1 row)

-- REPLACE for updating full-text-indexing-columns
-- REPLACE INTO test1_rt(id, name, text1, lang, is_show) VALUES(1, 'без назви', 'це короткий текст List of Dell gaming laptops', 2, 0); # 1 IS TRUE, 0 IS FALSE
SELECT sphinx_replace('test1_rt', 1, ARRAY['name', 'без назви', 'text1', 'це короткий текст List of Dell gaming laptops', 'lang', '2', 'is_show', '0']::text[]);

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);

SELECT * FROM sphinx_select('test1_rt', 'довгий', '', '', 0, 100, NULL);

SELECT * FROM sphinx_select('test1_rt', 'laptops', '', '', 0, 100, NULL);

SELECT * FROM sphinx_select('test1_rt', 'назв', '', '', 0, 100, NULL);

SELECT * FROM sphinx_select('test1_rt', 'назви', '', '', 0, 100, NULL);

SELECT * FROM sphinx_select('test1_rt', 'короткий', '', '', 0, 100, NULL);

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);

-- TRUNCATE RTINDEX test1_rt;
SELECT sphinx_truncate('test1_rt', 'RTINDEX');
 sphinx_truncate
-----------------
(1 row)

SELECT * FROM sphinx_select('test1_rt', '', 'id > 0', 'id DESC', 0, 100, NULL);
 id
----
(0 rows)

-- DESCRIBE test1_rt;
-- todo add sphinx_describe
-- todo think maybe needs to add something else

