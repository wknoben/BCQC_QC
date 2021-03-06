% save independent station files in one netcdf4 file
%%%%%%%%%%%%%GHCND
% clc;clear;close all
% Inpath='/Users/cjh458/Desktop/Guoqiang_WF/3quality_control/ghcnd_QC_TP1';
% filePath='/Users/cjh458/Desktop/Guoqiang_WF/4unify_data/ghcnd_UNI';
% mkdir(filePath);
% Outfile='/Users/cjh458/Desktop/Guoqiang_WF/4unify_data/ghcnd_UNI/AllGauge_QC.nc4';
% % Outfile='/Users/cjh458/Desktop/Guoqiang_WF/4unify_data/ghcnd_UNI/AllGauge_QC_noflags.nc4';

%%%%%%%%%%%%%BCQC
clc;clear;close all
Gaugepath='/Users/cjh458/Desktop/BCQC_QC/1read_BCQC';
Inpath='/Users/cjh458/Desktop/BCQC_QC/2quality_control/QC_TP_bcqc';
filePath='/Users/cjh458/Desktop/BCQC_QC/3unify_data/bcqc_UNI';
mkdir(filePath);
Outfile='/Users/cjh458/Desktop/BCQC_QC/3unify_data/bcqc_UNI/AllGauge_QC_bcqc_noflags.nc4';
% Outfile='/Users/cjh458/Desktop/Guoqiang_WF/4unify_data/ghcnd_UNI/AllGauge_QC_noflags.nc4';

% mac path
% Inpath='/Users/localuser/Research/AllGauge_QC';
% Outfile='/Users/localuser/Research/AllGauge_QC.nc4';

Year=[2017,2018];

% station infomation
FileInfo=[Gaugepath,'/gaugeInfo_bcqc.mat'];
% load('/Users/cjh458/Desktop/Guoqiang_WF/3quality_control/gaugeInfo1.mat') %load the most current gaugeInfo.mat file
load(FileInfo,'ID','LLE');
nstn=length(ID);
ID1=ID;

% date information
date=datenum(Year(1),1,1):datenum(Year(2),9,30);
nday=length(date);
date=datestr(date,'yyyymmdd');
date=mat2cell(date,ones(nday,1),8);
date=str2double(date);

% initialize all variables
prcp=single(nan*zeros(nday,nstn));  tmin=single(nan*zeros(nday,nstn));  tmax=single(nan*zeros(nday,nstn));
prcp_qfraw=single(nan*zeros(nday,nstn));  tmin_qfraw=single(nan*zeros(nday,nstn));  tmax_qfraw=single(nan*zeros(nday,nstn));
prcp_qf=single(nan*zeros(nday,nstn));  tmin_qf=single(nan*zeros(nday,nstn));  tmax_qf=single(nan*zeros(nday,nstn));
mflag=single(nan*zeros(nday,nstn));

% read all kinds of station data for different sources
for i=1:nstn
    fprintf('reading %d--%d\n',i,nstn);
    load(FileInfo,'ID','LLE');
    filei=[Inpath,'/bcqc_',num2str(ID{i}),'.mat'];
    load(filei);
    sourceTemp=char(ID1{i});
    sourcei=ID;%(1:2);
    [datai,qfrawi,qfi,mfi]=f_read(filei,sourcei,date);         
    
    prcp(:,i)=datai(:,1); tmin(:,i)=datai(:,5); tmax(:,i)=datai(:,4);
    prcp_qfraw(:,i)=qfrawi(:,1); tmin_qfraw(:,i)=qfrawi(:,2); tmax_qfraw(:,i)=qfrawi(:,3);
    
    prcp_qf(:,i)=qfi(:,1); tmin_qf(:,i)=qfi(:,2); tmax_qf(:,i)=qfi(:,3);
    

%     netCDF file that has no quality control flags for testing.
    prcp_qfraw(:,i)=0; tmin_qfraw(:,i)=0; tmax_qfraw(:,i)=0;  %Created vars with no QC flags 
    prcp_qfraw(:,i)=0; tmin_qfraw(:,i)=0; tmax_qfraw(:,i)=0;  %Created vars with no QC flags
    mflag(:,i)=1; %mfi;
    
end

overwrite=1;
f_save_stn(Outfile,ID1,LLE,date,prcp,tmin,tmax,...
    prcp_qfraw,tmin_qfraw,tmax_qfraw,...
    prcp_qf,tmin_qf,tmax_qf,mflag,overwrite);


