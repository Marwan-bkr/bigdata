USE spring_gr01;

-- 1. Clean up old tables
DROP TABLE IF EXISTS login_lab7_ext;
DROP TABLE IF EXISTS login_lab7_wordcount;

-- 2. Create External Table using Regex to skip the byte offsets (numbers)
-- This creates the 'actual_word' column you use in your SELECT below
CREATE EXTERNAL TABLE login_lab7_ext (
    offset_val STRING,
    actual_word STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = "(\\d+)\\s+(.*)"
)
LOCATION '/education/spring_gr01/login/lab7-2/word-count';

-- 3. Create the Final Parquet Table
CREATE TABLE login_lab7_wordcount (
    word STRING,
    frequency INT
)
STORED AS PARQUET;

-- 4. Perform the WordCount Logic
-- We explode the 'actual_word' column which contains the raw text lines
INSERT OVERWRITE TABLE login_lab7_wordcount
SELECT 
    LOWER(TRIM(exploded_word)) as word, 
    COUNT(*) as frequency
FROM (
    SELECT actual_word FROM login_lab7_ext
) t
LATERAL VIEW explode(split(actual_word, ' ')) exploded_table AS exploded_word
WHERE exploded_word != '' 
GROUP BY LOWER(TRIM(exploded_word));

-- 5. Check your results!
SELECT * FROM login_lab7_wordcount 
ORDER BY frequency DESC 
LIMIT 10;
