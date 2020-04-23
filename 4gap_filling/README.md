# Gap filling and other data procedures

Fill_ML.m is the main script that will have to be executed to perform the gap-filling. This script references all the other included functions and will result in folders ML_tmin, ML_tmax, and ML_prcp. These folders contain ML learning output and QC'd data for each of the snotel stations. The IDne_info files are also produced by the Fill_ML.m script. These files calculate the distance between stations and find the ones that are closest to the station of interest. These "close by" stations are used as inputs in the random forest ML algorithm. 

GapFill_Merge.m is then used to infill missing and quality controlled values with those produced my the ML algorithm. This script produces a .csv files written to dataCSV that will be used as inputs for meteorological simulations.

resultsCheck.m can be used to compile statistics about how the comparison between quality controlled / ML data and original data. 











