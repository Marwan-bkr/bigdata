# Big Data Ecosystem

## Hive Warehouse

### Create an external table

```sql
SET hivevar:user=username;
SET hivevar:group=spring_gr01;
SET hivevar:hiveUsername=hiveusername;

CREATE EXTERNAL TABLE spring_gr01.hiveusername_nyc_drivers_ext (
  driver_id INT,
  name STRING,
  ssn INT,
  location STRING,
  certified STRING,
  wage_plan STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/education/spring_gr01/hiveusername/lab4/nyc_drivers/drivers.csv'
TBLPROPERTIES ('skip.header.line.count'='1');
```

### Create a managed ORC table

```sql
CREATE TABLE ${group}.${hiveUsername}_nyc_drivers (
  driver_id INT,
  first_name STRING,
  last_name STRING,
  ssn STRING,
  address STRING,
  certified BOOLEAN,
  wage_plan STRING
)
STORED AS ORC;
```

```bash
hdfs dfs -ls /warehouse/tablespace/managed/hive/${GROUP}.db/
```

![](local-images/73661e359fc2b495242a9444918223a8f75efc9c.png)

### Load data from the CSV table to the ORC table

```sql
INSERT INTO TABLE spring_gr01.hiveusername_nyc_drivers
SELECT 
  driver_id,
  split(name, ' ')[0] AS first_name,
  split(name, ' ')[1] AS last_name,
  ssn,
  location AS address,
  CASE 
    WHEN LOWER(certified) = 'y' THEN true 
    ELSE false 
  END AS certified,
  wage_plan
FROM spring_gr01.hiveusername_nyc_drivers_ext;
```

![](local-images/5f86dd2221b24e1b9d5f0b4d22215e68820ea14e.png)

```sql
SELECT * FROM spring_gr01.hiveusername_nyc_drivers
```

![](local-images/820371cd669f13f5d074068da5f3498e67eacdff.png)

________________________________________________________________________________________________

## Hive Query Language

### Queries

```sql
USE spring_gr01;
SELECT * FROM imdb_name_basics;
```

Sometimes, the session timed out. Thus we need to quit with :

```bash
!quit
```

and execute 'beeline' again.

```sql
SELECT COUNT(*) FROM imdb_title_basics WHERE runtimeMinutes > 120;
```

![](local-images/371cbf8678a8e318011a0805d5cf08836acc1597.png)

```sql
SELECT AVG(runtimeMinutes) 
FROM spring_gr01.imdb_title_basics 
WHERE primaryTitle RLIKE '\\b[Ww]orld\\b';
```

![](local-images/e4ae894287f0bf934f747f3c6d3fdd41d51a32d1.png)

```sql
SELECT AVG(r.averageRating) 
FROM spring_gr01.imdb_title_ratings r
JOIN spring_gr01.imdb_title_basics b ON r.tconst = b.tconst
WHERE b.genres LIKE '%Comedy%';
```

![](local-images/873030901d48dee016d213b8cc55e2cab31768df.png)

```sql
SELECT AVG(r.averageRating) 
FROM spring_gr01.imdb_title_ratings r
JOIN spring_gr01.imdb_title_basics b ON r.tconst = b.tconst
WHERE b.genres NOT LIKE '%Comedy%' OR b.genres IS NULL;
```

![](local-images/77c96af4b0aedee315e632c66a2e899ad1538687.png)

- ```sql
  SELECT 
    b.primaryTitle, 
    r.averageRating 
  FROM spring_gr01.imdb_title_basics b
  JOIN spring_gr01.imdb_title_ratings r ON b.tconst = r.tconst
  JOIN spring_gr01.imdb_title_crew c ON b.tconst = c.tconst
  JOIN spring_gr01.imdb_name_basics n ON n.primaryName = 'Quentin Tarantino'
  WHERE array_contains(c.director, n.nconst)
  ORDER BY r.averageRating DESC 
  LIMIT 5;
  ```

![](local-images/f282b05568b88c21584aed8c87b63dae75b30740.png)