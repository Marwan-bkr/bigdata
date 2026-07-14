-- Ensure the database exists (if you have permissions)
CREATE DATABASE IF NOT EXISTS spring_gr01;

-- Set the current database context
USE spring_gr01;

-- Drop if exists to avoid "already exists" errors during testing
DROP TABLE IF EXISTS login_nyc_drivers;
DROP TABLE IF EXISTS login_nyc_drivers_ext;

-- Create the Managed ORC table
CREATE EXTERNAL TABLE spring_gr01.login_nyc_drivers_ext (
  driver_id INT,
  name STRING,
  ssn INT,
  location STRING,
  certified STRING,
  wage_plan STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/education/spring_gr01/login/lab4/nyc_drivers/drivers.csv'
TBLPROPERTIES ('skip.header.line.count'='1');


CREATE TABLE spring_gr01.login_nyc_drivers (
  driver_id INT,
  first_name STRING,
  last_name STRING,
  ssn STRING,
  address STRING,
  certified BOOLEAN,
  wage_plan STRING
)
STORED AS ORC;
