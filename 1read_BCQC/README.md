# Read the BCQC data, do some initial screening, and convert to .mat files

If you don't have access to a repository with the data, the database will have to be download from https://dhsvm.pnnl.gov/bcqc_snotel_data.stm. Use the scripts CREATE_BCQC_MATFILES.m and CREATE_gaugeInfo_bcqc.m to make a gaugeInfo.mat file and other .mat files, which correspond to station data. Set an inpath to the data and an output path to where the new .mat files will be written.

