USE spring_gr01;

DROP TABLE IF EXISTS login_AI_Human_stream_ext;

CREATE TABLE spring_gr01.login_AI_Human_stream_ext (
    text STRING,
    generated DOUBLE
) 
STORED AS PARQUET;

LOAD DATA INPATH '${SOURCE_PATH}' INTO TABLE spring_gr01.login_AI_Human_stream_ext;
