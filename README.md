# A workflow for the quality control and gap-filling of snoTEL data

This document a describes a workflow that:
-	Downloads snoTEL data from the US department of Energy and converts it into .matfiles
-	Performs quality control checks and screens snoTEL data according to established methods
-	Concatenates the the data and QC information into a single netCDF file
-	And uses a random forest machine learning algorithm to infill the missing data.

The workflow can be recreated by following the instructions found within the folders. The workflow accesses folders in the subsequent order:
1)	1read_BCQC
2)	2quality_control
3)	3unify_data
4)	4gap_fill
