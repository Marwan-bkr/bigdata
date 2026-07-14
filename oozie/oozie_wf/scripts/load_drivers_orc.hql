INSERT INTO TABLE spring_gr01.login_nyc_drivers
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
FROM spring_gr01.login_nyc_drivers_ext;
