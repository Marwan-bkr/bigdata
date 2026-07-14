-- Ensure the database exists (if you have permissions)
CREATE DATABASE IF NOT EXISTS spring_gr01;

-- Set the current database context
USE spring_gr01;

-- Drop if exists to avoid "already exists" errors during testing
DROP TABLE IF EXISTS login_lab7_wordcount;
DROP TABLE IF EXISTS login_lab7_ext;

CREATE TABLE spring_gr01.login_lab7_ext (
    word STRING,
    count INT
) 
STORED AS TEXTFILE;

LOAD DATA INPATH '/education/spring_gr01/login/lab7-2/word-count' INTO TABLE spring_gr01.login_lab7_ext;

CREATE TABLE spring_gr01.login_lab7_wordcount (
    word STRING,
    count INT
) 
STORED AS PARQUET;

INSERT OVERWRITE TABLE spring_gr01.login_lab7_wordcount
SELECT t.word, count(*) 
FROM spring_gr01.login_lab7_ext
LATERAL VIEW explode(split(word, ' ')) t AS word 
GROUP BY t.word;
