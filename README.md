# A workflow for the quality control and gap-filling of snoTEL data

This document a describes a workflow that:
-	Acquires meteorological data from the national oceanographic and atmospheric administration's GHCND (Global Historical Climatology Network Daily) database.
-	Finds the GHCND ID numbers that correspond to the USDA’s Snow Telemetry Data Collection Network (snoTEL). 
-	Performs quality control checks and screens snoTEL data according to established methods
-	Concatenates the the QC'd data into a single netCDF file
-	And uses a random forest machine learning algorithm to infill the missing data.


The workflow can be recreated by following the instructions found within the folders con. The workflow accesses folders in the subsequent order:
1)	1find_stations
2)	2read_GHCND
3)	3quality_control
4)	4unify_data
5)	5gap_fill
