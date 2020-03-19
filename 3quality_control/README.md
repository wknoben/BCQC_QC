# Perform QC on the GHCND data

Quality control procedures are performed according to global historical climate network daily methods. These methods are described in https://www.ncdc.noaa.gov/ghcn-daily-methods and are also described in greater detail by Durre et al., (2008,2010). Quality control for precipitation is also preformed according to (Beck et al., 2020) and 

The main script is QC_main.m. Paths will have to be set to find .mat input files and a gaugeInfo.mat files. QC_gaugeLength.m is a simple script that screens out stations with insufficient data from the gaugeInfo.mat file. 

# References

Beck, H. E., Wood, E. F., McVicar, T. R., Zambrano-Bigiarini, M., Alvarez-Garreton, C., Baez-Villanueva, O. M., ... & Karger, D. N. (2020). Bias correction of global high-resolution precipitation climatologies using streamflow observations from 9372 catchments. Journal of Climate, 33(4), 1299-1315.

Durre, I., Menne, M. J., Gleason, B. E., Houston, T. G., & Vose, R. S. (2010). Comprehensive automated quality assurance of daily surface observations. Journal of Applied Meteorology and Climatology, 49(8), 1615-1633.

Durre et al., 2008 Durre, I., Menne, M. J., & Vose, R. S. (2008). Strategies for evaluating quality assurance procedures. Journal of Applied Meteorology and Climatology, 47(6), 1785-1791.

Hamada, A., Arakawa, O., & Yatagai, A. (2011). An automated quality control method for daily rain-gauge data. Global Environ. Res, 15(2), 183-192.
	
