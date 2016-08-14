#!/bin/bash
#
# Download the data
wget -O scorecard.csv "https://collegescorecard.ed.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv"
#
wget -O irs_data.csv "https://www.irs.gov/pub/irs-soi/13zpallagi.csv"
#
wget -O state_populations.csv "https://www.census.gov/popest/data/national/totals/2015/files/NST-EST2015-alldata.csv"

wget -O zip_populations.csv "https://s3.amazonaws.com/SplitwiseBlogJB/2010+Census+Population+By+Zipcode+(ZCTA).csv"

wget -O state_abbreviations.csv "http://www.fonz.net/blog/wp-content/uploads/2008/04/states.csv"

#remove headers and rename desired files
tail -n +2 "scorecard.csv" > scorecard_no_headers.csv
tail -n +2 "irs_data.csv" > irs_data_no_headers.csv
tail -n +2 "gsp_naics_all.csv" > state_gdp.csv
tail -n +2 "state_populations.csv" > state_populations_no_headers.csv
tail -n +2 "zip_populations.csv" > zip_populations_no_headers.csv
tail -n +2 "state_abbreviations.csv" > state_abbreviations_no_headers.csv

#
#create hdfs directories
hdfs  dfs  -mkdir /user/w205/final_project
hdfs  dfs  -mkdir /user/w205/final_project/scorecard
hdfs  dfs  -mkdir /user/w205/final_project/irs_data
hdfs  dfs  -mkdir /user/w205/final_project/state_gdp
hdfs  dfs  -mkdir /user/w205/final_project/state_populations
hdfs  dfs  -mkdir /user/w205/final_project/zip_populations
hdfs  dfs  -mkdir /user/w205/final_project/state_abbreviations
#
#put data into hdfs
hdfs  dfs  -put scorecard_no_headers.csv /user/w205/final_project/scorecard
hdfs  dfs  -put irs_data_no_headers.csv /user/w205/final_project/irs_data
hdfs  dfs  -put state_gdp.csv /user/w205/final_project/state_gdp
hdfs  dfs  -put state_populations_no_headers.csv /user/w205/final_project/state_populations
hdfs  dfs  -put zip_populations_no_headers.csv /user/w205/final_project/zip_populations
hdfs  dfs  -put state_abbreviations_no_headers.csv /user/w205/final_project/state_abbreviations
