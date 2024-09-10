# pg-manticore

pg-manticore is an extension for PostgreSQL which allows to integrate Sphinx/Manticore Search Engine.  

## Installation

### Compile
```sh
make
```

### Install
```sh
sudo make install
```

### Define manticore functions in your database
Superuser is required.  
```sh
echo 'CREATE EXTENSION manticore;' | psql -U postgres mydatabase
```

### Uninstall
```sh
sudo make uninstall
```

## Configuration

Extension can be configured by modifying corresponding rows in table sphinx_config.  
Following options are available: 'host', 'post', 'username', 'password', 'prefix'.  

'Prefix' is a string which is prepended to index names. This option is useful to simulate  
namespaces. For example, if prefix is 'test_' and index name in a request is 'blog_posts',  
real request will be addressed to index named 'test_blog_posts'.  


## Functions

### Search query (uses MATCH(query) construction)
```sql
sphinx_select(
  /*index*/     varchar,
  /*query*/     varchar,
  /*condition*/ varchar,
  /*order*/     varchar,
  /*offset*/    int,
  /*limit*/     int,
  /*options*/   varchar)
```
Returns (id) rows.  

### Insert data
```sql
sphinx_insert(
  /*index*/     varchar,
  /*id*/        int,
  /*data*/      varchar[])
```
Create document with specified id. Data array must have following format:  
```ARRAY['key1', 'value2', ...]```

### Update data (REPLACE INTO for updating full-text-indexing-columns only)
```sql
sphinx_replace(
  /*index*/     varchar,
  /*id*/        int,
  /*data*/      varchar[])
```
Updates document with specified id. Data array must have following format:  
```ARRAY['key1', 'value2', ...]```

### Update data (UPDATE for updating non-full-text-indexing-columns only)
```sql
sphinx_update(
  /*index*/     varchar,
  /*query*/     varchar,
  /*condition*/ varchar,
  /*data*/      varchar[])
```
query can be empty string/NULL — you can use `condition = 'id = 1'` only  

Updates document with specified id. Data array must have following format:  
```ARRAY['key1', 'value2', ...]```

### Delete data
```sql
sphinx_delete(
  /*index*/     varchar,
  /*id*/        int)
```
Removes specified document.  

### TRUNCATE index
```sql
sphinx_truncate(
  /*index*/     varchar,
  /*type*/      varchar)
```
TRUNCATE index, `type = 'RTINDEX'` for rt index type.  

### Get snippet
```sql
sphinx_snippet(
  /*index*/     varchar,
  /*query*/     varchar,
  /*data*/      varchar,
  /*before*/    varchar,
  /*after*/     varchar)
```
Returns snippets for a given data and search query.  
  
Example:  
```sql
SELECT sphinx_snippet('blog_posts', 'photo', 'There are photos from monday meeting', '<b>', '</b>')
```
This query will return following text:  
```
'There are <b>photos</b> from monday meeting'
```

```sql
sphinx_snippet_options(
  /*index*/     varchar,
  /*query*/     varchar,
  /*data*/      varchar,
  /*options*/   varchar[])
```
Returns snippets for a given data and search query.  
This function is similar to sphinx_snippet but it also  
accepts a list of additional options.  
  
Because of array type limitations all values must be represented as text.  
Integer values have to be represented as decimal values (e. g. '19').  
For boolean values '1', 't', 'true', 'y', and 'yes' are recognized as true,  
any other value is considered as false.  
  
Example (similar to previous one):  
```sql
SELECT sphinx_snippet_options('blog_posts', 'photo', 'There are photos from monday meeting',
                              ARRAY['before_match', '<b>',
                                    'after_match', '</b>'])
```

One more example:  
```sql
SELECT sphinx_snippet_options('blog_posts', 'photo', 'There are photos from monday meeting',
                              ARRAY['before_match', '<b>',
                                    'after_match', '</b>',
                                    'query_mode', 'yes'])
```


