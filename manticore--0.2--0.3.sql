CREATE OR REPLACE FUNCTION sphinx_snippet_options(
  /*index*/     varchar,
  /*query*/     varchar,
  /*data*/      varchar,
  /*options*/   varchar[])
RETURNS VARCHAR
AS 'manticore', 'pg_sphinx_snippet_options'
LANGUAGE C IMMUTABLE;

