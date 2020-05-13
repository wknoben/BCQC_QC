clc;clear;close
%% read GHCN-D data
% Plato Linux path
% Inpath='/datastore/GLOBALWATER/CommonData/Prcp_GMET/GHCN-D/ghcnd_all';
% Outpath='/home/cjh458/ghcnd_ST/ghcnd_all/';

Inpath='/Users/cjh458/Desktop/snoTEL_QC/2read_GHCND/ghcnd_all';
Outpath='/Users/cjh458/Desktop/snoTEL_QC/2read_GHCND/ghcnd_QC';

% Infile_inventory='/datastore/GLOBALWATER/CommonData/Prcp_GMET/GHCN-D/documents/ghcnd-inventory.txt';
% Infile_station='/datastore/GLOBALWATER/CommonData/Prcp_GMET/GHCN-D/documents/ghcnd-stations.txt';

Infile_inventory='/Users/cjh458/Desktop/snoTEL_QC/2read_GHCND/ghcnd_docs/ghcnd-inventory.txt';
Infile_station='/Users/cjh458/Desktop/snoTEL_QC/2read_GHCND/ghcnd_docs/ghcnd-stations.txt';

Infile_mask='/Users/cjh458/Desktop/snoTEL_QC/2read_GHCND/ghcnd_scripts/NA_DEM_010deg_trim.asc';
% Infile_mask='/Users/localuser/GMET/Gauge_Reanalysis2/NA_DEM_010deg_trim.asc';

Outfile_station=[Outpath,'/GaugeValid.mat']; 
BasicInfo.period_range=[2017,2018]; % [start year, end year]
BasicInfo.period_len=[1,100]; % the least/most number of years that are within period_range
% BasicInfo.VarOut={'Date(yyyymmdd)','Precipitation(mm)','Snowfall(mm in depth)','Tmin(C)','Tmax(C)','Tmean(C)'};
% BasicInfo.VarRead={'PRCP','SNOW','TMIN','TMAX','TAVG'};
% BasicInfo.scalefactor=[0.1, 1, 0.1, 0.1, 0.1];
BasicInfo.VarOut={'Date(yyyymmdd)','Precipitation(mm)','SWE(kgm-2)','Sdepth(m)','Tmin(C)','Tmax(C)'};%,'WindSpd(m/s)','WindDir(°)'};
BasicInfo.VarRead={'PRCP','WESD','SNWD','TMAX','TMIN'};%,'AWND','AWDR'};
BasicInfo.scalefactor=[0.1, 0.1, 0.1, 0.1, 0.1];%, 0.1, 1];
BasicInfo.missingvalue=[-9999, -9999, -9999, -9999, -9999];%, -9999, -9999];
% two ways for to extract rain gauges
% (1) lat/lon extent
% SR.seflag=1;
% SR.lat_range=[0,90]; % latitude range
% SR.lon_range=[-180,0]; % longitude range
% (2) spatial mask
BasicInfo.seflag=2;
BasicInfo.maskfile=Infile_mask;

Overwrite=1; % 1 overwrite Outfile_station. If the criteria are changed, Outfile_station must be created or overwrited.
f_GHCN_read(Inpath,Infile_inventory,Infile_station,BasicInfo,Outpath,Outfile_station,Overwrite);