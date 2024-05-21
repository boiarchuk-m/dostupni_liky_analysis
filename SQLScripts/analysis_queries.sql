-- Table prescriptions

--fix date_value type
ALTER TABLE prescriptions 
ADD COLUMN date_value DATE;

UPDATE prescriptions 
SET date_value = TO_DATE(date_period || '-01', 'YYYY-MM-DD');


--find NULL values
SELECT * 
FROM 
	prescriptions 
WHERE NOT (prescriptions  IS NOT NULL);

-- Number of prescriptions based of innms group
SELECT 
	innms_groups, 
	COUNT(*) AS num_prescriptions
FROM 
	prescriptions
GROUP BY 
	innms_groups
ORDER BY 
	num_prescriptions DESC

-- Number of prescriptions by the year
SELECT 
	EXTRACT(YEAR FROM date_value) as year, 
	SUM(count_prescription) AS num_prescriptions
FROM 
	prescriptions
GROUP BY 1
ORDER BY 2 DESC


-- number of prescriptions by division area
SELECT 
	division_area, 
	SUM(count_prescription) AS num_prescriptions
FROM 
	prescriptions
GROUP BY 1
ORDER BY 2 DESC


-- Table pharmacies

--one of the problems with this table is that null values is stored as a string "NULL" not NULL type
SELECT *
FROM pharmacies
WHERE lng ='NULL'
OR lat ='NULL'

UPDATE pharmacies
SET lng = NULL
WHERE lng ='NULL'

UPDATE pharmacies
SET lat = NULL
WHERE lat ='NULL'

-- Find null values
SELECT * 
FROM pharmacies 
WHERE NOT (pharmacies IS NOT NULL);

--find maximum and minimum number of medical programs
SELECT 
	MAX(array_length(medical_programs_in_divisions, 1)) AS max_programs, 
	MIN(array_length(medical_programs_in_divisions, 1)) AS min_programs
FROM pharmacies


--number of pharmacies by available programs
SELECT
	program_name,
    COUNT(*) AS divisions_num
FROM
    (SELECT UNNEST(medical_programs_in_divisions) AS program_name FROM pharmacies) AS unnested
GROUP BY
    program_name
ORDER BY divisions_num DESC;
	
--number of pharmacies by property_type
SELECT 
	legal_entity_property_type, 
	COUNT(*) AS num_pharmacies
FROM pharmacies
GROUP BY 1
ORDER BY 2 DESC;

--number of pharmacies by division_type
SELECT 
	division_type, 
	COUNT(*) AS num_pharmacies
FROM 
	pharmacies
GROUP BY 1
ORDER BY 2 DESC;

--number of pharmacies by division_area
SELECT 
	division_area, 
	COUNT(*) AS num_pharmacies
FROM 
	pharmacies
GROUP BY 1
ORDER BY 2 DESC;














