DROP TABLE IF EXISTS school_rank;
CREATE TABLE school_rank AS
select 
name
,state
,zip
,earning_rank
,earning_per_cost_rank
,graduation_rate_rank
,graduation_rate_per_cost_rank
,percent_grads_employed_rank
,percent_grads_employed_per_cost_rank
,(earning_rank+graduation_rate_rank+percent_grads_employed_rank)*1.0/3 as rank_avg
,RANK() OVER (ORDER BY earning_rank+graduation_rate_rank+percent_grads_employed_rank) as rank_avg_rank
,(earning_per_cost_rank+graduation_rate_per_cost_rank+percent_grads_employed_per_cost_rank)*1.0/3 as per_cost_rank_avg
,RANK() OVER (ORDER BY earning_per_cost_rank+graduation_rate_per_cost_rank+percent_grads_employed_per_cost_rank) as per_cost_rank_avg_rank
from
(
SELECT name
,state
,zip
,RANK() OVER (ORDER BY median_grad_earning ) as earning_rank
,RANK() OVER (ORDER BY median_grad_earning/cost ) as earning_per_cost_rank
,RANK() OVER (ORDER BY graduation_rate ) as graduation_rate_rank
,RANK() OVER (ORDER BY graduation_rate/cost ) as graduation_rate_per_cost_rank
,RANK() OVER (ORDER BY percent_grads_employed ) as percent_grads_employed_rank
,RANK() OVER (ORDER BY percent_grads_employed/cost ) as percent_grads_employed_per_cost_rank
FROM school_entity
WHERE cost IS NOT NULL
AND	median_grad_earning IS NOT NULL
AND graduation_rate IS NOT NULL
AND percent_grads_employed IS NOT NULL
) temp
;

DROP TABLE IF EXISTS school_community_scores;
CREATE TABLE school_community_scores AS
SELECT school_rank.*, community_entity.weighted_wealth_score, 
RANK() OVER (ORDER BY community_entity.weighted_wealth_score ) as weighted_wealth_rank
FROM school_rank
JOIN community_entity
ON school_rank.zip = community_entity.zip
;


DROP TABLE IF EXISTS school_wealth_correl;
CREATE TABLE school_wealth_correl AS
select 
 corr(earning_rank, weighted_wealth_rank) as earn_wealth_correl
,corr(earning_per_cost_rank, weighted_wealth_rank) as earn_per_cost_wealth_correl
,corr(graduation_rate_rank, weighted_wealth_rank) as grad_wealth_correl
,corr(graduation_rate_per_cost_rank, weighted_wealth_rank) as grad_per_cost_wealth_correl
,corr(percent_grads_employed_rank, weighted_wealth_rank) as empl_wealth_correl
,corr(percent_grads_employed_per_cost_rank, weighted_wealth_rank) as empl_per_cost_wealth_correl
,corr(rank_avg_rank, weighted_wealth_rank) as oarank_wealth_correl
,corr(per_cost_rank_avg_rank, weighted_wealth_rank) as oarank_per_cost_wealth_correl
from school_community_scores;

DROP TABLE IF EXISTS school_state_scores;
CREATE TABLE school_state_scores AS 
SELECT school_rank.*, state_entity.state as state_fullname, state_entity.gdp_per_capita, 
state_entity.gdp_per_capita_rank
FROM school_rank
JOIN state_entity
ON school_rank.state = state_entity.Abbreviation
;

DROP TABLE IF EXISTS school_gdp_correl;
CREATE TABLE school_gdp_correl AS
select 
 corr(earning_rank, gdp_per_capita_rank) as earn_gdp_correl
,corr(earning_per_cost_rank, gdp_per_capita_rank) as earn_per_cost_gdp_correl
,corr(graduation_rate_rank, gdp_per_capita_rank) as grad_gdp_correl
,corr(graduation_rate_per_cost_rank, gdp_per_capita_rank) as grad_per_cost_gdp_correl
,corr(percent_grads_employed_rank, gdp_per_capita_rank) as empl_gdp_correl
,corr(percent_grads_employed_per_cost_rank, gdp_per_capita_rank) as empl_per_cost_gdp_correl
,corr(rank_avg_rank, gdp_per_capita_rank) as oarank_gdp_correl
,corr(per_cost_rank_avg_rank, gdp_per_capita_rank) as oarank_per_cost_gdp_correl
from school_state_scores;

