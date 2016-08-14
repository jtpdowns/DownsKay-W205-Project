DROP TABLE IF EXISTS school_data_init;
CREATE TABLE school_data_init AS
SELECT INSTNM AS name, 
	STABBR  AS state, 
	CASE 
		WHEN LENGTH(zip) = 4 THEN CONCAT('0' , zip)
		WHEN LENGTH(zip) = 5 THEN zip
		WHEN LENGTH(zip) = 8 THEN CONCAT('0', SUBSTRING(zip,1,4))
		WHEN LENGTH(zip) IN (9,10) THEN SUBSTRING(zip,1,5)
	END AS zip,
	CASE WHEN count_wne_p10 IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(count_wne_p10 AS int) END as count_wne_p10,
	CASE WHEN count_nwne_p10 IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(count_nwne_p10 AS int) END as count_nwne_p10,
	CASE WHEN md_earn_wne_p10 IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(md_earn_wne_p10 AS float) END as md_earn_wne_p10,
	CASE WHEN COSTT4_A IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(COSTT4_A AS float) END as COSTT4_A,
	CASE WHEN COSTT4_P IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(COSTT4_P AS float) END as COSTT4_P,
	CASE WHEN C150_4 IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(C150_4 AS float) END as C150_4,
	CASE WHEN C150_L4 IN ('NULL', 'PrivacySuppressed') THEN NULL
	ELSE CAST(C150_L4 AS float) END as C150_L4
FROM school_data
where LENGTH(zip) not in (3,6)
;

DROP TABLE IF EXISTS school_entity;
CREATE TABLE school_entity AS
SELECT name 
	,state
	,zip
	,CASE WHEN COSTT4_A IS NOT NULL THEN COSTT4_A ELSE COSTT4_P END AS cost
	,count_wne_p10 * 1.0/(count_wne_p10+count_nwne_p10) as percent_grads_employed
	,md_earn_wne_p10 as median_grad_earning
	,CASE WHEN C150_4 IS NOT NULL THEN C150_4 ELSE C150_L4 END AS graduation_rate
FROM school_data_init
;

DROP TABLE IF EXISTS community_entity;
CREATE TABLE community_entity AS
SELECT zipcode as zip
      ,sum(cast(agi_stub as float)* cast(N1 as float))/sum(cast(N1 as float)) as weighted_wealth_score
  FROM irs_data
  group by zipcode
;
  
DROP TABLE IF EXISTS state_entity;
CREATE TABLE state_entity AS
SELECT state_gdp_data.GeoName AS state
	, state_abbreviations.Abbreviation 
	, state_gdp_data.year_2013 AS gdp_per_capita
	, RANK() OVER (ORDER BY state_gdp_data.year_2013) as gdp_per_capita_rank
FROM state_gdp_data JOIN state_abbreviations
ON state_gdp_data.GeoName = state_abbreviations.state_name
where state_gdp_data.Description = 'All industry total' 
AND ComponentName = 'Per capita real GDP by state'
;  


