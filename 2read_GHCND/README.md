# Read the GHCND data, do some initial screening, and convert to .mat files

If you don't have access to a data repository with GHCND data, the data will have to be download from https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/global-historical-climatology-network-ghcn. Use the main script GHCN_read.m. This script references all the other functions, a subnet mask NA_DEM_010deg_trim, and a couple documents, ghcnd-inventory.txt and ghcnd-stations.txt. This documents will be included in the download from the above website under the folder ghcnd_docs. Set an inpath to the data and an output path where the new .mat files will be created.



