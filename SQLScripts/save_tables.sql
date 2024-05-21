create extension tablefunc;

--prescriptions for each region by year
SELECT * FROM crosstab(
'SELECT 
	division_area AS region,
	EXTRACT (YEAR FROM date_value) AS year, 
	SUM(count_prescription) AS num_prescriptions
FROM 
	prescriptions
GROUP BY
	division_area,
	EXTRACT (YEAR FROM date_value)') AS 
	prescriptions_by_regions(division_area VARCHAR(50), "2019" numeric, 
							 "2020" numeric, "2021" numeric, "2022" numeric,
							 "2023" numeric, "2024" numeric)
	

--number of pharmacies by settlement_type
SELECT 
	division_settlement_type, 
	COUNT(*) AS num_of_pharmacies
FROM 
	pharmacies
GROUP BY
	division_settlement_type
	
--number of prescriptions by innms groups
SELECT 
	innms_groups,
	SUM(count_prescription) AS num_prescriptions,
	ROUND(SUM(count_prescription) *100 /(SELECT SUM(count_prescription) FROM prescriptions), 3) 
	AS prescriptions_precent
FROM 
	prescriptions
GROUP BY
	innms_groups
	


-- number of vilages by division area and year
SELECT * FROM crosstab(
'SELECT 
	division_area,  
	EXTRACT (YEAR FROM date_value) AS year,
	COUNT(DISTINCT(division_settlement)) AS num_settlements
FROM 
	prescriptions
WHERE division_settlement_type = ''село'' OR division_settlement_type=''селище''
GROUP BY 
	division_area, 
	EXTRACT (YEAR FROM date_value)',
'SELECT DISTINCT EXTRACT (YEAR FROM date_value) FROM prescriptions ORDER BY 1'
)AS 
	settlements_num_by_regions(division_area VARCHAR(50),
							   "2019" bigint, "2020" bigint, "2021" bigint, "2022" bigint,
											   "2023" bigint, "2024" bigint)


-- number of pharmacies for each year
WITH num_pharm AS(
SELECT CAST(DATE_TRUNC('year', legal_entity_inserted_at) AS Date) as date_added,
COUNT(*) as num_pharmacies
FROM pharmacies
GROUP BY 1
ORDER BY 1)

SELECT date_added, SUM(num_pharmacies) OVER(ORDER BY date_added) AS total_num_pharmacies
FROM num_pharm




-- number of settlements by type for each year
SELECT * FROM crosstab(
'SELECT  
	EXTRACT (YEAR FROM date_value) AS year,
	division_settlement_type, 
	COUNT(DISTINCT(division_settlement)) AS num_settlements
FROM 
	prescriptions
GROUP BY 
	EXTRACT (YEAR FROM date_value),
	division_settlement_type')
	AS settlements_types_by_years(year numeric, місто bigint, селище bigint, село bigint, смт bigint)



--prescriptions by year
SELECT 
	EXTRACT (YEAR FROM date_value) AS year, 
	SUM(count_prescription) AS num_prescription
FROM prescriptions
GROUP BY 1


	

