# Read the BCQC data, do some initial screening, and convert to .mat files

If you don't have access to a repository with the Dep. of Energy data, the database will have to be download from https://dhsvm.pnnl.gov/bcqc_snotel_data.stm. I've put this data into the folder bcqc_data.

1) This data does not have fields for the elevation or the station ID. So, run the FIND_snoTEL_elevation&IDs.m file in the first folder to find them. 

2) Use the scripts CREATE_BCQC_MATFILES.m to make a .mat files that contain station data. Set an inpath to the data and an output path to where the new .mat files will be written.

